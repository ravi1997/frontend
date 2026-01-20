// API Endpoints
export const API_ENDPOINTS = {
  AUTH: {
    REGISTER: '/auth/register',
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    GENERATE_OTP: '/auth/generate-otp',
    USER_STATUS: '/user/status',
  },
  FORMS: {
    BASE: '/form',
    LIST: '/form',
    CREATE: '/form',
    GET: (id: string) => `/form/${id}`,
    UPDATE: (id: string) => `/form/${id}`,
    DELETE: (id: string) => `/form/${id}`,
    PUBLISH: (id: string) => `/form/${id}/publish`,
    CLONE: (id: string) => `/form/${id}/clone`,
    RESPONSES: (id: string) => `/form/${id}/responses`,
    PUBLIC_SUBMIT: (id: string) => `/form/${id}/public-submit`,
    ANALYTICS: (id: string) => `/form/${id}/analytics`,
    EXPORT_CSV: (id: string) => `/form/${id}/export/csv`,
    EXPORT_JSON: (id: string) => `/form/${id}/export/json`,
    VERSIONS: (id: string) => `/form/${id}/versions`,
  },
  APPROVALS: {
    PENDING: '/approvals/pending',
    ACTION: (responseId: string) => `/approvals/${responseId}/action`,
    HISTORY: (responseId: string) => `/approvals/${responseId}/history`,
  },
};

// LocalStorage Keys
export const STORAGE_KEYS = {
  DRAFT_PREFIX: 'form_draft_',
  THEME: 'theme',
  LAST_LOGIN_METHOD: 'last_login_method',
};

// Configuration
export const CONFIG = {
  MAX_FILE_SIZE: 10 * 1024 * 1024, // 10MB
  ALLOWED_FILE_TYPES: [
    'image/jpeg',
    'image/png',
    'image/gif',
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  ],
  AUTO_SAVE_DELAY: 1000, // 1 second
  OTP_LENGTH: 6,
  OTP_RESEND_COOLDOWN: 60, // 60 seconds
  MAX_OTP_ATTEMPTS: 5,
  PAGINATION: {
    DEFAULT_PAGE_SIZE: 20,
    PAGE_SIZE_OPTIONS: [10, 20, 50, 100],
  },
};

// User Roles
export enum UserRole {
  SUPERADMIN = 'superadmin',
  ADMIN = 'admin',
  CREATOR = 'creator',
  EDITOR = 'editor',
  PUBLISHER = 'publisher',
  MANAGER = 'manager',
  DEO = 'deo',
  USER = 'user',
  GENERAL = 'general',
}

// Form Status
export enum FormStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ARCHIVED = 'archived',
}

// Field Types
export enum FieldType {
  SHORT_TEXT = 'short_text',
  LONG_TEXT = 'long_text',
  NUMBER = 'number',
  DATE = 'date',
  TIME = 'time',
  DATETIME = 'datetime',
  DROPDOWN = 'dropdown',
  RADIO = 'radio',
  CHECKBOX = 'checkbox',
  FILE_UPLOAD = 'file_upload',
  EMAIL = 'email',
  MOBILE = 'mobile',
  URL = 'url',
  RATING = 'rating',
  BOOLEAN = 'boolean',
  API_SEARCH = 'api_search',
  CALCULATED = 'calculated',
}
