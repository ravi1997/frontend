import { useQuery } from '@tanstack/react-query';
import api from '@/lib/api';
import { IForm } from '@/types';

interface FetchFormsResponse {
    forms: IForm[];
    total: number;
    page: number;
    limit: number;
}

export function useForms() {
    const { data, isLoading, error, refetch } = useQuery({
        queryKey: ['forms'],
        queryFn: async () => {
            const { data } = await api.get<FetchFormsResponse>('/form/');
            // API might return array directly or paginated object. 
            // Based on docs it says "List endpoints support standard pagination". 
            // Let's assume it returns a list or handle both.
            // Actually docs say example response for pagination is { total, page, responses: [] }
            // But list forms endpoint example is just GET /form/.
            // Let's assume standard array for now or inspect response if possible.
            // To be safe, let's type the response safely.
            return data;
        },
    });

    // Helper to normalize data structure
    const forms = Array.isArray(data) ? data : (data as any)?.forms || [];
    const totalForms = Array.isArray(data) ? data.length : (data as any)?.total || 0;

    return {
        forms,
        totalForms,
        isLoading,
        error,
        refetch,
    };
}
