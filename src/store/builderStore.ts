import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { v4 as uuidv4 } from 'uuid';
import { ISection, IQuestion, FieldType } from '@/types';

interface BuilderState {
  sections: ISection[];
  activeFieldId: string | null;
  activeSectionId: string | null;
  isDragging: boolean;
}

interface BuilderActions {
  // Section Actions
  addSection: () => void;
  updateSection: (sectionId: string, updates: Partial<ISection>) => void;
  removeSection: (sectionId: string) => void;
  
  // Field Actions
  addField: (sectionId: string, type: FieldType, index?: number) => void;
  updateField: (fieldId: string, updates: Partial<IQuestion>) => void;
  removeField: (fieldId: string) => void;
  duplicateField: (fieldId: string) => void;
  moveField: (fieldId: string, targetSectionId: string, newIndex: number) => void;
  
  // Interaction Actions
  setActiveField: (fieldId: string | null) => void;
  setActiveSection: (sectionId: string | null) => void;
  setIsDragging: (isDragging: boolean) => void;
}

export const useBuilderStore = create<BuilderState & BuilderActions>()(
  devtools((set, get) => ({
    // Initial State
    sections: [
      {
        id: uuidv4(),
        title: 'Untitled Section',
        description: '',
        order: 0,
        questions: [],
      },
    ],
    activeFieldId: null,
    activeSectionId: null,
    isDragging: false,

    // Section Actions
    addSection: () => set((state) => ({
      sections: [
        ...state.sections,
        {
          id: uuidv4(),
          title: `Section ${state.sections.length + 1}`,
          description: '',
          order: state.sections.length,
          questions: [],
        },
      ],
    })),

    updateSection: (sectionId, updates) => set((state) => ({
      sections: state.sections.map((s) => s.id === sectionId ? { ...s, ...updates } : s),
    })),

    removeSection: (sectionId) => set((state) => ({
      sections: state.sections.filter((s) => s.id !== sectionId),
      activeSectionId: state.activeSectionId === sectionId ? null : state.activeSectionId,
    })),

    // Field Actions
    addField: (sectionId, type, index) => set((state) => {
      const newField: IQuestion = {
        id: uuidv4(),
        type,
        label: `Untitled ${type}`,
        required: false,
        order: 0, // Will be calculated below
        options: type === FieldType.DROPDOWN || type === FieldType.RADIO || type === FieldType.CHECKBOX ? [
          { label: 'Option 1', value: 'option-1' }
        ] : undefined,
      };

      const newSections = state.sections.map((section) => {
        if (section.id !== sectionId) return section;

        const updatedQuestions = [...section.questions];
        if (typeof index === 'number') {
          updatedQuestions.splice(index, 0, newField);
        } else {
          updatedQuestions.push(newField);
        }

        // Re-order questions within the section
        return {
          ...section,
          questions: updatedQuestions.map((q, i) => ({ ...q, order: i })),
        };
      });

      return { sections: newSections, activeFieldId: newField.id };
    }),

    updateField: (fieldId, updates) => set((state) => ({
      sections: state.sections.map((section) => ({
        ...section,
        questions: section.questions.map((q) => q.id === fieldId ? { ...q, ...updates } : q),
      })),
    })),

    removeField: (fieldId) => set((state) => ({
      sections: state.sections.map((section) => ({
        ...section,
        questions: section.questions.filter((q) => q.id !== fieldId),
      })),
      activeFieldId: state.activeFieldId === fieldId ? null : state.activeFieldId,
    })),

    duplicateField: (fieldId) => set((state) => {
      let fieldToDuplicate: IQuestion | null = null;
      let targetSectionId: string | null = null;
      let targetIndex: number = -1;

      state.sections.forEach((s) => {
        const idx = s.questions.findIndex((q) => q.id === fieldId);
        if (idx !== -1) {
          fieldToDuplicate = s.questions[idx];
          targetSectionId = s.id;
          targetIndex = idx;
        }
      });

      if (!fieldToDuplicate || !targetSectionId) return state;

      const newField = {
        ...fieldToDuplicate,
        id: uuidv4(),
        label: `${(fieldToDuplicate as IQuestion).label} (Copy)`,
      };

      const newSections = state.sections.map((section) => {
        if (section.id !== targetSectionId) return section;
        const updatedQuestions = [...section.questions];
        updatedQuestions.splice(targetIndex + 1, 0, newField);
        return {
          ...section,
          questions: updatedQuestions.map((q, i) => ({ ...q, order: i })),
        };
      });

      return { sections: newSections, activeFieldId: newField.id };
    }),

    moveField: (fieldId, targetSectionId, newIndex) => set((state) => {
      // Find the moving field and remove it from its current position
      let movedField: IQuestion | null = null;
      const strippedSections = state.sections.map((section) => {
        const found = section.questions.find((q) => q.id === fieldId);
        if (found) movedField = found;
        return {
          ...section,
          questions: section.questions.filter((q) => q.id !== fieldId),
        };
      });

      if (!movedField) return state;

      // Insert it at the new position
      const finalSections = strippedSections.map((section) => {
        if (section.id !== targetSectionId) return section;
        const updatedQuestions = [...section.questions];
        updatedQuestions.splice(newIndex, 0, movedField!);
        return {
          ...section,
          questions: updatedQuestions.map((q, i) => ({ ...q, order: i })),
        };
      });

      return { sections: finalSections };
    }),

    // Interaction Actions
    setActiveField: (fieldId) => set({ activeFieldId: fieldId }),
    setActiveSection: (sectionId) => set({ activeSectionId: sectionId }),
    setIsDragging: (isDragging) => set({ isDragging }),
  }))
);
