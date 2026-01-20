import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock browser globals for node environment
const localStorageMock = (() => {
    let store: Record<string, string> = {};
    return {
        getItem: vi.fn((key: string) => store[key] || null),
        setItem: vi.fn((key: string, value: string) => { store[key] = value.toString(); }),
        removeItem: vi.fn((key: string) => { delete store[key]; }),
        clear: vi.fn(() => { store = {}; }),
    };
})();

Object.defineProperty(global, 'localStorage', { value: localStorageMock });
Object.defineProperty(global, 'document', { value: { cookie: '' }, writable: true });

import { useAuth } from '../useAuth';

// Mock the dependencies
vi.mock('next/navigation', () => ({
    useRouter: () => ({
        push: vi.fn(),
    }),
}));

vi.mock('@tanstack/react-query', () => ({
    useMutation: vi.fn(() => ({
        mutate: vi.fn(),
        isPending: false,
        error: null,
    })),
    useQuery: vi.fn(() => ({
        isLoading: false,
        data: null,
    })),
    useQueryClient: () => ({
        invalidateQueries: vi.fn(),
    }),
}));

// Use relative path for mocks too
vi.mock('../../store/authStore', () => ({
    useAuthStore: () => ({
        user: null,
        isAuthenticated: false,
        setUser: vi.fn(),
        setLastLoginMethod: vi.fn(),
        logout: vi.fn(),
    }),
}));

describe('useAuth', () => {
    it('should be a function', () => {
        expect(typeof useAuth).toBe('function');
    });

    it('should return auth methods', () => {
        const result = useAuth();
        expect(result).toHaveProperty('login');
        expect(result).toHaveProperty('logout');
    });
});
