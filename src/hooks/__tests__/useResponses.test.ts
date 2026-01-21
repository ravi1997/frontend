import 'global-jsdom/register';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderWithProviders } from '@/test/test-utils';
import { useResponses } from '../useResponses';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { act } from '@testing-library/react';

vi.mock('@/lib/api', () => ({
    default: {
        get: vi.fn(),
    },
}));

// Mock URL.createObjectURL and revokeObjectURL
if (typeof window !== 'undefined') {
    window.URL.createObjectURL = vi.fn(() => 'blob:abc');
    window.URL.revokeObjectURL = vi.fn();
}
global.URL.createObjectURL = vi.fn(() => 'blob:abc');
global.URL.revokeObjectURL = vi.fn();

describe('useResponses', () => {
    beforeEach(() => {
        vi.clearAllMocks();
        if (typeof document !== 'undefined' && !document.body) {
            document.body = document.createElement('body');
        }
    });

    it('should trigger CSV export', async () => {
        const mockBlob = new Blob(['col1,col2'], { type: 'text/csv' });
        vi.mocked(api.get).mockResolvedValueOnce({ data: mockBlob });

        const link = {
            href: '',
            setAttribute: vi.fn(),
            click: vi.fn(),
            remove: vi.fn(),
        };

        const originalCreateElement = document.createElement.bind(document);
        const createElementSpy = vi.spyOn(document, 'createElement').mockImplementation((tagName) => {
            if (tagName === 'a') return link as any;
            return originalCreateElement(tagName);
        });

        const appendChildSpy = vi.spyOn(document.body, 'appendChild').mockImplementation((node) => {
            if (node === (link as any)) return node as any;
            return node;
        });

        const { result } = renderWithProviders(() => useResponses());

        await act(async () => {
            await result.current.exportCsv('form-123');
        });

        await vi.waitFor(() => {
            expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.FORMS.EXPORT_CSV('form-123'), expect.objectContaining({
                responseType: 'blob'
            }));
            expect(link.setAttribute).toHaveBeenCalledWith('download', 'responses_form-123.csv');
            expect(link.click).toHaveBeenCalled();
        });

        createElementSpy.mockRestore();
        appendChildSpy.mockRestore();
    });

    it('should trigger JSON export', async () => {
        const mockData = JSON.stringify({ test: 1 });
        vi.mocked(api.get).mockResolvedValueOnce({ data: mockData });

        const link = {
            href: '',
            setAttribute: vi.fn(),
            click: vi.fn(),
            remove: vi.fn(),
        };

        const originalCreateElement = document.createElement.bind(document);
        const createElementSpy = vi.spyOn(document, 'createElement').mockImplementation((tagName) => {
            if (tagName === 'a') return link as any;
            return originalCreateElement(tagName);
        });

        const appendChildSpy = vi.spyOn(document.body, 'appendChild').mockImplementation((node) => {
            if (node === (link as any)) return node as any;
            return node;
        });

        const { result } = renderWithProviders(() => useResponses());

        await act(async () => {
            await result.current.exportJson('form-123');
        });

        await vi.waitFor(() => {
            expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.FORMS.EXPORT_JSON('form-123'), expect.objectContaining({
                responseType: 'blob'
            }));
            expect(link.setAttribute).toHaveBeenCalledWith('download', 'responses_form-123.json');
            expect(link.click).toHaveBeenCalled();
        });

        createElementSpy.mockRestore();
        appendChildSpy.mockRestore();
    });
});
