import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { v4 as uuidv4 } from 'uuid';
import { ISection, IQuestion, FieldType } from '@/types';

interface BuilderState {
  sections: ISection[];
  activeFieldId: string | null;
  activeSectionId: string | null;
  isDragging: boolean;
  formTitle: string;
  formDescription: string;
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
  moveSection: (sectionId: string, newIndex: number) => void;

  // Interaction Actions
  setActiveField: (fieldId: string | null) => void;
  setActiveSection: (sectionId: string | null) => void;
  setIsDragging: (isDragging: boolean) => void;
  setFormMetadata: (updates: { title?: string; description?: string }) => void;
}

export const useBuilderStore = create<BuilderState & BuilderActions>()(
  devtools((set) => ({
    // Initial State
    sections: [
      {
        id: uuidv4(),
        title: 'Untitled Section',
        description: '',
        order_index: 0,
        questions: [],
        is_repeatable: false,
      },
    ],
    activeFieldId: null,
    activeSectionId: null,
    isDragging: false,
    formTitle: 'Untitled Form',
    formDescription: '',

    setFormMetadata: (updates) => set((state) => ({
      formTitle: updates.title ?? state.formTitle,
      formDescription: updates.description ?? state.formDescription,
    })),

    // Section Actions
    addSection: () => set((state: BuilderState) => ({
      sections: [
        ...state.sections,
        {
          id: uuidv4(),
          title: `Section ${state.sections.length + 1}`,
          description: '',
          order_index: state.sections.length,
          questions: [],
          is_repeatable: false,
        },
      ],
    })),

    updateSection: (sectionId: string, updates: Partial<ISection>) => set((state: BuilderState) => ({
      sections: state.sections.map((s) => s.id === sectionId ? { ...s, ...updates } : s),
    })),

    removeSection: (sectionId: string) => set((state: BuilderState) => ({
      sections: state.sections.filter((s) => s.id !== sectionId),
      activeSectionId: state.activeSectionId === sectionId ? null : state.activeSectionId,
    })),

    // Field Actions
    addField: (sectionId: string, type: FieldType, index?: number) => set((state: BuilderState) => {
      const newField: IQuestion = {
        id: uuidv4(),
        field_type: type,
        question_text: `Untitled ${type}`,
        is_required: false,
        order_index: 0,
        options: type === FieldType.DROPDOWN || type === FieldType.RADIO || type === FieldType.CHECKBOX ? [
          { option_label: 'Option 1', option_value: 'option-1', order_index: 0 }
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
          questions: updatedQuestions.map((q, i) => ({ ...q, order_index: i })),
        };
      });

      return { sections: newSections, activeFieldId: newField.id };
    }),

    updateField: (fieldId: string, updates: Partial<IQuestion>) => set((state: BuilderState) => ({
      sections: state.sections.map((section) => ({
        ...section,
        questions: section.questions.map((q) => q.id === fieldId ? { ...q, ...updates } : q),
      })),
    })),

    removeField: (fieldId: string) => set((state: BuilderState) => ({
      sections: state.sections.map((section) => ({
        ...section,
        questions: section.questions.filter((q) => q.id !== fieldId),
      })),
      activeFieldId: state.activeFieldId === fieldId ? null : state.activeFieldId,
    })),

    duplicateField: (fieldId: string) => set((state: BuilderState) => {
      let fieldToDuplicate: IQuestion | undefined;
      let targetSectionId: string | undefined;
      let targetIndex: number = -1;

      for (const section of state.sections) {
        const idx = section.questions.findIndex((q) => q.id === fieldId);
        if (idx !== -1) {
          fieldToDuplicate = section.questions[idx];
          targetSectionId = section.id;
          targetIndex = idx;
          break;
        }
      }

      if (!fieldToDuplicate || !targetSectionId) return {};

      const newField: IQuestion = {
        ...fieldToDuplicate,
        id: uuidv4(),
        question_text: `${fieldToDuplicate.question_text} (Copy)`,
      };

      const newSections = state.sections.map((section) => {
        if (section.id !== targetSectionId) return section;
        const updatedQuestions = [...section.questions];
        updatedQuestions.splice(targetIndex + 1, 0, newField);
        return {
          ...section,
          questions: updatedQuestions.map((q, i) => ({ ...q, order_index: i })),
        };
      });

      return { sections: newSections, activeFieldId: newField.id };
    }),

    moveField: (fieldId: string, targetSectionId: string, newIndex: number) => set((state: BuilderState) => {
      // Find the moving field and remove it from its current position
      let movedField: IQuestion | undefined;
      const strippedSections = state.sections.map((section) => {
        const found = section.questions.find((q) => q.id === fieldId);
        if (found) movedField = found;
        return {
          ...section,
          questions: section.questions.filter((q) => q.id !== fieldId),
        };
      });

      if (!movedField) return {};

      // Insert it at the new position
      const finalSections = strippedSections.map((section) => {
        if (section.id !== targetSectionId) return section;
        const updatedQuestions = [...section.questions];
        updatedQuestions.splice(newIndex, 0, movedField!);
        return {
          ...section,
          questions: updatedQuestions.map((q, i) => ({ ...q, order_index: i })),
        };
      });

      return { sections: finalSections };
    }),

    moveSection: (sectionId: string, newIndex: number) => set((state: BuilderState) => {
      const activeIndex = state.sections.findIndex((s) => s.id === sectionId);
      if (activeIndex === -1) return {};

      const newSections = [...state.sections];
      const [movedSection] = newSections.splice(activeIndex, 1);
      newSections.splice(newIndex, 0, movedSection);

      return {
        sections: newSections.map((s, i) => ({ ...s, order_index: i })),
      };
    }),

    // Interaction Actions
    setActiveField: (fieldId) => set({ activeFieldId: fieldId }),
    setActiveSection: (sectionId) => set({ activeSectionId: sectionId }),
    setIsDragging: (isDragging) => set({ isDragging }),
  }))
);
