'use client';

import React, { useState } from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import { Trash2, Plus } from 'lucide-react';
import { ILogicRule, LogicOperator, IQuestion } from '@/types';
import { v4 as uuidv4 } from 'uuid';

interface LogicBuilderProps {
    fieldId: string;
}

export const LogicBuilder: React.FC<LogicBuilderProps> = ({ fieldId }) => {
    const { sections, updateField } = useBuilderStore();

    // Find current field
    let currentField: IQuestion | undefined;
    const allFields: IQuestion[] = [];

    sections.forEach(section => {
        section.questions.forEach(q => {
            allFields.push(q);
            if (q.id === fieldId) {
                currentField = q;
            }
        });
    });

    const [newRule, setNewRule] = useState<Partial<ILogicRule>>({
        operator: 'equals',
        value: ''
    });

    if (!currentField) return null;

    // Filter potential source fields: exclude self and maybe fields that depend on this one (circular - hard to detect deeply for MVP, just exclude self)
    const sourceFields = allFields.filter(f => f.id !== fieldId);

    const handleAddRule = () => {
        if (!newRule.field_id || !newRule.operator || newRule.value === undefined) {
            return;
        }

        const rule: ILogicRule = {
            id: uuidv4(),
            field_id: newRule.field_id,
            operator: newRule.operator as LogicOperator,
            value: newRule.value
        };

        const updatedRules = [...(currentField?.visibility_rules || []), rule];
        updateField(fieldId, { visibility_rules: updatedRules });
        setNewRule({ operator: 'equals', value: '' });
    };

    const removeRule = (ruleId: string) => {
        const updatedRules = currentField?.visibility_rules?.filter(r => r.id !== ruleId) || [];
        updateField(fieldId, { visibility_rules: updatedRules });
    };

    return (
        <div className="space-y-4">
            <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Conditional Logic</h4>

            {/* Existing Rules */}
            <div className="space-y-2">
                {currentField.visibility_rules?.map((rule) => {
                    const sourceField = sourceFields.find(f => f.id === rule.field_id);
                    return (
                        <div key={rule.id} className="text-sm bg-muted p-2 rounded-md flex items-center justify-between border">
                            <div className="flex-1 overflow-hidden">
                                <span className="text-muted-foreground">Show if </span>
                                <span className="font-medium truncate">{sourceField?.question_text || 'Unknown Field'}</span>
                                <span className="px-1 text-muted-foreground">{rule.operator}</span>
                                <span className="font-medium">"{rule.value}"</span>
                            </div>
                            <Button
                                variant="ghost"
                                size="icon"
                                className="h-6 w-6 shrink-0 text-destructive hover:text-destructive"
                                onClick={() => removeRule(rule.id)}
                            >
                                <Trash2 className="h-3 w-3" />
                            </Button>
                        </div>
                    );
                })}
            </div>

            {/* Add Rule Form */}
            <div className="border rounded-lg p-3 space-y-3 bg-muted/20">
                <div className="space-y-1">
                    <Label className="text-xs">If Field</Label>
                    <Select
                        value={newRule.field_id}
                        onValueChange={(val) => setNewRule({ ...newRule, field_id: val })}
                    >
                        <SelectTrigger className="h-8">
                            <SelectValue placeholder="Select field..." />
                        </SelectTrigger>
                        <SelectContent>
                            {sourceFields.map(field => (
                                <SelectItem key={field.id} value={field.id}>
                                    {field.question_text || 'Untitled'}
                                </SelectItem>
                            ))}
                        </SelectContent>
                    </Select>
                </div>

                <div className="grid grid-cols-2 gap-2">
                    <div className="space-y-1">
                        <Label className="text-xs">Operator</Label>
                        <Select
                            value={newRule.operator}
                            onValueChange={(val) => setNewRule({ ...newRule, operator: val as LogicOperator })}
                        >
                            <SelectTrigger className="h-8">
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="equals">Equals</SelectItem>
                                <SelectItem value="not_equals">Not Equals</SelectItem>
                                <SelectItem value="contains">Contains</SelectItem>
                                <SelectItem value="gt">Greater Than</SelectItem>
                                <SelectItem value="lt">Less Than</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                    <div className="space-y-1">
                        <Label className="text-xs">Value</Label>
                        <Input
                            className="h-8"
                            value={String(newRule.value || '')}
                            onChange={(e) => setNewRule({ ...newRule, value: e.target.value })}
                            placeholder="Value to match"
                        />
                    </div>
                </div>

                <Button
                    variant="secondary"
                    size="sm"
                    className="w-full"
                    onClick={handleAddRule}
                    disabled={!newRule.field_id}
                >
                    <Plus className="h-3 w-3 mr-2" /> Add Rule
                </Button>
            </div>
        </div>
    );
};
