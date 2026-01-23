import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';
import { v4 as uuidv4 } from 'uuid';
import { UserRole, UserType, IUser } from '@/types';

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { email, username, mobile, user_type, roles } = body;

        if (db.users.find(u => u.email === email)) {
            return NextResponse.json({ message: 'User already exists' }, { status: 400 });
        }

        const newUser: IUser = {
            id: uuidv4(),
            username: username || email.split('@')[0],
            email,
            mobile: mobile || '',
            user_type: (user_type as UserType) || UserType.GENERAL,
            roles: (roles as UserRole[]) || [UserRole.USER],
            is_active: true,
            is_admin: false,
            is_email_verified: false,
            failed_login_attempts: 0,
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
            // password is not stored in this mock db for security simulation
        };

        db.users.push(newUser);

        return NextResponse.json({ success: true, message: 'User registered' });

    } catch (err) {
        console.error('Register error:', err);
        return NextResponse.json({ message: 'Error registering user' }, { status: 500 });
    }
}
