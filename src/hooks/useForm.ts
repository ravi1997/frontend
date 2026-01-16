import { useMutation, useQueryClient } from '@tanstack/react-query';
import api from '@/lib/api';
import { IForm, ISection } from '@/types';
import { useRouter } from 'next/navigation';

interface CreateFormPayload {
    title: string;
    slug: string;
    description?: string;
    is_public?: boolean;
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
            const response = await api.post('/form/', payload);
            return response.data;
        },
        onSuccess: (data) => {
            console.log('Form shell created successfully', data);
            queryClient.invalidateQueries({ queryKey: ['forms'] });
        },
        onError: (error: any) => {
            console.error('Failed to create form', error);
            alert(error.response?.data?.message || 'Failed to create form');
        },
    });

    // Create Version Mutation
    const createVersion = useMutation({
        mutationFn: async ({ formId, payload }: { formId: string, payload: CreateVersionPayload }) => {
            const response = await api.post(`/form/${formId}/versions`, payload);
            return response.data;
        },
        onSuccess: () => {
            console.log('Form saved successfully');
            alert('Form saved successfully!');
        },
        onError: (error: any) => {
            console.error('Failed to save form version', error);
            alert(error.response?.data?.message || 'Failed to save form version');
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

            // 3. Navigate to edit page (optional, but good practice)
            // router.push(`/builder/${formId}`);

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
