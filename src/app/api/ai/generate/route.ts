import { NextRequest, NextResponse } from 'next/server';
import { cookies } from 'next/headers';
import { ISection, IQuestion, IOption } from '@/types';
import { v4 as uuidv4 } from 'uuid';

// This is a server-side route to keep API keys secure
// We use open-source models (Mistral / Llama 3) via an API provider



export async function POST(request: NextRequest) {
    try {
        const { prompt } = await request.json();

        if (!prompt) {
            return NextResponse.json({ error: 'Prompt is required' }, { status: 400 });
        }

        const cookieStore = await cookies();
        const token = cookieStore.get('access_token')?.value;
        const apiKey = token || process.env.LLM_API_KEY;
        const backendUrl = 'http://127.0.0.1:5000/form/api/v1';
        const providerUrl = `${backendUrl}/ai/generate`;

        if (!apiKey) {
            return NextResponse.json({
                error: 'Authentication required. Please log in to use AI generation.',
                is_mock: true
            }, { status: 401 });
        }

        const response = await fetch(providerUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${apiKey}`
            },
            body: JSON.stringify({
                prompt: prompt
            })
        });

        if (!response.ok) {
            const error = await response.text();
            console.error('LLM API Error:', error);
            throw new Error('Failed to generate form from LLM');
        }

        const result = await response.json();

        let formStructure;
        if (result.suggestion) {
            // Internal backend format
            formStructure = result.suggestion;
        } else if (result.choices && result.choices[0]?.message?.content) {
            // OpenAI / Mistral format
            const content = result.choices[0].message.content;
            formStructure = typeof content === 'string' ? JSON.parse(content) : content;
        } else {
            throw new Error('Failed to parse AI response: Unexpected format');
        }

        // Post-process to ensure valid UUIDs and IDs if the LLM provided placeholders
        const validatedSections = formStructure.sections.map((section: ISection, sIdx: number) => ({
            ...section,
            id: section.id === 'uuid' || !section.id ? uuidv4() : section.id,
            order_index: sIdx,
            questions: section.questions.map((q: IQuestion, qIdx: number) => ({
                ...q,
                id: q.id === 'uuid' || !q.id ? uuidv4() : q.id,
                order_index: qIdx,
                options: q.options?.map((opt: IOption, oIdx: number) => ({
                    ...opt,
                    order_index: oIdx
                }))
            }))
        }));

        return NextResponse.json({ sections: validatedSections });

    } catch (error) {
        console.error('AI Generation Error:', error);
        return NextResponse.json({ error: 'Failed to generate form structure' }, { status: 500 });
    }
}
