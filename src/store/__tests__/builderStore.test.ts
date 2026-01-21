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

describe('builderStore Versions', () => {
    beforeEach(() => {
        useBuilderStore.setState({ versions: [], sections: [] });
    });

    it('should set versions', () => {
        const versions: any[] = [{ version_number: 1, sections: [], created_at: new Date() }];
        useBuilderStore.getState().setVersions(versions);
        expect(useBuilderStore.getState().versions).toHaveLength(1);
    });

    it('should load a version', () => {
        const version: any = {
            version_number: 1,
            sections: [{ id: 's1', title: 'Old Section', order_index: 0, questions: [], is_repeatable: false }],
            created_at: new Date()
        };

        useBuilderStore.getState().loadVersion(version);

        const sections = useBuilderStore.getState().sections;
        expect(sections).toHaveLength(1);
        expect(sections[0].title).toBe('Old Section');
    });
});
