import { IUser, IForm, UserRole, UserType } from '@/types';

// Initial Mock Data
export const MOCK_USERS: IUser[] = [
    {
        id: '1',
        username: 'admin',
        email: 'admin@example.com',
        mobile: '1234567890',
        user_type: UserType.EMPLOYEE,
        roles: [UserRole.ADMIN],
        is_active: true,
        is_admin: true,
        is_email_verified: true,
        failed_login_attempts: 0,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
    },
    {
        id: '2',
        username: 'creator',
        email: 'creator@example.com',
        mobile: '0987654321',
        user_type: UserType.EMPLOYEE,
        roles: [UserRole.CREATOR],
        is_active: true,
        is_admin: false,
        is_email_verified: true,
        failed_login_attempts: 0,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
    },
    {
        id: '3',
        username: 'admin1',
        email: 'admin1@example.com',
        mobile: '1112223333',
        user_type: UserType.EMPLOYEE,
        roles: [UserRole.SUPERADMIN],
        is_active: true,
        is_admin: true, // Superadmin
        is_email_verified: true,
        failed_login_attempts: 0,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
    }
];

export const MOCK_FORMS: IForm[] = [];

// In-memory store (server-side only, resets on restart)
declare global {
    var _mockDb: {
        users: IUser[];
        forms: IForm[];
    } | undefined;
}

const db = global._mockDb || {
    users: [...MOCK_USERS],
    forms: [...MOCK_FORMS],
};

if (process.env.NODE_ENV !== 'production') {
    global._mockDb = db;
}

export default db;
