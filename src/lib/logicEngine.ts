import { ILogicRule, IQuestion } from '@/types';

/**
 * Evaluates a single logic rule against form data.
 */
export const evaluateRule = (rule: ILogicRule, formData: Record<string, any>): boolean => {
    const fieldValue = formData[rule.field_id];

    // Normalize values for comparison (basic string conversion)
    const targetValue = rule.value;

    if (fieldValue === undefined || fieldValue === null) {
        return false; // Or should rule define default behavior? For visibility, usually hidden if dep missing.
    }

    switch (rule.operator) {
        case 'equals':
            // weak equality for numbers/strings? strict for now, but ensure type match
            return String(fieldValue) === String(targetValue);
        case 'not_equals':
            return String(fieldValue) !== String(targetValue);
        case 'contains':
            return String(fieldValue).includes(String(targetValue));
        case 'gt':
            return Number(fieldValue) > Number(targetValue);
        case 'lt':
            return Number(fieldValue) < Number(targetValue);
        default:
            return false;
    }
};

/**
 * Evaluates if a field should be visible based on its rules.
 * Returns TRUE if:
 * 1. No rules exist (default visible)
 * 2. ALL rules pass (AND logic - simplifying assumption for MVP)
 */
export const shouldShowField = (field: IQuestion, formData: Record<string, any>): boolean => {
    if (!field.visibility_rules || field.visibility_rules.length === 0) {
        return true;
    }

    // AND logic: All rules must match
    return field.visibility_rules.every(rule => evaluateRule(rule, formData));
};
