import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';
import { AuthResponse } from '@/types';

export async function POST(request: Request) {
    try {
        const body = await request.json();
        const { identifier } = body;

        // Simple mock authentication (any password works for specific emails)
        // In real app, check password hash
        const user = db.users.find(u => u.email === identifier || u.mobile === identifier);

        if (!user) {
            return NextResponse.json(
                { message: 'Invalid credentials' },
                { status: 401 }
            );
        }

        // Mock token
        const response: AuthResponse = {
            access_token: `mock-jwt-token-${user.id}`,
            user: user,
            success: true
        };

        const res = NextResponse.json(response);

        // Set HttpOnly cookie for token if needed, but client might just store it from body
        // api.js usually expects response.data to have access_token

        return res;

    } catch (err) {
        console.error('Login error:', err);
        return NextResponse.json(
            { message: 'Internal Server Error' },
            { status: 500 }
        );
    }
}
