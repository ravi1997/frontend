import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';

interface RouteContext {
    params: Promise<{
        id: string;
    }>;
}

export async function GET(request: Request, props: RouteContext) {
    try {
        const { id } = await props.params;

        // Simulate network delay
        await new Promise(r => setTimeout(r, 300));

        const form = db.forms.find(f => f.id === id);

        if (!form) {
            return NextResponse.json({ message: 'Form not found' }, { status: 404 });
        }

        return NextResponse.json(form);
    } catch (error) {
        return NextResponse.json({ message: 'Internal Server Error' }, { status: 500 });
    }
}

export async function PATCH(request: Request, props: RouteContext) {
    try {
        const { id } = await props.params;
        const body = await request.json();

        const formIndex = db.forms.findIndex(f => f.id === id);
        if (formIndex === -1) {
            return NextResponse.json({ message: 'Form not found' }, { status: 404 });
        }

        db.forms[formIndex] = {
            ...db.forms[formIndex],
            ...body,
            updated_at: new Date().toISOString()
        };

        return NextResponse.json(db.forms[formIndex]);
    } catch (error) {
        return NextResponse.json({ message: 'Internal Server Error' }, { status: 500 });
    }
}

