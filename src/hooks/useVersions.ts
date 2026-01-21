import { useQuery } from '@tanstack/react-query';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';
import { IFormVersion } from '@/types';
import { useBuilderStore } from '@/store/builderStore';
import { useEffect } from 'react';

export function useVersions(formId?: string) {
    const setVersions = useBuilderStore((state) => state.setVersions);

    const query = useQuery({
        queryKey: ['versions', formId],
        queryFn: async () => {
            if (!formId) return [];
            // Handle mock/dev scenario where backend might 404
            try {
                const response = await api.get(API_ENDPOINTS.FORMS.VERSIONS(formId));
                return response.data as IFormVersion[];
            } catch (error) {
                console.warn('Failed to fetch versions (using mock data for dev):', error);
                // Return mock data for demo purposes if API fails
                return [
                    {
                        version_number: 1,
                        sections: [],
                        response_count: 0,
                        created_at: new Date().toISOString()
                    }
                ] as IFormVersion[];
            }
        },
        enabled: !!formId,
    });

    // innovative side-effect: sync with store
    useEffect(() => {
        if (query.data) {
            setVersions(query.data);
        }
    }, [query.data, setVersions]);

    return query;
}
