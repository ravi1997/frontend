import { useMutation, useQueryClient } from '@tanstack/react-query';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { ISection } from '@/types';
import { AxiosError } from 'axios';
import { useRouter } from 'next/navigation';

interface CreateFormPayload {
    title: string;
    description: string;
    slug: string;
    is_public: boolean;
}

interface CreateVersionPayload {
    version: string;
    sections: ISection[];
    activate?: boolean;
}

export function useForm() {
    const router = useRouter();
    const queryClient = useQueryClient();

    // Create Form Mutation
    const createForm = useMutation({
        mutationFn: async (payload: CreateFormPayload) => {
            const response = await api.post(API_ENDPOINTS.FORMS.CREATE, payload);
            return response.data;
        },
        onSuccess: (data) => {
            console.log('Form shell created successfully', data);
            queryClient.invalidateQueries({ queryKey: ['forms'] });
        },
        onError: (error: AxiosError<{ message?: string }>) => {
            console.error('Failed to create form', error);
            const message = error.response?.data?.message || 'Failed to create form';
            alert(message);
        },
    });

    // Create Version Mutation
    const createVersion = useMutation({
        mutationFn: async ({ formId, payload }: { formId: string, payload: CreateVersionPayload }) => {
            const response = await api.post(API_ENDPOINTS.FORMS.VERSIONS(formId), payload);
            return response.data;
        },
        onSuccess: () => {
            console.log('Form saved successfully');
            alert('Form saved successfully!');
        },
        onError: (error: AxiosError<{ message?: string }>) => {
            console.error('Failed to save form version', error);
            const message = error.response?.data?.message || 'Failed to save form version';
            alert(message);
        },
    });

    // Composite save action (Create Form + Add Version)
    const saveNewForm = async (
        formPayload: CreateFormPayload,
        sections: ISection[]
    ) => {
        try {
            // 1. Create Form
            const formResponse = await createForm.mutateAsync(formPayload);
            const formId = formResponse.form_id;

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
        saveNewForm,
        isSaving: createForm.isPending || createVersion.isPending,
    };
}
