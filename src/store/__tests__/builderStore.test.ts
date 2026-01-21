import { describe, it, expect, beforeEach } from 'vitest';
import { useBuilderStore } from '../builderStore';
import { IWorkflow } from '@/types';

describe('builderStore Workflows', () => {
    // Reset store before each test
    beforeEach(() => {
        useBuilderStore.setState({ workflows: [] });
    });

    it('should add a workflow', () => {
        const workflow: IWorkflow = {
            id: '1',
            name: 'Test Workflow',
            trigger: 'on_submit',
            actions: [],
            is_active: true
        };

        useBuilderStore.getState().addWorkflow(workflow);

        const workflows = useBuilderStore.getState().workflows;
        expect(workflows).toHaveLength(1);
        expect(workflows[0]).toEqual(workflow);
    });

    it('should update a workflow', () => {
        const workflow: IWorkflow = {
            id: '1',
            name: 'Test Workflow',
            trigger: 'on_submit',
            actions: [],
            is_active: true
        };

        useBuilderStore.getState().addWorkflow(workflow);
        useBuilderStore.getState().updateWorkflow('1', { name: 'Updated Name' });

        const workflows = useBuilderStore.getState().workflows;
        expect(workflows[0].name).toBe('Updated Name');
        expect(workflows[0].is_active).toBe(true);
    });

    it('should remove a workflow', () => {
        const workflow: IWorkflow = {
            id: '1',
            name: 'Test Workflow',
            trigger: 'on_submit',
            actions: [],
            is_active: true
        };

        useBuilderStore.getState().addWorkflow(workflow);
        expect(useBuilderStore.getState().workflows).toHaveLength(1);

        useBuilderStore.getState().removeWorkflow('1');
        expect(useBuilderStore.getState().workflows).toHaveLength(0);
    });
});
