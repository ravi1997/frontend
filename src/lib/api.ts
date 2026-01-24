const BASE_URL = 'http://127.0.0.1:5000/form/api/v1';

export interface RequestOptions extends RequestInit {
  data?: unknown;
  params?: Record<string, string>;
  headers?: Record<string, string>;
  responseType?: 'json' | 'text' | 'blob' | 'arraybuffer';
}

export interface ApiResponse<T = unknown> {
  data: T;
  status: number;
  statusText: string;
  headers: Headers;
}

export interface ApiError extends Error {
  status?: number;
  statusText?: string;
  response?: {
    data: unknown;
    status: number;
    statusText: string;
  };
}

async function request<T = unknown>(endpoint: string, options: RequestOptions = {}): Promise<ApiResponse<T>> {
  const { data, params, headers, responseType, ...customConfig } = options;
  const token = typeof window !== 'undefined' ? localStorage.getItem('access_token') : null;

  const config: RequestInit = {
    ...customConfig,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(headers || {}),
    },
  };

  if (data) {
    config.body = JSON.stringify(data);
  }

  // Handle absolute URLs vs relative paths
  const urlStr = endpoint.startsWith('http') ? endpoint : `${BASE_URL}${endpoint}`;
  const url = new URL(urlStr);

  if (params) {
    Object.keys(params).forEach(key => {
      if (params[key] !== undefined) {
        url.searchParams.append(key, params[key]);
      }
    });
  }

  try {
    const response = await fetch(url.toString(), config);
    let responseData;

    if (responseType === 'blob') {
      responseData = await response.blob();
    } else if (responseType === 'arraybuffer') {
      responseData = await response.arrayBuffer();
    } else if (responseType === 'text') {
      responseData = await response.text();
    } else {
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        responseData = await response.json();
      } else {
        responseData = await response.text();
      }
    }

    if (!response.ok) {
      // Handle global errors
      if (response.status === 401) {
        if (typeof window !== 'undefined' &&
          !window.location.pathname.includes('/login') &&
          !window.location.pathname.includes('/register') &&
          !endpoint.includes('/user/status') &&
          !endpoint.includes('/ai/')) {
          console.warn('[API] 401 Unauthorized detected. Redirecting to login...');
          window.location.href = '/login';
        }
      }

      // Create an error object that mimics AxiosError structure for compatibility
      const responseDataObj = responseData as { message?: string, error?: string, [key: string]: any };
      let errorMessage = responseDataObj?.message || responseDataObj?.error || response.statusText || 'Request failed';

      // If we have a structured error (like validation errors) but no top-level message
      if (typeof responseData === 'object' && responseData !== null && !responseDataObj.message && !responseDataObj.error) {
        // Try to create a more helpful message from the first few validation errors if they exist
        errorMessage = `Validation Error: ${JSON.stringify(responseData).substring(0, 100)}...`;
      }

      const error = new Error(errorMessage) as ApiError;
      error.status = response.status;
      error.response = {
        data: responseData,
        status: response.status,
        statusText: response.statusText
      };
      throw error;
    }

    return {
      data: responseData,
      status: response.status,
      statusText: response.statusText,
      headers: response.headers
    };

  } catch (err: unknown) {
    const error = err as ApiError;
    // Normalize Network Errors (missing status/response)
    if (!error.response) {
      error.status = error.status || 0;
      error.statusText = error.statusText || 'Network Error';
      error.response = {
        data: { message: error.message || 'Network Error' },
        status: error.status,
        statusText: error.statusText
      };
    }

    // Suppress logging for 401 and 403 errors as they are expected/handled
    if (error?.status !== 401 && error?.status !== 403) {
      console.error('API Request Error:', error);
    }
    throw error;
  }
}

const api = {
  get: <T = unknown>(endpoint: string, options?: RequestOptions) => request<T>(endpoint, { ...options, method: 'GET' }),
  post: <T = unknown>(endpoint: string, data?: unknown, options?: RequestOptions) => request<T>(endpoint, { ...options, data, method: 'POST' }),
  put: <T = unknown>(endpoint: string, data?: unknown, options?: RequestOptions) => request<T>(endpoint, { ...options, data, method: 'PUT' }),
  patch: <T = unknown>(endpoint: string, data?: unknown, options?: RequestOptions) => request<T>(endpoint, { ...options, data, method: 'PATCH' }),
  delete: <T = unknown>(endpoint: string, options?: RequestOptions) => request<T>(endpoint, { ...options, method: 'DELETE' }),
};

export default api;

