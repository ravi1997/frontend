import { describe, it, expect, vi, beforeEach, afterEach, type Mock } from 'vitest';
import api, { ApiError } from './api';

describe('API 401 Handling', () => {
    beforeEach(() => {
        global.fetch = vi.fn();
        // Mock window.location because api.ts checks it
        vi.stubGlobal('location', {
            href: '',
            pathname: '/',
        });
    });

    afterEach(() => {
        vi.restoreAllMocks();
        vi.unstubAllGlobals();
    });

    it('should throw an error and log to console when 401 is returned', async () => {
        const consoleErrorSpy = vi.spyOn(console, 'error').mockImplementation(() => { });

        const mockResponse = {
            ok: false,
            status: 401,
            statusText: 'UNAUTHORIZED',
            headers: new Headers(),
            json: async () => ({ message: 'UNAUTHORIZED' }),
            text: async () => 'UNAUTHORIZED'
        };

        (global.fetch as Mock).mockResolvedValue(mockResponse);

        // Expect it to throw "UNAUTHORIZED" (based on response.message)
        await expect(api.get('/test-endpoint')).rejects.toThrow('UNAUTHORIZED');

        // We should NOT log 401 errors as they are handled/expected
        expect(consoleErrorSpy).not.toHaveBeenCalled();
    });

    it('should handle Network Errors gracefully', async () => {
        const consoleErrorSpy = vi.spyOn(console, 'error').mockImplementation(() => { });
        (global.fetch as Mock).mockRejectedValue(new Error('NetworkError when attempting to fetch resource.'));

        // Expect it to throw the error
        await expect(api.get('/test-endpoint')).rejects.toThrow('NetworkError when attempting to fetch resource.');

        // Currently it LOGS this error. Check if that matches current behavior.
        // We expect it to be normalized now, so it might still log, but let's check structure.
        expect(consoleErrorSpy).toHaveBeenCalledWith('API Request Error:', expect.objectContaining({
            message: 'NetworkError when attempting to fetch resource.',
            status: 0
        }));

        try {
            await api.get('/test-endpoint');
        } catch (err: unknown) {
            const error = err as ApiError;
            expect(error.status).toBe(0);
            expect(error.response).toBeDefined();
            expect(error.response?.status).toBe(0);
        }
    });
});
