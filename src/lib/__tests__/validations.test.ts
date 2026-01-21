import { describe, it, expect } from 'vitest';
import { validateForm, sanitizeString, SLUG_REGEX } from '../validations';
import { ISection, FieldType } from '@/types';

describe('validations', () => {
    describe('SLUG_REGEX', () => {
        it('should accept valid slugs', () => {
            expect(SLUG_REGEX.test('my-form')).toBe(true);
            expect(SLUG_REGEX.test('form-123')).toBe(true);
            expect(SLUG_REGEX.test('simple')).toBe(true);
        });

        it('should reject invalid slugs', () => {
            expect(SLUG_REGEX.test('My-Form')).toBe(false);
            expect(SLUG_REGEX.test('form_123')).toBe(false);
            expect(SLUG_REGEX.test('form 123')).toBe(false);
            expect(SLUG_REGEX.test('form@123')).toBe(false);
        });
    });

    describe('validateForm', () => {
        const validSection: ISection = {
            id: 'sec1',
            title: 'Section 1',
            order_index: 0,
            is_repeatable: false,
            questions: [
                {
                    id: 'q1',
                    question_text: 'Question 1',
                    field_type: FieldType.SHORT_TEXT,
                    is_required: true,
                    order_index: 0,
                },
            ],
        };

        it('should pass validation for valid form', () => {
            const result = validateForm('My Form', 'my-form', [validSection]);
            expect(result.isValid).toBe(true);
            expect(result.errors).toHaveLength(0);
        });

        it('should fail if title is empty', () => {
            const result = validateForm('', 'my-form', [validSection]);
            expect(result.isValid).toBe(false);
            expect(result.errors).toContain('Form title is required.');
        });

        it('should fail if slug is empty', () => {
            const result = validateForm('My Form', '', [validSection]);
            expect(result.isValid).toBe(false);
            expect(result.errors).toContain('Form slug is required.');
        });

        it('should fail if slug has invalid characters', () => {
            const result = validateForm('My Form', 'My-Form', [validSection]);
            expect(result.isValid).toBe(false);
            expect(result.errors).toContain('Form slug must contain only lowercase letters, numbers, and hyphens.');
        });

        it('should fail if no sections', () => {
            const result = validateForm('My Form', 'my-form', []);
            expect(result.isValid).toBe(false);
            expect(result.errors).toContain('Form must have at least one section.');
        });

        it('should fail if section has no questions', () => {
            const emptySection: ISection = {
                ...validSection,
                questions: [],
            };
            const result = validateForm('My Form', 'my-form', [emptySection]);
            expect(result.isValid).toBe(false);
            expect(result.errors.some(e => e.includes('must have at least one field'))).toBe(true);
        });

        it('should fail if duplicate question IDs exist', () => {
            const duplicateSection: ISection = {
                ...validSection,
                questions: [
                    validSection.questions[0],
                    { ...validSection.questions[0], question_text: 'Question 2' },
                ],
            };
            const result = validateForm('My Form', 'my-form', [duplicateSection]);
            expect(result.isValid).toBe(false);
            expect(result.errors.some(e => e.includes('Duplicate field ID'))).toBe(true);
        });
    });

    describe('sanitizeString', () => {
        it('should remove script tags', () => {
            const input = 'Hello <script>alert("xss")</script> World';
            const output = sanitizeString(input);
            expect(output).not.toContain('<script>');
            expect(output).toContain('Hello');
            expect(output).toContain('World');
        });

        it('should handle empty strings', () => {
            expect(sanitizeString('')).toBe('');
        });

        it('should handle null/undefined', () => {
            expect(sanitizeString(null as any)).toBe(null);
            expect(sanitizeString(undefined as any)).toBe(undefined);
        });

        it('should preserve safe HTML if using DOMPurify', () => {
            const input = 'Hello <b>World</b>';
            const output = sanitizeString(input);
            // DOMPurify allows safe tags like <b>
            expect(output).toContain('Hello');
            expect(output).toContain('World');
        });
    });
});
