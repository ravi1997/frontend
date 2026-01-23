import { NextRequest, NextResponse } from 'next/server';
import { ISection, IQuestion, IOption } from '@/types';
import { v4 as uuidv4 } from 'uuid';

// This is a server-side route to keep API keys secure
// We use open-source models (Mistral / Llama 3) via an API provider

const SYSTEM_PROMPT = `You are an expert Form Builder Assistant. 
Your task is to generate a professional form structure based on the user's request.
You must return only a valid JSON object matching the following structure:
{
  "sections": [
    {
      "id": "uuid",
      "title": "Section Title",
      "order_index": 0,
      "is_repeatable": false,
      "questions": [
        {
          "id": "uuid",
          "question_text": "Label",
          "field_type": "short_text" | "long_text" | "email" | "number" | "date" | "dropdown" | "checkbox" | "radio" | "file_upload" | "rating" | "mobile" | "url",
          "is_required": true,
          "order_index": 0,
          "placeholder": "Optional placeholder",
          "options": [ // Only if field_type is dropdown, checkbox, or radio
            { "option_value": "val", "option_label": "Label", "order_index": 0 }
          ]
        }
      ]
    }
  ]
}

Available FieldTypes: short_text, long_text, email, number, date, dropdown, checkbox, radio, file_upload, rating, mobile, url.
Ensure UUIDs are unique and the structure is logical.
Do not include any text outside the JSON block.`;

export async function POST(request: NextRequest) {
    try {
        const { prompt } = await request.json();

        if (!prompt) {
            return NextResponse.json({ error: 'Prompt is required' }, { status: 400 });
        }

        const apiKey = process.env.LLM_API_KEY;
        const providerUrl = process.env.LLM_API_URL || 'https://api.mistral.ai/v1/chat/completions'; // Default to Mistral AI
        const model = process.env.LLM_MODEL || 'mistral-small-latest';

        if (!apiKey) {
            return NextResponse.json({
                error: 'AI Service not configured. Please add LLM_API_KEY to your environment.',
                is_mock: true
            }, { status: 503 });
        }

        const response = await fetch(providerUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${apiKey}`
            },
            body: JSON.stringify({
                model: model,
                messages: [
                    { role: 'system', content: SYSTEM_PROMPT },
                    { role: 'user', content: `Generate a form for: ${prompt}` }
                ],
                response_format: { type: 'json_object' }, // Supported by many modern LLM providers
                temperature: 0.7
            })
        });

        if (!response.ok) {
            const error = await response.text();
            console.error('LLM API Error:', error);
            throw new Error('Failed to generate form from LLM');
        }

        const result = await response.json();
        const content = result.choices[0].message.content;

        // Parse the generated JSON
        const formStructure = JSON.parse(content);

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
