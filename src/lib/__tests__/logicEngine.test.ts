import { describe, it, expect } from 'vitest';
import { evaluateRule, shouldShowField } from '../logicEngine';
import { ILogicRule, IQuestion } from '@/types';

describe('Logic Engine', () => {
    describe('evaluateRule', () => {
        it('should evaluate "equals" correctly', () => {
            const rule: ILogicRule = { id: 'r1', field_id: 'q1', operator: 'equals', value: 'yes' };
            expect(evaluateRule(rule, { q1: 'yes' })).toBe(true);
            expect(evaluateRule(rule, { q1: 'no' })).toBe(false);
        });

        it('should evaluate "not_equals" correctly', () => {
            const rule: ILogicRule = { id: 'r1', field_id: 'q1', operator: 'not_equals', value: 'yes' };
            expect(evaluateRule(rule, { q1: 'no' })).toBe(true);
            expect(evaluateRule(rule, { q1: 'yes' })).toBe(false);
        });

        it('should evaluate "gt" (numbers) correctly', () => {
            const rule: ILogicRule = { id: 'r1', field_id: 'age', operator: 'gt', value: 18 };
            expect(evaluateRule(rule, { age: 21 })).toBe(true);
            expect(evaluateRule(rule, { age: 10 })).toBe(false);
        });
    });

    describe('shouldShowField', () => {
        it('should be visible if no rules', () => {
            const field = { id: 'q2' } as IQuestion;
            expect(shouldShowField(field, {})).toBe(true);
        });

        it('should be hidden if dependency matching fails', () => {
            const field = {
                id: 'q2',
                visibility_rules: [
                    { id: 'r1', field_id: 'q1', operator: 'equals', value: 'show' } as ILogicRule
                ]
            } as IQuestion;

            expect(shouldShowField(field, { q1: 'hide' })).toBe(false);
        });

        it('should be visible if dependency matching succeeds', () => {
            const field = {
                id: 'q2',
                visibility_rules: [
                    { id: 'r1', field_id: 'q1', operator: 'equals', value: 'show' } as ILogicRule
                ]
            } as IQuestion;

            expect(shouldShowField(field, { q1: 'show' })).toBe(true);
        });
    });
});
