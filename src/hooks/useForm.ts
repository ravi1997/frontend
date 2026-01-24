import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { ISection, IWorkflow, IApprovalStep } from '@/types';

import { validateForm, sanitizeString } from '@/lib/validations';
import { transformFormPayload } from '@/lib/transformers';

interface CreateFormPayload {
    title: string;
    description: string;
    slug: string;
    is_public: boolean;
    workflows?: IWorkflow[];
    approval_enabled?: boolean;
    approval_steps?: IApprovalStep[];
}

interface CreateVersionPayload {
    version: string;
    sections: ISection[];
    activate?: boolean;
}

interface CreateFormResponse {
    id?: string;
    form_id?: string;
    [key: string]: unknown;
}

// Custom error interface matching our new api.ts
interface ApiError extends Error {
    response?: {
        data?: {
            message?: string;
        };
        status?: number;
    };
}

export function useForm() {
    const queryClient = useQueryClient();

    // Create Form Mutation
    const createForm = useMutation({
        mutationFn: async (payload: CreateFormPayload) => {
            // Sanitize inputs
            const sanitizedPayload = {
                ...payload,
                title: sanitizeString(payload.title),
                description: sanitizeString(payload.description),
            };
            const response = await api.post<CreateFormResponse>(API_ENDPOINTS.FORMS.CREATE, sanitizedPayload);
            return response.data;
        },
        onSuccess: (data) => {
            console.log('Form shell created successfully', data);
            queryClient.invalidateQueries({ queryKey: ['forms'] });
        },
        onError: (error: ApiError) => {
            console.error('Failed to create form', error);
            const message = error.response?.data?.message || 'Failed to create form';
            alert(message);
        },
    });

    // Create Version Mutation
    const createVersion = useMutation({
        mutationFn: async ({ formId, payload }: { formId: string, payload: CreateVersionPayload }) => {
            // Transform payload to match backend schema
            const backendPayload = {
                ...payload,
                sections: transformFormPayload(payload.sections)
            };
            const response = await api.post(API_ENDPOINTS.FORMS.VERSIONS(formId), backendPayload);
            return response.data;
        },
        onSuccess: (_data, variables) => {
            console.log('Form saved successfully');
            queryClient.invalidateQueries({ queryKey: ['form', variables.formId] });
            alert('Form saved successfully!');
        },
        onError: (error: ApiError) => {
            console.error('Failed to save form version', error);
            const message = error.response?.data?.message || 'Failed to save form version';
            alert(message);
        },
    });

    // Update Form Mutation (Metadata)
    const updateForm = useMutation({
        mutationFn: async ({ formId, payload }: { formId: string, payload: Partial<CreateFormPayload> }) => {
            const response = await api.put(API_ENDPOINTS.FORMS.UPDATE(formId), payload);
            return response.data;
        },
        onSuccess: (_data, variables) => {
            queryClient.invalidateQueries({ queryKey: ['forms'] });
            queryClient.invalidateQueries({ queryKey: ['form', variables.formId] });
            alert('Form updated successfully!');
        },
    });

    // Composite save action (Create Form + Add Version)
    const saveNewForm = async (
        formPayload: CreateFormPayload,
        sections: ISection[]
    ) => {
        // Validation
        const validation = validateForm(formPayload.title, formPayload.slug, sections);
        if (!validation.isValid) {
            alert(`Validation failed:\n${validation.errors.join('\n')}`);
            throw new Error('Validation failed');
        }

        try {
            // 1. Create Form
            const formResponse = await createForm.mutateAsync(formPayload);
            const formId = formResponse.id || formResponse.form_id;

            if (!formId) throw new Error('No form ID returned');

            // 2. Create Initial Version
            await createVersion.mutateAsync({
                formId,
                payload: {
                    version: '1.0',
                    sections,
                    activate: true,
                },
            });

            return formId;
        } catch (error) {
            console.error(error);
            throw error;
        }
    };

    return {
        createForm,
        createVersion,
        updateForm,
        saveNewForm,
        isSaving: createForm.isPending || createVersion.isPending || updateForm.isPending,
    };
}

export function useFormDetails(formId?: string) {
    return useQuery({
        queryKey: ['form', formId],
        queryFn: async () => {
            if (!formId) return null;
            const { data } = await api.get(API_ENDPOINTS.FORMS.GET(formId));
            return data;
        },
        enabled: !!formId,
    });
}
