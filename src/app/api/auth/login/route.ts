import { NextResponse } from 'next/server';
import { cookies } from 'next/headers';

export async function POST(request: Request) {
    try {
        const body = await request.json();

        // Proxy to real backend
        const backendUrl = process.env.NEXT_PUBLIC_API_URL || 'http://127.0.0.1:5000/form/api/v1';

        const res = await fetch(`${backendUrl}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });

        const data = await res.json();

        if (!res.ok) {
            return NextResponse.json(data, { status: res.status });
        }

        const response = NextResponse.json(data);

        // Forward cookies (specifically access_token_cookie if set by Flask)
        // Note: Flask-JWT-Extended usually sets 'access_token_cookie'
        const setCookieHeader = res.headers.get('set-cookie');
        if (setCookieHeader) {
            // Simple forwarding might not work well with multiple cookies, 
            // but for now we manually set the access_token if returned in body as well.
            // Or we relies on the body token.

            // Explicitly set the cookie for Next.js middleware/server actions to see it
            const cookieStore = await cookies();
            cookieStore.set('access_token', data.access_token, {
                httpOnly: true,
                path: '/',
                sameSite: 'lax',
                maxAge: 60 * 60 * 24 // 1 day
            });
        }

        return response;

    } catch (err) {
        console.error('Login error:', err);
        // Fallback to mock if backend is down? 
        // No, best to fail so we know integration is broken.
        return NextResponse.json(
            { message: 'Authentication Service Unavailable' },
            { status: 503 }
        );
    }
}
