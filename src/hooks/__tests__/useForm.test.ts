import 'global-jsdom/register';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderWithProviders } from '@/test/test-utils';
import { useForm } from '../useForm';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { act } from '@testing-library/react';

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

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.FORMS.CREATE, expect.any(Object));
    });

    it('should handle composite save action', async () => {
        const formResponse = { form_id: 'form-123' };
        const versionResponse = { version_id: 'v1' };

        vi.mocked(api.post)
            .mockResolvedValueOnce({ data: formResponse })
            .mockResolvedValueOnce({ data: versionResponse });

        const { result } = renderWithProviders(() => useForm());

        const formId = await result.current.saveNewForm(
            { title: 'T', description: 'D', slug: 's', is_public: true },
            []
        );

        expect(formId).toBe('form-123');
        expect(api.post).toHaveBeenCalledTimes(2);
    });

    it('should show alert on error', async () => {
        const errorResponse = {
            response: {
                data: { message: 'Database Error' }
            }
        };
        vi.mocked(api.post).mockRejectedValueOnce(errorResponse);

        const { result } = renderWithProviders(() => useForm());

        await act(async () => {
            await result.current.createForm.mutate({ title: 'T', description: 'D', slug: 's', is_public: true });
        });

        // Wait for error callback
        await vi.waitFor(() => {
            expect(global.alert).toHaveBeenCalledWith('Database Error');
        });
    });
});
