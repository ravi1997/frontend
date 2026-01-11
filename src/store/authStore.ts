import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { IUser } from '@/types';

interface AuthState {
  user: IUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  lastLoginMethod: 'email' | 'mobile' | null;
}

interface AuthActions {
  setUser: (user: IUser | null) => void;
  setLoading: (isLoading: boolean) => void;
  setLastLoginMethod: (method: 'email' | 'mobile') => void;
  logout: () => void;
}

type AuthStore = AuthState & AuthActions;

export const useAuthStore = create<AuthStore>()(
  persist(
    (set) => ({
      // State
      user: null,
      isAuthenticated: false,
      isLoading: true,
      lastLoginMethod: null,

      // Actions
      setUser: (user) =>
        set({
          user,
          isAuthenticated: !!user,
          isLoading: false,
        }),

      setLoading: (isLoading) =>
        set({ isLoading }),

      setLastLoginMethod: (method) =>
        set({ lastLoginMethod: method }),

      logout: () =>
        set({
          user: null,
          isAuthenticated: false,
          lastLoginMethod: null,
        }),
    }),
    {
      name: 'auth-storage',
      partialize: (state) => ({
        lastLoginMethod: state.lastLoginMethod,
      }),
    }
  )
);
