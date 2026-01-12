'use client';

import React from 'react';
import { useSortable, SortableContext, verticalListSortingStrategy } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { GripVertical, Trash2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { cn } from '@/lib/utils';
import { ISection } from '@/types';
import { SortableField } from './SortableField';

interface SortableSectionProps {
    section: ISection;
    activeFieldId: string | null;
    onUpdateSection: (id: string, updates: Partial<ISection>) => void;
    onRemoveSection: (id: string) => void;
    onRemoveField: (id: string) => void;
    onSetActiveField: (id: string | null) => void;
    isRemoveDisabled: boolean;
}

export const SortableSection = ({
    section,
    activeFieldId,
    onUpdateSection,
    onRemoveSection,
    onRemoveField,
    onSetActiveField,
    isRemoveDisabled
}: SortableSectionProps) => {
    const {
        attributes,
        listeners,
        setNodeRef,
        transform,
        transition,
        isDragging,
    } = useSortable({ id: section.id });

    const style = {
        transform: CSS.Transform.toString(transform),
        transition,
        zIndex: isDragging ? 5 : 1,
    };

    return (
        <div
            ref={setNodeRef}
            style={style}
            className={cn(
                "group relative space-y-4",
                isDragging && "opacity-50"
            )}
        >
            <Card className="border-none shadow-sm overflow-hidden bg-background">
                <div className="bg-primary/5 px-6 py-4 border-b flex items-center justify-between group-hover:bg-primary/10 transition-colors">
                    <div className="flex items-center flex-1">
                        <div
                            {...attributes}
                            {...listeners}
                            className="mr-3 cursor-grab active:cursor-grabbing opacity-30 hover:opacity-100 touch-none"
                        >
                            <GripVertical className="h-5 w-5" />
                        </div>
                        <div className="flex-1">
                            <Input
                                value={section.title}
                                onChange={(e) => onUpdateSection(section.id, { title: e.target.value })}
                                className="border-none bg-transparent font-bold text-lg p-0 focus-visible:ring-0 h-auto"
                            />
                            <Input
                                value={section.description || ''}
                                onChange={(e) => onUpdateSection(section.id, { description: e.target.value })}
                                placeholder="Section description (optional)"
                                className="border-none bg-transparent text-sm p-0 h-auto focus-visible:ring-0 text-muted-foreground mt-1"
                            />
                        </div>
                    </div>
                    <div className="flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Button
                            variant="ghost"
                            size="icon"
                            className="h-8 w-8 text-destructive hover:bg-destructive hover:text-white"
                            onClick={() => onRemoveSection(section.id)}
                            disabled={isRemoveDisabled}
                        >
                            <Trash2 className="h-4 w-4" />
                        </Button>
                    </div>
                </div>

                <CardContent className="p-6 min-h-[100px] space-y-4">
                    <SortableContext
                        items={section.questions.map(q => q.id)}
                        strategy={verticalListSortingStrategy}
                    >
                        {section.questions.length === 0 ? (
                            <div className="border-2 border-dashed rounded-lg p-12 text-center text-muted-foreground">
                                <p>Drop fields here or click items in the sidebar to add them to this section.</p>
                            </div>
                        ) : (
                            section.questions.map((question) => (
                                <SortableField
                                    key={question.id}
                                    question={question}
                                    isActive={activeFieldId === question.id}
                                    onClick={() => onSetActiveField(question.id)}
                                    onRemove={() => onRemoveField(question.id)}
                                />
                            ))
                        )}
                    </SortableContext>
                </CardContent>
            </Card>
        </div>
    );
};
