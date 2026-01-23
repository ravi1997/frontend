import { ISection } from '@/types';
import axios from 'axios';
import api from './api';

export interface GenerateFormResponse {
    sections: ISection[];
    suggestion?: string;
    error?: string;
    is_mock?: boolean;
}

export const generateFormStructure = async (prompt: string): Promise<GenerateFormResponse> => {
    try {
        const response = await api.post('/ai/generate', { prompt });
        return response.data;
    } catch (error: unknown) {
        console.error('AI Service Error:', error);

        // Check if it's a configuration error (503) and return a helpful message
        if (axios.isAxiosError(error) && error.response?.status === 503) {
            return {
                sections: [],
                error: 'AI Service is not configured. Please add LLM_API_KEY to your environment.',
                is_mock: true
            };
        }

        const message = axios.isAxiosError(error)
            ? error.response?.data?.error
            : error instanceof Error ? error.message : 'Failed to generate form structure';

        throw new Error(message || 'Failed to generate form structure');
    }
};
