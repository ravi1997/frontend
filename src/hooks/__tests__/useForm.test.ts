import 'global-jsdom/register';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderWithProviders } from '@/test/test-utils';
import { useForm } from '../useForm';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { act } from '@testing-library/react';
import { ISection, FieldType } from '@/types';

vi.mock('@/lib/api', () => ({
    default: {
        post: vi.fn(),
    },
}));

vi.mock('next/navigation', () => ({
    useRouter: () => ({
        push: vi.fn(),
    }),
}));

// Mock alert
global.alert = vi.fn();

describe('useForm', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

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

    it('should create a form shell', async () => {
        const mockForm = { form_id: 'new-form-id' };
        vi.mocked(api.post).mockResolvedValueOnce({ data: mockForm });

        const { result } = renderWithProviders(() => useForm());

        await act(async () => {
            const data = await result.current.createForm.mutateAsync({
                title: 'Test Form',
                description: 'Test Description',
                slug: 'test-form',
                is_public: true
            });
            expect(data).toEqual(mockForm);
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.FORMS.CREATE, expect.objectContaining({
            title: 'Test Form',
            slug: 'test-form',
        }));
    });

    it('should handle composite save action', async () => {
        const formResponse = { form_id: 'form-123' };
        const versionResponse = { version_id: 'v1' };

        vi.mocked(api.post)
            .mockResolvedValueOnce({ data: formResponse })
            .mockResolvedValueOnce({ data: versionResponse });

        const { result } = renderWithProviders(() => useForm());

        const formId = await result.current.saveNewForm(
            { title: 'Test Form', description: 'Description', slug: 'test-form', is_public: true },
            [validSection]
        );

        expect(formId).toBe('form-123');
        expect(api.post).toHaveBeenCalledTimes(2);
    });

    it('should reject invalid form data', async () => {
        const { result } = renderWithProviders(() => useForm());

        await expect(async () => {
            await result.current.saveNewForm(
                { title: '', description: 'D', slug: 'test', is_public: true },
                [validSection]
            );
        }).rejects.toThrow('Validation failed');

        expect(global.alert).toHaveBeenCalledWith(expect.stringContaining('Validation failed'));
    });

    it('should show alert on API error', async () => {
        const errorResponse = {
            response: {
                data: { message: 'Database Error' }
            }
        };
        vi.mocked(api.post).mockRejectedValueOnce(errorResponse);

        const { result } = renderWithProviders(() => useForm());

        await act(async () => {
            try {
                await result.current.createForm.mutateAsync({
                    title: 'Test',
                    description: 'Desc',
                    slug: 'test',
                    is_public: true
                });
            } catch (e) {
                // Expected to throw
            }
        });

        // Wait for error callback
        await vi.waitFor(() => {
            expect(global.alert).toHaveBeenCalledWith('Database Error');
        });
    });
});
