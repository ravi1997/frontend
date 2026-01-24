'use client';

import React, { useState } from 'react';
import { IWorkflow, WorkflowTriggerType, WorkflowActionType, IWorkflowAction } from '@/types';
import { useBuilderStore } from '@/store/builderStore';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Plus, Trash2, Workflow as WorkflowIcon, FileSignature, Zap } from 'lucide-react';
import { v4 as uuidv4 } from 'uuid';
import { ApprovalSettings } from './ApprovalSettings';

export const WorkflowManager = () => {
    const { workflows, addWorkflow, removeWorkflow, updateWorkflow } = useBuilderStore();
    const [isOpen, setIsOpen] = useState(false);
    const [activeTab, setActiveTab] = useState<'automation' | 'approvals'>('automation');
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

    const updateAction = (actionId: string, updates: Partial<IWorkflowAction>) => {
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
            <DialogContent className="max-w-4xl max-h-[85vh] overflow-y-auto flex flex-col gap-0 p-0">
                <div className="p-6 border-b pb-4">
                    <DialogHeader>
                        <DialogTitle>Form Workflows & Automation</DialogTitle>
                        <DialogDescription>
                            Configure approvals and automated actions.
                        </DialogDescription>
                    </DialogHeader>

                    <div className="flex items-center gap-2 mt-4">
                        <Button
                            variant={activeTab === 'automation' ? 'default' : 'outline'}
                            onClick={() => setActiveTab('automation')}
                            size="sm"
                            className="gap-2"
                        >
                            <Zap className="h-4 w-4" /> Automation
                        </Button>
                        <Button
                            variant={activeTab === 'approvals' ? 'default' : 'outline'}
                            onClick={() => setActiveTab('approvals')}
                            size="sm"
                            className="gap-2"
                        >
                            <FileSignature className="h-4 w-4" /> Approvals
                        </Button>
                    </div>
                </div>

                <div className="p-6">
                    {activeTab === 'approvals' ? (
                        <div className="border rounded-xl p-1">
                            {/* Render Approval Settings */}
                            <ApprovalSettings />
                        </div>
                    ) : (
                        <div className="grid grid-cols-12 gap-6">
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
                                                    <Trash2 className="h-3 w-3" />
                                                </Button>
                                            </div>
                                            <div className="grid grid-cols-2 gap-2">
                                                <div>
                                                    <Label className="text-xs">Type</Label>
                                                    <Select
                                                        value={action.type}
                                                        onValueChange={(v) => updateAction(action.id, { type: v as WorkflowActionType })}
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

                                            {/* Action Configuration */}
                                            {action.type === 'email' && (
                                                <div className="grid grid-cols-1 gap-2 mt-2 pt-2 border-t">
                                                    <div>
                                                        <Label className="text-xs">Subject</Label>
                                                        <Input
                                                            className="h-8"
                                                            value={action.config?.subject || ''}
                                                            onChange={(e) => updateAction(action.id, {
                                                                config: { ...action.config, subject: e.target.value }
                                                            })}
                                                            placeholder="Email Subject"
                                                        />
                                                    </div>
                                                    <div>
                                                        <Label className="text-xs">Body Template</Label>
                                                        <Input
                                                            className="h-8"
                                                            value={action.config?.body || ''}
                                                            onChange={(e) => updateAction(action.id, {
                                                                config: { ...action.config, body: e.target.value }
                                                            })}
                                                            placeholder="Notification content..."
                                                        />
                                                    </div>
                                                </div>
                                            )}

                                            {action.type === 'webhook' && (
                                                <div className="mt-2 pt-2 border-t">
                                                    <Label className="text-xs">Headers (JSON)</Label>
                                                    <Input
                                                        className="h-8 font-mono text-xs"
                                                        value={action.config?.headers || ''}
                                                        onChange={(e) => updateAction(action.id, {
                                                            config: { ...action.config, headers: e.target.value }
                                                        })}
                                                        placeholder='{"Authorization": "Bearer ..."}'
                                                    />
                                                </div>
                                            )}
                                        </div>
                                    ))}
                                </div>

                                <Button className="w-full" onClick={handleSave}>
                                    {editingWorkflowId ? 'Update Workflow' : 'Create Workflow'}
                                </Button>
                            </div>
                        </div>
                    )}
                </div>
            </DialogContent>
        </Dialog>
    );
};
