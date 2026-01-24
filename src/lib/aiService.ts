import { ISection } from '@/types';
import api, { ApiError } from './api';

export interface GenerateFormResponse {
    sections: ISection[];
    suggestion?: string;
    error?: string;
    is_mock?: boolean;
}

interface AIQuestion {
    question_text?: string;
    label?: string;
    [key: string]: unknown;
}

interface AISection {
    questions?: AIQuestion[];
    [key: string]: unknown;
}

interface AISuggestion {
    sections: AISection[];
    description: string;
}

interface AIResponseData {
    suggestion?: AISuggestion;
    [key: string]: unknown;
}

export const generateFormStructure = async (prompt: string, currentSections?: ISection[]): Promise<GenerateFormResponse> => {
    try {
        const payload: Record<string, unknown> = { prompt };

        if (currentSections && currentSections.length > 0) {
            payload.current_form = { sections: currentSections };
        }

        const response = await api.post<AIResponseData>('/ai/generate', payload);
        const data = response.data;

        if (data.suggestion) {
            const sections = data.suggestion.sections.map((section: AISection) => ({
                ...section,
                questions: section.questions ? section.questions.map((q: AIQuestion) => ({
                    ...q,
                    question_text: q.question_text || q.label // Map label to question_text
                })) : []
            })) as unknown as ISection[];

            return {
                sections,
                suggestion: data.suggestion.description,
            };
        }

        return data as unknown as GenerateFormResponse;
    } catch (err: unknown) {
        const error = err as ApiError;
        console.error('AI Service Error:', error);

        // Check if it's a configuration error (503) and return a helpful message
        if (error.response?.status === 503) {
            return {
                sections: [],
                error: 'AI Service is not configured. Please add LLM_API_KEY to your environment.',
                is_mock: true
            };
        }

        if (error.response?.status === 401) {
            return {
                sections: [],
                error: 'AI authorization failed. Your session may have expired or you are not authorized to use this feature.',
                is_mock: true
            };
        }

        const message = (error.response?.data as { error?: string })?.error || (error instanceof Error ? error.message : 'Failed to generate form structure');

        throw new Error(message);
    }
};
