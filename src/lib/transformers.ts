import { v4 as uuidv4 } from 'uuid';
import { ISection, IQuestion, FieldType } from '@/types';

/**
 * Maps frontend FieldType to backend FieldType strings
 */
const mapFieldType = (type: FieldType): string => {
    switch (type) {
        case FieldType.SHORT_TEXT:
        case FieldType.EMAIL:
        case FieldType.URL:
        case FieldType.MOBILE:
        case FieldType.NUMBER:
        case FieldType.TIME:
        case FieldType.DATETIME:
            return 'input';
        case FieldType.LONG_TEXT:
            return 'textarea';
        case FieldType.DROPDOWN:
            return 'select';
        case FieldType.CHECKBOX:
            return 'checkbox';
        case FieldType.RADIO:
            return 'radio';
        case FieldType.BOOLEAN:
            return 'boolean';
        case FieldType.RATING:
            return 'rating';
        case FieldType.DATE:
            return 'date';
        case FieldType.FILE_UPLOAD:
            return 'file_upload';
        case FieldType.API_SEARCH:
            return 'api_search';
        case FieldType.CALCULATED:
            return 'calculated';
        default:
            return 'input';
    }
};

/**
 * Transforms frontend section and question models to backend-compatible format
 */
export const transformFormPayload = (sections: ISection[]) => {
    return sections.map((section) => {
        // Create backend-compatible question objects
        const questions = (section.questions || []).map((q: IQuestion) => {
            const {
                question_text,
                order_index,
                field_type,
                ...rest
            } = q;

            return {
                ...rest,
                label: question_text,
                field_type: mapFieldType(field_type),
                // Exclude fields the backend called "Unknown"
                // Actually 'rest' might still contain some if we're not careful
            };
        });

        const {
            order_index,
            is_repeatable,
            questions: _, // handled above
            ...sectionRest
        } = section;

        return {
            ...sectionRest,
            questions,
            // Exclude fields the backend called "Unknown"
        };
    });
};

const mapBackendFieldType = (type: string): FieldType => {
    switch (type) {
        case 'input': return FieldType.SHORT_TEXT;
        case 'textarea': return FieldType.LONG_TEXT;
        case 'select': return FieldType.DROPDOWN;
        case 'checkbox': return FieldType.CHECKBOX;
        case 'radio': return FieldType.RADIO;
        case 'boolean': return FieldType.BOOLEAN;
        case 'rating': return FieldType.RATING;
        case 'date': return FieldType.DATE;
        case 'file_upload': return FieldType.FILE_UPLOAD;
        case 'api_search': return FieldType.API_SEARCH;
        case 'calculated': return FieldType.CALCULATED;
        default: return FieldType.SHORT_TEXT;
    }
};

export const transformBackendToFrontend = (sections: any[]): ISection[] => {
    if (!Array.isArray(sections)) return [];

    return sections.map(s => ({
        ...s,
        id: s.id || s._id || uuidv4(),
        title: s.title || 'Untitled Section',
        questions: (s.questions || []).map((q: any) => ({
            ...q,
            id: q.id || q._id || uuidv4(),
            question_text: q.question_text || q.label || 'Untitled Question',
            field_type: mapBackendFieldType(q.field_type),
            order_index: q.order_index ?? 0
        }))
    }));
};
