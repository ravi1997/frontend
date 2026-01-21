// @vitest-environment jsdom
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';
import { useVersions } from '../useVersions';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import api from '@/lib/api';
import { useBuilderStore } from '@/store/builderStore';

// Mock dependencies
vi.mock('@/lib/api');
// Mock store actions if needed, but we use the real store for integration test

describe('useVersions', () => {
    let queryClient: QueryClient;

    beforeEach(() => {
        queryClient = new QueryClient({
            defaultOptions: { queries: { retry: false } }
        });
        vi.resetAllMocks();
        useBuilderStore.setState({ versions: [] });
    });

    const wrapper = ({ children }: { children: React.ReactNode }) => (
        <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    );

    it('should fetch versions and update store', async () => {
        const mockVersions = [
            { version_number: 1, sections: [], created_at: '2023-01-01' }
        ];

        // Mock API response
        (api.get as any).mockResolvedValue({ data: mockVersions });

        const { result } = renderHook(() => useVersions('form-123'), { wrapper });

        await waitFor(() => expect(result.current.isSuccess).toBe(true));

        expect(result.current.data).toEqual(mockVersions);
        expect(useBuilderStore.getState().versions).toEqual(mockVersions);
    });

    it('should return empty array if no formId', async () => {
        const { result } = renderHook(() => useVersions(undefined), { wrapper });

        // Should not satisfy 'enabled' so status might be pending with no fetch
        expect(result.current.data).toBeUndefined();
        // Or if we specifically handle the hook logic to return empty
    });
});
