import 'global-jsdom/register';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderWithProviders } from '@/test/test-utils';
import { useAuth } from '../useAuth';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { act } from '@testing-library/react';

// Mock dependencies
vi.mock('@/lib/api', () => ({
    default: {
        get: vi.fn(),
        post: vi.fn(),
    },
}));

vi.mock('next/navigation', () => ({
    useRouter: () => ({
        push: vi.fn(),
    }),
}));

const mockAuthStore = {
    user: null,
    isAuthenticated: false,
    setUser: vi.fn(),
    setLastLoginMethod: vi.fn(),
    logout: vi.fn(),
};

vi.mock('@/store/authStore', () => ({
    useAuthStore: () => mockAuthStore,
}));

// Mock alert
global.alert = vi.fn();

describe('useAuth', () => {
    beforeEach(() => {
        vi.clearAllMocks();
        localStorage.clear();
        document.cookie = '';
    });

    it('should fetch user status on mount', async () => {
        const userData = { id: '1', email: 'test@example.com' };
        vi.mocked(api.get).mockResolvedValueOnce({ data: userData });

        renderWithProviders(() => useAuth());

        // Wait for query to resolve
        await vi.waitFor(() => {
            expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS);
            expect(mockAuthStore.setUser).toHaveBeenCalledWith(userData);
        });
    });

    it('should handle login success', async () => {
        const authResponse = {
            access_token: 'fake-token',
            user: { id: '1', email: 'test@example.com' }
        };
        vi.mocked(api.post).mockResolvedValueOnce({ data: authResponse });
        vi.mocked(api.get).mockResolvedValue({ data: null }); // user-status

        const { result } = renderWithProviders(() => useAuth());

        // Wait for initial user fetch
        await vi.waitFor(() => expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS));

        await act(async () => {
            await result.current.loginAsync({ email: 'test@example.com', password: 'password' });
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.LOGIN, {
            identifier: 'test@example.com',
            password: 'password'
        });
        expect(localStorage.getItem('access_token')).toBe('fake-token');
        expect(mockAuthStore.setUser).toHaveBeenCalledWith(authResponse.user);
    });

    it('should handle registration success', async () => {
        vi.mocked(api.post).mockResolvedValueOnce({ data: { success: true } });
        vi.mocked(api.get).mockResolvedValue({ data: null });

        const { result } = renderWithProviders(() => useAuth());

        // Wait for initial user fetch
        await vi.waitFor(() => expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS));

        await act(async () => {
            await result.current.registerAsync({
                username: 'tester',
                email: 't@e.com',
                mobile: '1234567890',
                password: 'p',
                confirm_password: 'p',
                user_type: 'general',
                roles: []
            });
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.REGISTER, expect.any(Object));
    });

    it('should handle mobile login', async () => {
        vi.mocked(api.post).mockResolvedValueOnce({ data: { access_token: 't' } });
        vi.mocked(api.get).mockResolvedValue({ data: null });

        const { result } = renderWithProviders(() => useAuth());

        // Wait for initial user fetch
        await vi.waitFor(() => expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS));

        await act(async () => {
            await result.current.loginAsync({ mobile: '12345', password: 'p' });
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.LOGIN, expect.objectContaining({
            identifier: '12345'
        }));
    });

    it('should handle fetch user status failure', async () => {
        vi.mocked(api.get).mockRejectedValueOnce(new Error('Unauthorized'));

        renderWithProviders(() => useAuth());

        await vi.waitFor(() => {
            expect(mockAuthStore.setUser).toHaveBeenCalledWith(null);
        });
    });

    it('should handle logout', async () => {
        vi.mocked(api.post).mockResolvedValueOnce({});
        vi.mocked(api.get).mockResolvedValue({ data: null });

        const { result } = renderWithProviders(() => useAuth());

        // Wait for initial user fetch
        await vi.waitFor(() => expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS));

        await act(async () => {
            await result.current.logout();
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.LOGOUT);
        expect(mockAuthStore.logout).toHaveBeenCalled();
        expect(localStorage.getItem('access_token')).toBeNull();
    });

    it('should handle generateOtp', async () => {
        vi.mocked(api.post).mockResolvedValueOnce({ data: { success: true } });
        // Need to mock get for initial load too if we wait for it, or just ignore if it doesn't fail
        vi.mocked(api.get).mockResolvedValue({ data: null });

        const { result } = renderWithProviders(() => useAuth());

        // Wait for initial user fetch
        await vi.waitFor(() => expect(api.get).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.USER_STATUS));

        await act(async () => {
            await result.current.generateOtpAsync('1234567890');
        });

        expect(api.post).toHaveBeenCalledWith(API_ENDPOINTS.AUTH.GENERATE_OTP, {
            mobile: '1234567890'
        });
    });
});



