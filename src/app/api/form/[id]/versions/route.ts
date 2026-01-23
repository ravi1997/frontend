import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';
import { IFormVersion } from '@/types';

interface RouteContext {
    params: Promise<{
        id: string;
    }>;
}

export async function POST(request: Request, props: RouteContext) {
    try {
        const { id } = await props.params;
        const body = await request.json();

        const form = db.forms.find(f => f.id === id);
        if (!form) {
            return NextResponse.json({ message: 'Form not found' }, { status: 404 });
        }

        const newVersion: IFormVersion = {
            version_number: form.versions.length + 1,
            sections: body.sections || [], // Should use body.sections
            response_count: 0,
            created_at: new Date().toISOString()
        };

        form.versions.push(newVersion);

        return NextResponse.json({ success: true, version_id: newVersion.version_number });

    } catch (error) {
        return NextResponse.json({ message: 'Error creating version' }, { status: 500 });
    }
}
