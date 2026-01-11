'use client';

import React from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Plus, Trash2, GripVertical, ChevronUp, ChevronDown } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';

export const BuilderCanvas = () => {
  const { 
    sections, 
    activeFieldId, 
    setActiveField, 
    addSection, 
    updateSection,
    removeSection,
    removeField
  } = useBuilderStore();

  return (
    <div className="flex-1 bg-muted/30 overflow-y-auto p-8 flex justify-center">
      <div className="w-full max-w-3xl space-y-6">
        {sections.map((section, sIdx) => (
          <div key={section.id} className="group relative space-y-4">
            {/* Section Header */}
            <Card className="border-none shadow-sm overflow-hidden bg-background">
              <div className="bg-primary/5 px-6 py-4 border-b flex items-center justify-between group-hover:bg-primary/10 transition-colors">
                <div className="flex-1">
                  <Input
                    value={section.title}
                    onChange={(e) => updateSection(section.id, { title: e.target.value })}
                    className="border-none bg-transparent font-bold text-lg p-0 focus-visible:ring-0 h-auto"
                  />
                  <Input
                    value={section.description || ''}
                    onChange={(e) => updateSection(section.id, { description: e.target.value })}
                    placeholder="Section description (optional)"
                    className="border-none bg-transparent text-sm p-0 h-auto focus-visible:ring-0 text-muted-foreground mt-1"
                  />
                </div>
                <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                  <Button
                    variant="ghost"
                    size="icon"
                    className="h-8 w-8 text-destructive"
                    onClick={() => removeSection(section.id)}
                    disabled={sections.length <= 1}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              </div>
              
              <CardContent className="p-6 min-h-[100px] space-y-4">
                {section.questions.length === 0 ? (
                  <div className="border-2 border-dashed rounded-lg p-12 text-center text-muted-foreground">
                    <p>Drop fields here or click items in the sidebar to add them to this section.</p>
                  </div>
                ) : (
                  section.questions.map((question) => (
                    <div
                      key={question.id}
                      onClick={() => setActiveField(question.id)}
                      className={cn(
                        "relative flex border rounded-lg p-4 bg-background hover:border-primary transition-all cursor-pointer group/field",
                        activeFieldId === question.id && "ring-2 ring-primary border-primary shadow-sm"
                      )}
                    >
                      <div className="absolute left-0 top-0 bottom-0 w-1 bg-primary rounded-l-lg opacity-0 group-hover/field:opacity-100 transition-opacity" />
                      
                      <div className="mr-3 mt-1 cursor-grab opacity-30 group-hover/field:opacity-100">
                        <GripVertical className="h-4 w-4" />
                      </div>

                      <div className="flex-1 space-y-2">
                        <div className="flex justify-between items-start">
                          <Label className="text-sm font-semibold">
                            {question.label}
                            {question.required && <span className="text-destructive ml-1">*</span>}
                          </Label>
                          <div className="opacity-0 group-hover/field:opacity-100 flex gap-1">
                            <Button 
                              variant="ghost" 
                              size="icon" 
                              className="h-7 w-7 text-destructive"
                              onClick={(e) => {
                                e.stopPropagation();
                                removeField(question.id);
                              }}
                            >
                              <Trash2 className="h-3 w-3" />
                            </Button>
                          </div>
                        </div>
                        
                        {question.description && (
                          <p className="text-xs text-muted-foreground italic">
                            {question.description}
                          </p>
                        )}

                        {/* Rendering logic for different field types (mock) */}
                        <div className="h-10 border rounded-md bg-muted/20 flex items-center px-3 text-sm text-muted-foreground pointer-events-none">
                          {question.type.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')} input placeholder...
                        </div>
                      </div>
                    </div>
                  ))
                )}
              </CardContent>
            </Card>
          </div>
        ))}
        
        <div className="flex justify-center pb-12">
          <Button 
            variant="outline" 
            className="rounded-full shadow-sm hover:bg-primary/5 hover:text-primary transition-colors border-primary/20"
            onClick={addSection}
          >
            <Plus className="mr-2 h-4 w-4" />
            Add New Section
          </Button>
        </div>
      </div>
    </div>
  );
};
