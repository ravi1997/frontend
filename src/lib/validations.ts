import DOMPurify from 'dompurify';
import { ISection, IQuestion } from '@/types';

export const SLUG_REGEX = /^[a-z0-9-]+$/;

export interface ValidationResult {
    isValid: boolean;
    errors: string[];
}

export const validateForm = (
    title: string,
    slug: string,
    sections: ISection[]
): ValidationResult => {
    const errors: string[] = [];

    // 1. Title Validation
    if (!title || title.trim().length === 0) {
        errors.push('Form title is required.');
    }

    // 2. Slug Validation
    if (!slug) {
        errors.push('Form slug is required.');
    } else if (!SLUG_REGEX.test(slug)) {
        errors.push('Form slug must contain only lowercase letters, numbers, and hyphens.');
    }

    // 3. Sections & Fields Validation
    if (!sections || sections.length === 0) {
        errors.push('Form must have at least one section.');
    } else {
        const fieldIds = new Set<string>();
        let totalFields = 0;

        sections.forEach((section, sIdx) => {
            if (!section.title || section.title.trim().length === 0) {
                errors.push(`Section ${sIdx + 1} must have a title.`);
            }

            if (!section.questions || section.questions.length === 0) {
                errors.push(`Section "${section.title || sIdx + 1}" must have at least one field.`);
            } else {
                totalFields += section.questions.length;
                section.questions.forEach((question: IQuestion) => {
                    if (fieldIds.has(question.id)) {
                        errors.push(`Duplicate field ID detected: ${question.id}`);
                    }
                    fieldIds.add(question.id);
                });
            }
        });

        if (totalFields === 0) {
            errors.push('Form must have at least one field.');
        }
    }

    return {
        isValid: errors.length === 0,
        errors,
    };
};

export const sanitizeString = (input: string): string => {
    // If input is empty/null, return as is
    if (!input) return input;

    if (typeof window !== 'undefined') {
        return DOMPurify.sanitize(input);
    }
    // Minimal fallback if running on server (though this is a 'use client' hook context)
    return input.replace(/<[^>]*>?/gm, '');
};
