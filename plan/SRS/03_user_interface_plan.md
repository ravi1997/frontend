# 03. User Interface Plan

## 1. Design Concept
- **Theme**: Premium Dark/Light mode support.
- **Vibe**: Clean, modern, and data-focused.
- **Interactions**: Subtle micro-animations using `Lottie` or `Rive`.

## 2. Screen List
1.  **Splash Screen**: App branding and initial loading.
2.  **Auth Screens**:
    - Login (Email/Password, Social Auth).
    - Sign Up.
    - Forgot Password.
3.  **Home / Dashboard**:
    - Overview of active forms.
    - Quick actions menu.
4.  **Form Builder**:
    - Canvas area for fields.
    - Toolbox for field selection.
    - Property editor for each field.
5.  **Form List**: Searchable list of all created forms.
6.  **Response Viewer**:
    - Summary view.
    - Detail view for individual submissions.
7.  **Settings**:
    - Profile management.
    - Theme selection.
    - Sync settings.

## 3. UI Components (Flutter Widgets)
- `ListView.builder` for efficient scrolling of large forms.
- `CustomScrollView` with slivers for beautiful sticky headers and effects.
- `Hero` animations for screen transitions.
- `GoogleFonts` for modern typography (e.g., *Inter* or *Outfit*).
