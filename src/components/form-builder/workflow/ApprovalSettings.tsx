'use client';

import React from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { UserRole } from '@/types';
import { Button } from '@/components/ui/button';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Plus, Trash2, ArrowDown } from 'lucide-react';

export const ApprovalSettings = () => {
    const {
        approvalEnabled,
        setApprovalEnabled,
        approvalSteps,
        addApprovalStep,
        updateApprovalStep,
        removeApprovalStep
    } = useBuilderStore();

    const handleAddStep = () => {
        addApprovalStep({
            name: `Step ${approvalSteps.length + 1}`,
            required_role: UserRole.MANAGER,
            order: approvalSteps.length,
        });
    };

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between p-4 border rounded-lg bg-card">
                <div className="space-y-0.5">
                    <Label className="text-base">Enable Approval Workflow</Label>
                    <p className="text-sm text-muted-foreground">
                        Require approvals before submissions are finalized.
                    </p>
                </div>
                <Switch
                    checked={approvalEnabled}
                    onCheckedChange={setApprovalEnabled}
                />
            </div>

            {approvalEnabled && (
                <div className="space-y-4">
                    <div className="flex items-center justify-between">
                        <Label>Approval Steps</Label>
                        <Button size="sm" variant="outline" onClick={handleAddStep}>
                            <Plus className="mr-2 h-4 w-4" /> Add Step
                        </Button>
                    </div>

                    {approvalSteps.length === 0 ? (
                        <div className="text-center p-8 border border-dashed rounded-lg text-muted-foreground text-sm">
                            No approval steps configured. Add a step to begin.
                        </div>
                    ) : (
                        <div className="space-y-2">
                            {approvalSteps.map((step, index) => (
                                <React.Fragment key={index}>
                                    {index > 0 && (
                                        <div className="flex justify-center">
                                            <ArrowDown className="text-muted-foreground h-4 w-4" />
                                        </div>
                                    )}
                                    <div className="flex items-start gap-3 p-4 border rounded-lg bg-card relative group">
                                        <div className="flex items-center justify-center h-6 w-6 rounded-full bg-primary/10 text-primary text-xs font-bold shrink-0 mt-2">
                                            {index + 1}
                                        </div>

                                        <div className="flex-1 space-y-3">
                                            <div className="grid grid-cols-2 gap-4">
                                                <div className="space-y-1.5">
                                                    <Label className="text-xs">Step Name</Label>
                                                    <Input
                                                        value={step.name}
                                                        onChange={(e) => updateApprovalStep(index, { name: e.target.value })}
                                                        placeholder="e.g. Manager Approval"
                                                    />
                                                </div>
                                                <div className="space-y-1.5">
                                                    <Label className="text-xs">Approver Role</Label>
                                                    <Select
                                                        value={step.required_role}
                                                        onValueChange={(val) => updateApprovalStep(index, { required_role: val as UserRole })}
                                                    >
                                                        <SelectTrigger>
                                                            <SelectValue />
                                                        </SelectTrigger>
                                                        <SelectContent>
                                                            {Object.values(UserRole).map((role) => (
                                                                <SelectItem key={role} value={role}>{role}</SelectItem>
                                                            ))}
                                                        </SelectContent>
                                                    </Select>
                                                </div>
                                            </div>
                                        </div>

                                        <Button
                                            variant="ghost"
                                            size="icon"
                                            className="h-8 w-8 text-destructive opacity-0 group-hover:opacity-100 absolute top-2 right-2"
                                            onClick={() => removeApprovalStep(index)}
                                        >
                                            <Trash2 className="h-4 w-4" />
                                        </Button>
                                    </div>
                                </React.Fragment>
                            ))}
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};
