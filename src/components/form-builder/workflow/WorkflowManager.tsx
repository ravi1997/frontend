'use client';

import React, { useState } from 'react';
import { IWorkflow, WorkflowTriggerType, WorkflowActionType } from '@/types';
import { useBuilderStore } from '@/store/builderStore';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Plus, Trash2, Workflow as WorkflowIcon, X } from 'lucide-react';
import { v4 as uuidv4 } from 'uuid';

export const WorkflowManager = () => {
    const { workflows, addWorkflow, removeWorkflow, updateWorkflow } = useBuilderStore();
    const [isOpen, setIsOpen] = useState(false);
    const [editingWorkflowId, setEditingWorkflowId] = useState<string | null>(null);

    // Temp state for creating/editing
    const [formData, setFormData] = useState<Partial<IWorkflow>>({
        name: '',
        trigger: 'on_submit',
        actions: [],
        is_active: true
    });

    const resetForm = () => {
        setFormData({
            name: '',
            trigger: 'on_submit',
            actions: [],
            is_active: true
        });
        setEditingWorkflowId(null);
    };

    const handleSave = () => {
        if (!formData.name) return;

        if (editingWorkflowId) {
            updateWorkflow(editingWorkflowId, formData);
        } else {
            addWorkflow({
                id: uuidv4(),
                name: formData.name,
                trigger: formData.trigger as WorkflowTriggerType,
                actions: formData.actions || [],
                is_active: formData.is_active ?? true
            });
        }
        resetForm();
    };

    const handleEdit = (wf: IWorkflow) => {
        setEditingWorkflowId(wf.id);
        setFormData({ ...wf });
    };

    const addAction = () => {
        const newAction = {
            id: uuidv4(),
            type: 'email' as WorkflowActionType,
            target: '',
            config: {}
        };
        setFormData(prev => ({
            ...prev,
            actions: [...(prev.actions || []), newAction]
        }));
    };

    const removeAction = (actionId: string) => {
        setFormData(prev => ({
            ...prev,
            actions: (prev.actions || []).filter(a => a.id !== actionId)
        }));
    };

    const updateAction = (actionId: string, updates: any) => {
        setFormData(prev => ({
            ...prev,
            actions: (prev.actions || []).map(a => a.id === actionId ? { ...a, ...updates } : a)
        }));
    };

    return (
        <Dialog open={isOpen} onOpenChange={(open) => { setIsOpen(open); if (!open) resetForm(); }}>
            <DialogTrigger asChild>
                <Button variant="outline" size="sm">
                    <WorkflowIcon className="mr-2 h-4 w-4" />
                    Workflows {workflows.length > 0 && `(${workflows.length})`}
                </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>Manage Form Workflows</DialogTitle>
                    <DialogDescription>
                        Configure automated actions when this form is submitted.
                    </DialogDescription>
                </DialogHeader>

                <div className="grid grid-cols-12 gap-6 mt-4">
                    {/* Sidebar: List of Workflows */}
                    <div className="col-span-4 border-r pr-4 space-y-2">
                        <Button
                            variant={!editingWorkflowId ? "secondary" : "ghost"}
                            className="w-full justify-start"
                            onClick={resetForm}
                        >
                            <Plus className="mr-2 h-4 w-4" /> New Workflow
                        </Button>
                        <div className="space-y-1">
                            {workflows.map(wf => (
                                <div key={wf.id} className="flex items-center group">
                                    <Button
                                        variant={editingWorkflowId === wf.id ? "secondary" : "ghost"}
                                        className="w-full justify-start text-sm truncate"
                                        onClick={() => handleEdit(wf)}
                                    >
                                        {wf.name}
                                    </Button>
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        className="h-8 w-8 opacity-0 group-hover:opacity-100"
                                        onClick={(e) => { e.stopPropagation(); removeWorkflow(wf.id); }}
                                    >
                                        <Trash2 className="h-3 w-3 text-destructive" />
                                    </Button>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Main Area: Editor */}
                    <div className="col-span-8 space-y-4">
                        <div className="space-y-2">
                            <Label>Workflow Name</Label>
                            <Input
                                value={formData.name}
                                onChange={(e) => setFormData(p => ({ ...p, name: e.target.value }))}
                                placeholder="e.g. Notify Manager"
                            />
                        </div>

                        <div className="space-y-2">
                            <Label>Trigger</Label>
                            <Select
                                value={formData.trigger}
                                onValueChange={(v) => setFormData(p => ({ ...p, trigger: v as WorkflowTriggerType }))}
                            >
                                <SelectTrigger>
                                    <SelectValue />
                                </SelectTrigger>
                                <SelectContent>
                                    <SelectItem value="on_submit">On Submit</SelectItem>
                                    <SelectItem value="on_approve">On Approve</SelectItem>
                                    <SelectItem value="on_reject">On Reject</SelectItem>
                                    {/* TODO: Disable approve/reject if approvals not enabled */}
                                </SelectContent>
                            </Select>
                        </div>

                        <div className="space-y-3">
                            <div className="flex items-center justify-between">
                                <Label>Actions</Label>
                                <Button size="sm" variant="outline" onClick={addAction}>Add Action</Button>
                            </div>

                            {formData.actions?.length === 0 && (
                                <div className="text-sm text-muted-foreground text-center py-4 border border-dashed rounded">
                                    No actions defined.
                                </div>
                            )}

                            {formData.actions?.map((action, idx) => (
                                <div key={action.id} className="p-3 border rounded space-y-3 bg-muted/20">
                                    <div className="flex items-center justify-between">
                                        <span className="text-xs font-semibold">Action #{idx + 1}</span>
                                        <Button
                                            variant="ghost"
                                            size="sm"
                                            className="h-6 w-6"
                                            onClick={() => removeAction(action.id)}
                                        >
                                            <X className="h-3 w-3" /> // Note: Need to import X, I imported simple Trash2 before. Wait, I imported X for Dialog but not here.
                                            {/* I also imported Trash2, I'll use Trash2 */}
                                            <Trash2 className="h-3 w-3" />
                                        </Button>
                                    </div>
                                    <div className="grid grid-cols-2 gap-2">
                                        <div>
                                            <Label className="text-xs">Type</Label>
                                            <Select
                                                value={action.type}
                                                onValueChange={(v) => updateAction(action.id, { type: v })}
                                            >
                                                <SelectTrigger className="h-8">
                                                    <SelectValue />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="email">Send Email</SelectItem>
                                                    <SelectItem value="slack">Send Slack Msg</SelectItem>
                                                    <SelectItem value="webhook">Webhook</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div>
                                            <Label className="text-xs">Target</Label>
                                            <Input
                                                className="h-8"
                                                value={action.target || ''}
                                                onChange={(e) => updateAction(action.id, { target: e.target.value })}
                                                placeholder={action.type === 'email' ? 'Enter email' : 'Webhook URL'}
                                            />
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>

                        <Button className="w-full" onClick={handleSave}>
                            {editingWorkflowId ? 'Update Workflow' : 'Create Workflow'}
                        </Button>
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    );
};
