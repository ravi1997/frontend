import { describe, it, expect } from 'vitest';
import { generateFormStructure } from '../aiService';
import { FieldType } from '@/types';

describe('aiService', () => {
    it('should generate job application form', async () => {
        const response = await generateFormStructure('Create a job application');
        expect(response.sections).toHaveLength(2);

        const firstSection = response.sections[0];
        expect(firstSection.title).toBe('Personal Information');
        expect(firstSection.questions).toHaveLength(3);
        expect(firstSection.questions[0].field_type).toBe(FieldType.SHORT_TEXT);
    });

    it('should generate feedback form', async () => {
        const response = await generateFormStructure('feedback form');
        expect(response.sections).toHaveLength(1);
        expect(response.sections[0].title).toBe('Feedback');
        expect(response.sections[0].questions).toHaveLength(2);
    });

    it('should fallback to default for unknown prompt', async () => {
        const response = await generateFormStructure('something random');
        expect(response.sections).toHaveLength(1);
        expect(response.sections[0].title).toBe('New Section');
    });
});
