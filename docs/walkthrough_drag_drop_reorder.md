# Drag and Drop Reordering in Form Builder

## Overview

We have implemented drag-and-drop functionality for both Sections and Questions within the Form Builder. This allows users to easily rearrange the structure of their forms.

## Features

### Reordering Sections

- **Drag Handle**: Sections can be dragged using the drag handle or by clicking and dragging the section header area.
- **Visual Feedback**: A blue line indicator appears to show where the section will be placed when dropped.
- **Implementation**: Uses `Draggable<SectionDragData>` and `DragTarget<SectionDragData>`.

### Reordering Questions

- **Drag Handle**: Individual questions have a drag handle (grip icon) and can be dragged.
- **Move Between Sections**: Questions can be moved *within* a section or *between* different sections.
- **Visual Feedback**: A blue line indicator shows the drop position.
- **Implementation**: Uses `Draggable<QuestionDragData>` and `DragTarget<QuestionDragData>`.

## Usage

1. **To Reorder Sections**: Click and drag a section to a new position.
2. **To Reorder Questions**: Click and drag a question field to a new position. You can drop it in the same section or move it to another section.
3. **To Add New Questions**: Use the sidebar to click or drag new question types into a section.

## Code Changes

- **`FormBuilderController`**: Added `reorderSections`, `reorderQuestions`, `moveQuestion`, and `duplicateQuestion` methods.
- **`FormCanvasWidget`**: Updated to use `Draggable` and `DragTarget` widgets, wrapping sections and questions.
