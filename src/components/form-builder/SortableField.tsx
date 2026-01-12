'use client';

import React from 'react';
import { useSortable } from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';
import { GripVertical, Trash2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import { cn } from '@/lib/utils';
import { IQuestion } from '@/types';

interface SortableFieldProps {
    question: IQuestion;
    isActive: boolean;
    onClick: () => void;
    onRemove: () => void;
}

export const SortableField = ({
    question,
    isActive,
    onClick,
    onRemove
}: SortableFieldProps) => {
    const {
        attributes,
        listeners,
        setNodeRef,
        transform,
        transition,
        isDragging,
    } = useSortable({ id: question.id });

    const style = {
        transform: CSS.Transform.toString(transform),
        transition,
        zIndex: isDragging ? 10 : 1,
        opacity: isDragging ? 0.5 : 1,
    };

    return (
        <div
            ref={setNodeRef}
            style={style}
            onClick={onClick}
            className={cn(
                "relative flex border rounded-lg p-4 bg-background hover:border-primary transition-all cursor-pointer group/field",
                isActive && "ring-2 ring-primary border-primary shadow-sm",
                isDragging && "shadow-lg border-primary/50"
            )}
        >
            <div className="absolute left-0 top-0 bottom-0 w-1 bg-primary rounded-l-lg opacity-0 group-hover/field:opacity-100 transition-opacity" />

            <div
                {...attributes}
                {...listeners}
                className="mr-3 mt-1 cursor-grab active:cursor-grabbing opacity-30 group-hover/field:opacity-100 touch-none"
            >
                <GripVertical className="h-4 w-4" />
            </div>

            <div className="flex-1 space-y-2">
                <div className="flex justify-between items-start">
                    <Label className="text-sm font-semibold cursor-pointer">
                        {question.question_text}
                        {question.is_required && <span className="text-destructive ml-1">*</span>}
                    </Label>
                    <div className="opacity-0 group-hover/field:opacity-100 flex gap-1">
                        <Button
                            variant="ghost"
                            size="icon"
                            className="h-7 w-7 text-destructive hover:bg-destructive hover:text-white"
                            onClick={(e: React.MouseEvent) => {
                                e.stopPropagation();
                                onRemove();
                            }}
                        >
                            <Trash2 className="h-3 w-3" />
                        </Button>
                    </div>
                </div>

                {question.help_text && (
                    <p className="text-xs text-muted-foreground italic">
                        {question.help_text}
                    </p>
                )}

                {/* Rendering logic for different field types (mock) */}
                <div className="h-10 border rounded-md bg-muted/20 flex items-center px-3 text-sm text-muted-foreground pointer-events-none">
                    {question.field_type.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')} input placeholder...
                </div>
            </div>
        </div>
    );
};
