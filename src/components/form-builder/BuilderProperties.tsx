'use client';

import React from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Button } from '@/components/ui/button';
import { Settings2, Trash2, Copy } from 'lucide-react';
import { Switch } from "@/components/ui/switch";
import { LogicBuilder } from './properties/LogicBuilder';

export const BuilderProperties = () => {
  const {
    sections,
    activeFieldId,
    updateField,
    removeField,
    duplicateField
  } = useBuilderStore();

  // Find the active field
  let activeField = null;
  for (const section of sections) {
    const field = section.questions.find((q) => q.id === activeFieldId);
    if (field) {
      activeField = field;
      break;
    }
  }

  if (!activeFieldId || !activeField) {
    return (
      <aside className="w-80 border-l bg-card p-6 flex flex-col items-center justify-center text-center space-y-4">
        <div className="bg-muted p-4 rounded-full">
          <Settings2 className="h-8 w-8 text-muted-foreground" />
        </div>
        <div>
          <h3 className="font-semibold">No Field Selected</h3>
          <p className="text-sm text-muted-foreground">
            Select a field on the canvas to edit its properties.
          </p>
        </div>
      </aside>
    );
  }

  return (
    <aside className="w-80 border-l bg-card flex flex-col h-[calc(100vh-3.5rem)]">
      <div className="p-4 border-b flex items-center justify-between">
        <h3 className="font-semibold text-sm flex items-center gap-2">
          <Settings2 className="h-4 w-4" />
          Field Properties
        </h3>
        <div className="flex gap-1">
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8"
            onClick={() => duplicateField(activeFieldId)}
            title="Duplicate"
          >
            <Copy className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 text-destructive hover:text-destructive"
            onClick={() => removeField(activeFieldId)}
            title="Delete"
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto p-4 space-y-6">
        {/* Label and Helper Text */}
        <div className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="field-label">Field Label</Label>
            <Input
              id="field-label"
              value={activeField.question_text}
              onChange={(e) => updateField(activeFieldId, { question_text: e.target.value })}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="field-helper">Helper Text</Label>
            <Input
              id="field-helper"
              value={activeField.help_text || ''}
              onChange={(e) => updateField(activeFieldId, { help_text: e.target.value })}
              placeholder="e.g. Please enter your full name"
            />
          </div>
        </div>

        {/* Validation */}
        <div className="space-y-4">
          <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Validation</h4>
          <div className="flex items-center justify-between">
            <Label htmlFor="field-required">Required Field</Label>
            <Switch
              id="field-required"
              checked={activeField.is_required}
              onCheckedChange={(checked) => updateField(activeFieldId, { is_required: checked })}
            />
          </div>
          {activeField.field_type === 'number' && (
            <div className="grid grid-cols-2 gap-2 pt-2">
              <div className="space-y-1">
                <Label className="text-[10px]">Min</Label>
                <Input type="number" size={1} />
              </div>
              <div className="space-y-1">
                <Label className="text-[10px]">Max</Label>
                <Input type="number" />
              </div>
            </div>
          )}
        </div>

        {/* Options (for multi-choice) */}
        {(activeField.field_type === 'dropdown' || activeField.field_type === 'radio' || activeField.field_type === 'checkbox') && (
          <div className="space-y-4">
            <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">Options</h4>
            <div className="space-y-2">
              {activeField.options?.map((option, idx) => (
                <div key={idx} className="flex gap-2">
                  <Input
                    value={option.option_label}
                    onChange={(e) => {
                      const newOptions = [...(activeField!.options || [])];
                      newOptions[idx] = {
                        ...option,
                        option_label: e.target.value,
                        option_value: e.target.value.toLowerCase().replace(/ /g, '-'),
                        order_index: idx
                      };
                      updateField(activeFieldId, { options: newOptions });
                    }}
                  />
                  <Button
                    variant="ghost"
                    size="icon"
                    className="shrink-0 h-9 w-9 text-muted-foreground"
                    onClick={() => {
                      const newOptions = activeField!.options?.filter((_, i) => i !== idx);
                      updateField(activeFieldId, { options: newOptions });
                    }}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              ))}
              <Button
                variant="outline"
                size="sm"
                className="w-full mt-2"
                onClick={() => {
                  const label = `Option ${(activeField!.options?.length || 0) + 1}`;
                  const newOptions = [
                    ...(activeField!.options || []),
                    {
                      option_label: label,
                      option_value: label.toLowerCase().replace(/ /g, '-'),
                      order_index: activeField!.options?.length || 0
                    }
                  ];
                  updateField(activeFieldId, { options: newOptions });
                }}
              >
                Add Option
              </Button>
            </div>
          </div>
        )}

        {/* Logic Rules */}
        <LogicBuilder fieldId={activeFieldId} />
      </div>
    </aside>
  );
};
