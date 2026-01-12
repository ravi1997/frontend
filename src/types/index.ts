import { UserRole, FormStatus, FieldType } from '@/lib/constants';
export { UserRole, FormStatus, FieldType };

// ==================== User Types ====================
export enum UserType {
  EMPLOYEE = 'employee',
  GENERAL = 'general',
}

export interface IUser {
  id: string;
  username: string;
  email: string;
  employee_id?: string;
  mobile: string;
  user_type: UserType;
  roles: UserRole[];
  is_active: boolean;
  is_admin: boolean;
  is_email_verified: boolean;
  failed_login_attempts: number;
  lock_until?: Date | string;
  last_login?: Date | string;
  password_expiration?: Date | string;
  created_at: Date | string;
  updated_at: Date | string;
}

// ==================== Form Types ====================
export interface IApprovalStep {
  step_number: number;
  approver_role: UserRole;
  approver_user_ids?: string[];
  required_count?: number;
}

export interface IFormVersion {
  version_number: number;
  sections: ISection[];
  response_count: number;
  created_at: Date | string;
}

export interface IForm {
  id: string;
  title: string;
  description?: string;
  slug: string;
  created_by: string;
  status: FormStatus;
  ui: 'flex' | 'grid-cols-2' | 'tabbed' | 'custom';
  is_public: boolean;
  approval_enabled: boolean;
  approval_steps?: IApprovalStep[];
  versions: IFormVersion[];
  tags?: string[];
  editors: string[];
  viewers: string[];
  submitters: string[];
  expires_at?: Date | string;
  created_at: Date | string;
  updated_at: Date | string;
}

export interface ISection {
  id: string;
  title: string;
  description?: string;
  order_index: number;
  is_repeatable: boolean;
  min_repeat?: number;
  max_repeat?: number;
  questions: IQuestion[];
}

export interface IOption {
  option_value: string;
  option_label: string;
  order_index: number;
}

export interface IQuestion {
  id: string;
  question_text: string;
  field_type: FieldType;
  is_required: boolean;
  order_index: number;
  placeholder?: string;
  help_text?: string;
  default_value?: string;
  options?: IOption[];
  validation_rules?: string; // JSON string
  visibility_condition?: string; // JSON string
  is_repeatable?: boolean;
  min_repeat?: number;
  max_repeat?: number;
  api_config?: string; // JSON string for API_SEARCH type
}

// ==================== Response Types ====================
export interface IFormResponse {
  id: string;
  form_id: string;
  form_version: number;
  submitted_by?: string;
  data: Record<string, unknown>;
  status: 'pending' | 'approved' | 'rejected';
  current_approval_step?: number;
  submitted_at: Date | string;
  updated_at: Date | string;
}

export interface IApprovalAction {
  id: string;
  response_id: string;
  step_id: number;
  action: 'approved' | 'rejected' | 'sent_back';
  actor_id: string;
  comment?: string;
  timestamp: Date | string;
}

// ==================== API Response Types ====================
export interface ApiResponse<T = unknown> {
  data?: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  total_pages: number;
}

// ==================== Auth Types ====================
export interface LoginRequest {
  email?: string;
  password?: string;
  mobile?: string;
  otp?: string;
}

export interface RegisterRequest {
  username: string;
  email: string;
  employee_id?: string;
  mobile: string;
  password: string;
  confirm_password: string;
  user_type: string;
  roles: string[];
}

export interface AuthResponse {
  access_token: string;
  user: IUser;
}

// ==================== Form Builder Types ====================
export interface FormBuilderState {
  form: IForm | null;
  currentVersion: IFormVersion | null;
  selectedQuestion: IQuestion | null;
  isDirty: boolean;
}

export interface DragItem {
  id: string;
  type: FieldType;
  data?: Partial<IQuestion>;
}

// ==================== Analytics Types ====================
export interface FormAnalytics {
  total_responses: number;
  latest_submission?: Date | string;
  response_rate?: {
    daily: Array<{ date: string; count: number }>;
    weekly: Array<{ week: string; count: number }>;
  };
  device_breakdown?: {
    mobile: number;
    desktop: number;
    tablet: number;
  };
  completion_rate?: number;
}
