import { ISection, FieldType } from '@/types';
import { v4 as uuidv4 } from 'uuid';

export interface GenerateFormResponse {
    sections: ISection[];
    suggestion?: string;
}

export const generateFormStructure = async (prompt: string): Promise<GenerateFormResponse> => {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 1500));

    // Simple keyword-based mock generation
    const sections: ISection[] = [];
    const lowerPrompt = prompt.toLowerCase();

    const createSection = (title: string): ISection => ({
        id: uuidv4(),
        title,
        order_index: sections.length,
        is_repeatable: false,
        questions: []
    });

    if (lowerPrompt.includes('job') || lowerPrompt.includes('application')) {
        const sec1 = createSection('Personal Information');
        sec1.questions.push(
            { id: uuidv4(), question_text: 'Full Name', field_type: FieldType.SHORT_TEXT, is_required: true, order_index: 0 },
            { id: uuidv4(), question_text: 'Email', field_type: FieldType.EMAIL, is_required: true, order_index: 1 },
            { id: uuidv4(), question_text: 'Phone', field_type: FieldType.MOBILE, is_required: true, order_index: 2 }
        );
        sections.push(sec1);

        const sec2 = createSection('Experience');
        sec2.questions.push(
            { id: uuidv4(), question_text: 'Years of Experience', field_type: FieldType.NUMBER, is_required: true, order_index: 0 },
            { id: uuidv4(), question_text: 'Resume', field_type: FieldType.FILE_UPLOAD, is_required: true, order_index: 1 }
        );
        sections.push(sec2);
    } else if (lowerPrompt.includes('feedback')) {
        const sec1 = createSection('Feedback');
        sec1.questions.push(
            { id: uuidv4(), question_text: 'Overall Satisfaction', field_type: FieldType.RATING, is_required: true, order_index: 0 },
            { id: uuidv4(), question_text: 'Comments', field_type: FieldType.LONG_TEXT, is_required: false, order_index: 1 }
        );
        sections.push(sec1);
    } else {
        // Default generic form
        const sec1 = createSection('New Section');
        sec1.questions.push(
            { id: uuidv4(), question_text: 'Question 1', field_type: FieldType.SHORT_TEXT, is_required: true, order_index: 0 }
        );
        sections.push(sec1);
    }

    return { sections };
};
