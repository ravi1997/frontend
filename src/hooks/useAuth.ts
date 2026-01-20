import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { useAuthStore } from '@/store/authStore';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import type {
  LoginRequest,
  RegisterRequest,
  AuthResponse,
  IUser,
} from '@/types';

export function useAuth() {
  const router = useRouter();
  const queryClient = useQueryClient();
  const { user, isAuthenticated, setUser, setLastLoginMethod, logout: logoutStore } =
    useAuthStore();

  // Fetch user status on mount
  const { isLoading } = useQuery({
    queryKey: ['user-status'],
    queryFn: async () => {
      try {
        const { data } = await api.get<IUser>(API_ENDPOINTS.AUTH.USER_STATUS);
        setUser(data);
        return data;
      } catch {
        setUser(null);
        return null;
      }
    },
    retry: false,
    refetchOnWindowFocus: false,
  });

  // Login mutation
  const loginMutation = useMutation({
    mutationFn: async (credentials: LoginRequest) => {
      // Backend expects 'identifier' for password login, or 'mobile'/'otp' for OTP login
      const payload: Record<string, string | undefined> = { ...credentials };
      if (credentials.email) {
        payload.identifier = credentials.email;
        delete payload.email;
      } else if (credentials.mobile && credentials.password) {
        // Mobile + Password login also uses identifier
        payload.identifier = credentials.mobile;
        delete payload.mobile;
      }

      const { data } = await api.post<AuthResponse>(
        API_ENDPOINTS.AUTH.LOGIN,
        payload
      );
      return data;
    },
    onSuccess: (data, variables) => {
      if (data.access_token) {
        // Store token for non-cookie auth (fallback)
        localStorage.setItem('access_token', data.access_token);
        // Set cookie for middleware
        document.cookie = `access_token=${data.access_token}; path=/; max-age=86400; SameSite=Lax`;
      }

      if (data.user) {
        setUser(data.user);
      }
      const method = variables.email ? 'email' : 'mobile';
      setLastLoginMethod(method);
      queryClient.invalidateQueries({ queryKey: ['user-status'] });
      router.push('/dashboard');
    },
  });

  // Register mutation
  const registerMutation = useMutation({
    mutationFn: async (userData: RegisterRequest) => {
      const { data } = await api.post(API_ENDPOINTS.AUTH.REGISTER, userData);
      return data;
    },
    onSuccess: () => {
      router.push('/login?registered=true');
    },
  });

  // Generate OTP mutation
  const generateOtpMutation = useMutation({
    mutationFn: async (mobile: string) => {
      const { data } = await api.post(API_ENDPOINTS.AUTH.GENERATE_OTP, {
        mobile,
      });
      return data;
    },
  });

  // Logout mutation
  const logoutMutation = useMutation({
    mutationFn: async () => {
      await api.post(API_ENDPOINTS.AUTH.LOGOUT);
    },
    onSuccess: () => {
      logoutStore();
      queryClient.clear();
      localStorage.removeItem('access_token');
      document.cookie = 'access_token=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT';
      router.push('/login');
    },
  });

  return {
    user,
    isAuthenticated,
    isLoading,
    login: loginMutation.mutate,
    loginAsync: loginMutation.mutateAsync,
    isLoginLoading: loginMutation.isPending,
    loginError: loginMutation.error,
    register: registerMutation.mutate,
    registerAsync: registerMutation.mutateAsync,
    isRegisterLoading: registerMutation.isPending,
    registerError: registerMutation.error,
    generateOtp: generateOtpMutation.mutate,
    generateOtpAsync: generateOtpMutation.mutateAsync,
    isOtpLoading: generateOtpMutation.isPending,
    otpError: generateOtpMutation.error,
    logout: logoutMutation.mutate,
    isLogoutLoading: logoutMutation.isPending,
  };
}
