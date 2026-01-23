import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';

export async function GET(request: Request) {
    // In a real app, verify the Bearer token or Cookie
    // For mock, just return the first user (Admin) or check a mock header if we want to simulate logout

    // Check Authorization header for "mock-jwt-token-{id}"
    const authHeader = request.headers.get('Authorization');

    if (authHeader && authHeader.startsWith('Bearer mock-jwt-token-')) {
        const userId = authHeader.replace('Bearer mock-jwt-token-', '');
        const user = db.users.find(u => u.id === userId);

        if (user) {
            return NextResponse.json(user);
        }
    }

    // Return 401 if valid token not present (simulating unauthenticated)
    // Or return 200 with null? api.ts interceptor might handle 401 by clearing auth
    // The useAuth hook expects 200 with user object or error
    return NextResponse.json(
        { message: 'Unauthorized' },
        { status: 401 }
    );
}
