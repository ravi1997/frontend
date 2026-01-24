'use client';

import React, { useState } from 'react';
import { useBuilderStore } from '@/store/builderStore';
import { useMounted } from '@/hooks/useMounted';
import { Button } from '@/components/ui/button';
import { Plus } from 'lucide-react';
import {
  DndContext,
  DragEndEvent,
  PointerSensor,
  useSensor,
  useSensors,
  closestCorners,
  DragOverEvent,
  DragStartEvent,
  DragOverlay,
  defaultDropAnimationSideEffects
} from '@dnd-kit/core';
import {
  SortableContext,
  verticalListSortingStrategy,
} from '@dnd-kit/sortable';
import { SortableSection } from './SortableSection';
import { SortableField } from './SortableField';

export const BuilderCanvas = () => {
  const {
    sections,
    activeFieldId,
    setActiveField,
    addSection,
    updateSection,
    removeSection,
    removeField,
    moveField,
    moveSection,
    setIsDragging
  } = useBuilderStore();

  const mounted = useMounted();
  const [activeId, setActiveId] = useState<string | null>(null);
  const [activeType, setActiveType] = useState<'section' | 'field' | null>(null);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 5,
      },
    })
  );

  const handleDragStart = (event: DragStartEvent) => {
    const { active } = event;
    setActiveId(active.id as string);
    setIsDragging(true);

    // Determine if it's a section or a field
    const isSection = sections.some(s => s.id === active.id);
    setActiveType(isSection ? 'section' : 'field');
  };

  const handleDragOver = (event: DragOverEvent) => {
    const { active, over } = event;
    if (!over) return;

    const activeId = active.id as string;
    const overId = over.id as string;

    if (activeId === overId) return;

    const isActiveField = !sections.some(s => s.id === activeId);
    const isOverField = !sections.some(s => s.id === overId);

    if (isActiveField) {
      // Find the over section/container
      let overSectionId = '';
      if (isOverField) {
        // Find which section this field belongs to
        sections.forEach(s => {
          if (s.questions.some(q => q.id === overId)) {
            overSectionId = s.id;
          }
        });
      } else {
        overSectionId = overId;
      }

      if (overSectionId) {
        // Check if moving to a different section
        const activeSection = sections.find(s => s.questions.some(q => q.id === activeId));
        if (activeSection && activeSection.id !== overSectionId) {
          // This part is tricky with moveField because moveField expects an index.
          // For dragOver, we might want to just update the UI state optimistically
          // but for now, we'll let handleDragEnd deal with the final move.
        }
      }
    }
  };

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveId(null);
    setActiveType(null);
    setIsDragging(false);

    if (!over) return;

    const activeId = active.id as string;
    const overId = over.id as string;

    if (activeType === 'section') {
      if (activeId !== overId) {
        const newIndex = sections.findIndex(s => s.id === overId);
        moveSection(activeId, newIndex);
      }
    } else if (activeType === 'field') {
      // Find the sections and indices
      let overSectionId = '';
      let overIndex = -1;

      sections.forEach(s => {
        const idx = s.questions.findIndex(q => q.id === overId);
        if (idx !== -1) {
          overSectionId = s.id;
          overIndex = idx;
        } else if (s.id === overId) {
          // Dropped directly on a section
          overSectionId = s.id;
          overIndex = s.questions.length;
        }
      });

      if (overSectionId) {
        moveField(activeId, overSectionId, overIndex === -1 ? 0 : overIndex);
      }
    }
  };

  // Find the active item for the overlay
  const activeQuestion = activeType === 'field'
    ? sections.flatMap(s => s.questions).find(q => q.id === activeId)
    : null;

  const activeSection = activeType === 'section'
    ? sections.find(s => s.id === activeId)
    : null;

  if (!mounted) {
    return (
      <div className="flex-1 bg-muted/30 p-8 flex justify-center">
        <div className="w-full max-w-3xl space-y-8 min-h-full flex flex-col">
          <div className="flex-1 space-y-6">
            <div className="animate-pulse space-y-4">
              <div className="h-40 bg-muted rounded-lg w-full"></div>
              <div className="h-40 bg-muted rounded-lg w-full"></div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div role="main" className="flex-1 bg-muted/30 overflow-y-auto p-8 flex justify-center scroll-smooth">
      <div className="w-full max-w-3xl space-y-8 min-h-full flex flex-col">
        <div className="flex-1 space-y-6">
          <DndContext
            sensors={sensors}
            collisionDetection={closestCorners}
            onDragStart={handleDragStart}
            onDragOver={handleDragOver}
            onDragEnd={handleDragEnd}
          >
            <SortableContext
              items={sections.map(s => s.id)}
              strategy={verticalListSortingStrategy}
            >
              {sections.map((section) => (
                <SortableSection
                  key={section.id}
                  section={section}
                  activeFieldId={activeFieldId}
                  onUpdateSection={updateSection}
                  onRemoveSection={removeSection}
                  onRemoveField={removeField}
                  onSetActiveField={setActiveField}
                  isRemoveDisabled={sections.length <= 1}
                />
              ))}
            </SortableContext>

            <DragOverlay dropAnimation={{
              sideEffects: defaultDropAnimationSideEffects({
                styles: {
                  active: {
                    opacity: '0.5',
                  },
                },
              }),
            }}>
              {activeType === 'section' && activeSection ? (
                <div className="w-[768px] opacity-80">
                  <SortableSection
                    section={activeSection}
                    activeFieldId={null}
                    onUpdateSection={() => { }}
                    onRemoveSection={() => { }}
                    onRemoveField={() => { }}
                    onSetActiveField={() => { }}
                    isRemoveDisabled={false}
                  />
                </div>
              ) : activeType === 'field' && activeQuestion ? (
                <div className="w-[700px] opacity-80">
                  <SortableField
                    question={activeQuestion}
                    isActive={false}
                    onClick={() => { }}
                    onRemove={() => { }}
                  />
                </div>
              ) : null}
            </DragOverlay>
          </DndContext>
        </div>

        <div className="flex justify-center pt-8 pb-32">
          <Button
            variant="outline"
            size="lg"
            className="rounded-full shadow-md px-8 hover:bg-primary/5 hover:text-primary transition-all border-primary/30 flex items-center justify-center gap-3 h-12"
            onClick={addSection}
          >
            <Plus className="h-5 w-5" />
            <span className="font-semibold">Add New Section</span>
          </Button>
        </div>
      </div>
    </div>
  );
};
