import 'global-jsdom/register';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderWithProviders } from '@/test/test-utils';
import { useForms } from '../useForms';
import api from '@/lib/api';


vi.mock('@/lib/api', () => ({
    default: {
        get: vi.fn(),
    },
}));

describe('useForms', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('should fetch and normalize forms list (array format)', async () => {
        const mockForms = [{ id: '1', title: 'Form 1' }];
        vi.mocked(api.get).mockResolvedValueOnce({ data: mockForms });

        const { result } = renderWithProviders(() => useForms());

        await vi.waitFor(() => {
            expect(result.current.isLoading).toBe(false);
            expect(result.current.forms).toEqual(mockForms);
            expect(result.current.totalForms).toBe(1);
        });
    });

    it('should fetch and normalize forms list (paginated format)', async () => {
        const mockResponse = {
            forms: [{ id: '1', title: 'Form 1' }],
            total: 10,
            page: 1,
            limit: 5
        };
        vi.mocked(api.get).mockResolvedValueOnce({ data: mockResponse });

        const { result } = renderWithProviders(() => useForms());

        await vi.waitFor(() => {
            expect(result.current.isLoading).toBe(false);
            expect(result.current.forms).toEqual(mockResponse.forms);
            expect(result.current.totalForms).toBe(10);
        });
    });

    it('should handle fetch error', async () => {
        vi.mocked(api.get).mockRejectedValueOnce(new Error('Network Error'));

        const { result } = renderWithProviders(() => useForms());

        await vi.waitFor(() => {
            expect(result.current.isLoading).toBe(false);
            expect(result.current.error).toBeDefined();
            expect(result.current.forms).toEqual([]);
        });
    });
});
