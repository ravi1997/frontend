import { useQuery } from '@tanstack/react-query';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
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
            const { data } = await api.get<FetchFormsResponse | IForm[]>(API_ENDPOINTS.FORMS.LIST);
            return data;
        },
    });

    // Helper to normalize data structure
    const forms = Array.isArray(data) ? data : (data as FetchFormsResponse | undefined)?.forms || [];
    const totalForms = Array.isArray(data) ? data.length : (data as FetchFormsResponse | undefined)?.total || 0;

    return {
        forms,
        totalForms,
        isLoading,
        error,
        refetch,
    };
}
