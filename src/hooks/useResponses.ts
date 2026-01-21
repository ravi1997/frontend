import { useMutation } from '@tanstack/react-query';
import api from '@/lib/api';
import { API_ENDPOINTS } from '@/lib/constants';

export function useResponses() {
    const exportCsv = useMutation({
        mutationFn: async (formId: string) => {
            const response = await api.get(API_ENDPOINTS.FORMS.EXPORT_CSV(formId), {
                responseType: 'blob',
            });
            return response.data;
        },
        onSuccess: (data, formId) => {
            const url = window.URL.createObjectURL(new Blob([data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `responses_${formId}.csv`);
            document.body.appendChild(link);
            link.click();
            link.remove();
        },
    });

    const exportJson = useMutation({
        mutationFn: async (formId: string) => {
            const response = await api.get(API_ENDPOINTS.FORMS.EXPORT_JSON(formId), {
                responseType: 'blob',
            });
            return response.data;
        },
        onSuccess: (data, formId) => {
            const url = window.URL.createObjectURL(new Blob([data]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `responses_${formId}.json`);
            document.body.appendChild(link);
            link.click();
            link.remove();
        },
    });

    return {
        exportCsv: exportCsv.mutateAsync,
        isExportingCsv: exportCsv.isPending,
        exportJson: exportJson.mutateAsync,
        isExportingJson: exportJson.isPending,
    };
}
