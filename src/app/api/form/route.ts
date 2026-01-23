import { NextResponse } from 'next/server';
import db from '@/lib/mock-db';
import { IForm, FormStatus } from '@/types';
import { v4 as uuidv4 } from 'uuid';

// List Forms
export async function GET(request: Request) {
    // Basic array response as expected by useForms hook array test
    // Or paginated if requested?
    // The hook tests handled both array and paginated. Let's return array for simplicity or match the standard.
    // api.ts uses interceptor? No.
    // logic: return { data: [...] } or [...]?
    // Axios response.data usually contains the JSON.
    // If we return JSON, the hook sees that.

    // Simulating loading delay
    await new Promise(r => setTimeout(r, 500));

    return NextResponse.json(db.forms);
}

// Create Form
export async function POST(request: Request) {
    try {
        const body = await request.json();

        // Validation handled by Zod in real app

        const newForm: IForm = {
            id: uuidv4(),
            title: body.title,
            description: body.description,
            slug: body.slug,
            created_by: '1', // Hardcoded admin
            status: FormStatus.DRAFT,
            ui: 'flex',
            is_public: body.is_public || false,
            approval_enabled: false,
            versions: [],
            editors: [],
            viewers: [],
            submitters: [],
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString(),
        };

        db.forms.push(newForm);

        return NextResponse.json(newForm); // API returns the created form object (or { form_id: ... })?
        // useForm.ts: const response = await api.post... return response.data;
        // expect(data).toEqual(mockForm);
        // It expects the object.

    } catch (error) {
        return NextResponse.json({ message: 'Error creating form' }, { status: 500 });
    }
}
