import axios, { AxiosError, InternalAxiosRequestConfig } from 'axios';

// Create axios instance
const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://127.0.0.1:5000/form/api/v1',
  timeout: 10000,
  withCredentials: true, // For HttpOnly cookies
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - add auth token
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // Token is in HttpOnly cookie, no need to manually attach
    // But we can add additional headers if needed
    return config;
  },
  (error: AxiosError) => {
    return Promise.reject(error);
  }
);

// Response interceptor - handle errors globally
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error: AxiosError) => {
    if (error.response) {
      // Handle different error status codes
      switch (error.response.status) {
        case 401:
          // Unauthorized - redirect to login, unless it's just checking status
          if (typeof window !== 'undefined' && !window.location.pathname.includes('/login') && !window.location.pathname.includes('/register') && !error.config?.url?.includes('/user/status')) {
            window.location.href = '/login';
          }
          break;
        case 403:
          // Forbidden
          console.error('Access denied');
          break;
        case 404:
          console.error('Resource not found');
          break;
        case 429:
          // Rate limited
          console.error('Too many requests. Please try again later.');
          break;
        case 500:
        case 502:
        case 503:
        case 504:
          console.error('Server error. Please try again later.');
          break;
      }
    } else if (error.request) {
      // Network error
      console.error('Network error. Please check your connection.');
    } else {
      console.error('An unexpected error occurred.');
    }
    return Promise.reject(error);
  }
);

export default api;
