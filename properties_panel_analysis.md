<!-- markdownlint-disable -->

# Deep-Dive Properties Panel Analysis: Properties, Conditions, and Gaps

This document provides a highly granular, property-by-property audit of the **Properties Panel Column (Right Column)** in the production Form Builder workspace (`/home/ravi/workspace/frontend`).

---

## 1. Overview of Properties Panels

The Right Column acts as the configuration hub for whatever element is currently selected on the canvas. There are four distinct panels:

1. **FormPropertiesWidget** (`form_properties_widget.dart`): Configures form-wide preferences, theme styling, submission actions, access restrictions, and metadata.
2. **SectionPropertiesWidget** (`section_properties_widget.dart`): Configures section groupings, repeating layouts, styles, conditional rules, visibility, tracking telemetry, and options for individual sections.
3. **FieldPropertiesWidget** (`field_properties_widget.dart`): Configures question-level properties (labels, placeholder keys, types, validations, styles, lookups, and dependencies).
4. **BulkQuestionPropertiesWidget** (`bulk_question_properties_widget.dart`): Coordinates simultaneous configuration of multiple selected fields (e.g., bulk requirement settings, type conversion, hidden status overrides).

---

## 2. Properties Created Dynamically Due to Fields (Schema & Canvas Context)

These are properties that do not exist statically, but are dynamically generated and populated depending on:
1. **The selected field's data type schema** (fetched from backend `/builder-metadata`).
2. **The current fields and options layout present on the canvas** (queried from active FormBuilder state).

### A. Dynamic Schema-Driven Validation Properties (`DynamicPropertiesPanel`)
Depending on the field's `fieldType` grouping, different validation inputs are dynamically created and rendered on the fly:

| Field Group | Dynamically Created Property | Input UI Control | Model Variable Binding |
| :--- | :--- | :--- | :--- |
| **`input` / `textarea`** | Minimum Character Length | `Slider` (0 to 100) | `validation['min_length']` |
| | Maximum Character Length | `Slider` (0 to 1000) | `validation['max_length']` |
| | Regex Validation Preset | `Dropdown` (Email, URL, Integer, Decimal, etc.) | Matches preset expression strings |
| | Custom Regex Matcher | `TextFormField` | `validation['regex']` |
| **`number`** | Minimum Value | `Slider` (0 to 100) | `validation['min_value']` |
| | Maximum Value | `Slider` (0 to 100) | `validation['max_value']` |
| | Integer Only Constraint | `Switch` | `validation['integer_only']` |
| **`date`** | Minimum Date Constraint | Date Picker Button + Label | `validation['min_date']` |
| | Maximum Date Constraint | Date Picker Button + Label | `validation['max_date']` |
| **`file`** | Maximum File Upload Size | `Slider` (0.1 to 100MB) | `validation['max_file_size']` |
| | Maximum File Count Limit | `Slider` (1 to 10) | `validation['max_file_count']` |
| | Allowed File Extensions | `FilterChip` wrap list (PDF, PNG, JPG, DOCX, XLS, etc.) | `validation['allowed_extensions']` |
| **Selection Choices** | Minimum Option Choice Selections | `Slider` | `validation['min_select_count']` |
| | Maximum Option Choice Selections | `Slider` | `validation['max_select_count']` |

### B. Contextual Logic Dependencies (`FieldLogicSettings`)
Rules created in the Logic Tab are built dynamically from properties of *other* fields on the canvas:
* **Trigger Dependency Selector**: Populated with a list of labels from all other fields present on the canvas.
* **Option Comparator Dropdown**: Dynamically queries the configured options of the selected dependency field (e.g. if the dependency is a dropdown, it generates inputs for each option value in that dropdown).
* **Logical Actions**:
  * **Jump Section Targets**: Populated dynamically with all section IDs currently on the canvas.
  * **Jump Question Targets**: Populated dynamically with all question IDs currently on the canvas.

---

## 3. Form Properties Panel (`FormPropertiesWidget`)

### A. General Tab
* **Form Title** (`form.title`):
  * **Type**: `TextFormField`
  * **Description**: Sets the main name/title of the form. Fully localized based on the editing language.
  * **Problems/Gaps**: Rebuilding the canvas on every keystroke (`onChanged`) causes severe typing lag in forms with complex trees.
* **Description** (`form.description`):
  * **Type**: `TextFormField` (Multiline)
  * **Description**: Detailed description/instructions positioned below the header.
  * **Problems/Gaps**: Lacks rich text markdown support.
* **Form Layout UI Type** (`form.uiType`):
  * **Type**: `DropdownButtonFormField`
  * **Description**: Toggles the rendering mode of the form canvas (e.g., `'standard'` or `'wizard'`).

### B. Layout Tab
* **Layout Mode** (`form.style['layout']`):
  * **Type**: `DropdownButtonFormField`
  * **Description**: Columns arrangement for section grid wrappers (`'singleColumn'`, `'twoColumns'`, `'threeColumns'`).

### C. Style Tab
* **Quick Palette** & **Custom Hex Background** (`form.style['backgroundColor']`):
  * **Type**: Swatches & `_StatefulColorPicker`
  * **Description**: Background color options.
  * **Problems/Gaps**: Invalid Hex strings typed manually (e.g. `#z12`) cause runtime color parsing exceptions.
* **Logo URL**, **Cover Image URL**, **Favicon URL**:
  * **Type**: `TextFormField`
  * **Description**: Path links for page style assets.
  * **Problems/Gaps**: No verification checks for broken images/URLs.

### D. Logic Tab
* **Workflows List** (`form.workflows`):
  * **Type**: Configurable route maps
  * **Description**: Branching configurations between form segments.

### E. Access / Privacy Tab
* **Access Mode** (`form.accessPolicy.accessMode`):
  * **Type**: `RadioGroup` ('public' vs 'private')
  * **Description**: Changes access controls.
* **Require Login** (`form.accessPolicy.requireLogin`):
  * **Condition**: Visible only when **Access Mode** is `'private'`.
  * **Description**: Switch forcing users to sign in.
* **Allowed Users / Roles / Groups**:
  * **Condition**: Visible only when **Access Mode** is `'private'`.
  * **Description**: CSV entries (`allowedUserIds`, `allowedRoles`, `allowedGroupIds`).
* **Access Message** (`form.accessPolicy.privateAccessMessage`):
  * **Condition**: Visible only when **Access Mode** is `'private'`.
  * **Description**: Custom warning shown when access is denied.
* **Password protected** (`passwordProtected`):
  * **Type**: `Switch`
  * **Description**: Password-locks form pages.
* **Password & Password Confirmation**:
  * **Condition**: Visible only when **Password protected** is enabled.
  * **Description**: Input verification boxes.
  * **Problems/Gaps**: Fails to block save actions even when confirm-password validations fail.
* **Password Hint**:
  * **Condition**: Visible only when **Password protected** is enabled.
* **Invite only** (`inviteOnly`):
  * **Type**: `Switch`
  * **Description**: Toggles user whitelists.
* **Invitee email / id** & **Invite expiry (ISO date)**:
  * **Condition**: Visible only when **Invite only** is enabled.
  * **Description**: Whitelist target mapping.
  * **Problems/Gaps**: Date parser throws exception on invalid manually typed formats.

---

## 4. Section Properties Panel (`SectionPropertiesWidget`)

### A. General Tab
* **Section Title** & **Description**:
  * **Type**: `TextFormField`
* **Section Help Text** (`help_text`):
  * **Type**: `TextFormField`
  * **Description**: Supplementary text hints displayed next to section boundaries.
* **Section Order** (`order`):
  * **Type**: `TextFormField` (Integer)
  * **Description**: Sort sequence order of the section.
* **Section ID / Slug** (`id`):
  * **Type**: `TextFormField`
  * **Description**: Unique identifier slug.
  * **Problems/Gaps**: Changing the ID does not update rules referencing it, breaking logic trees immediately.
* **Tags** (`tags`):
  * **Type**: `InputChip` list + add input field.

### B. Layout Tab
* **Layout Mode**:
  * **Type**: `Dropdown` ('standard', 'centered', 'masonry', 'tabs')
* **Grid Columns Count**:
  * **Condition**: Visible only if layout is set to `'masonry'`.
  * **Description**: Number of column divisions.
  * **Problems/Gaps**: Values <= 0 crash layout calculations.
* **Is Hidden Toggle** (`isHidden`):
  * **Type**: `Switch`
* **Is Repeatable Toggle** (`isRepeatable`):
  * **Type**: `Switch`
* **Repeat Min / Repeat Max**:
  * **Condition**: Visible only when **Is Repeatable** is enabled.
  * **Problems/Gaps**: No logic enforces `repeatMin <= repeatMax`.

### C. Style Tab
* **Section Background Color** & **Header Background Color**:
  * **Type**: `_StatefulColorPicker`
* **Padding**, **Border Width**, **Border Radius**:
  * **Type**: `TextFormField` (Numeric)
  * **Description**: Card layout overrides.

### D. Logic / Visibility Tabs
* **Section Navigation Logic** (`nextSectionAction`):
  * **Type**: `Dropdown` (continue, jump, submit)
* **Jump Section Target ID** (`jumpSectionTargetId`):
  * **Condition**: Visible only if navigation action is `'jump'`.
  * **Description**: Branching target.
* **Section Visibility Rules** (`visibilityRuleType`):
  * **Type**: `Dropdown` (always, conditional) + rule builder condition button.

### E. Extra Settings Tabs (Behavior / A11y / Analytics / Advanced)
* **Behavior Settings**:
  * **Sticky header**, **Collapsible section**, **Start collapsed**, **Required to continue**, **Prevent skipping**, **Allow back navigation**, **Allow edit after submit**.
* **A11y Settings**:
  * **Accessible label**, **Tooltip text**.
* **Analytics Settings**:
  * **Track section view**, **Track completion**, **Track dwell time**, **Analytics event name**.
* **Advanced Settings**:
  * **Width mode** (full, contained, custom), **Max width** (0 to 1200), **Min width** (0 to 800), **Field gap** (0 to 64), **Vertical padding** (0 to 120), **Horizontal padding** (0 to 120), **Template / preset name**, **Owner / reviewer**, **Author notes**, **Workflow action**, **Permissions** chips, **Section anchor**.

---

## 5. Field Properties Panel (`FieldPropertiesWidget`)

### A. General Tab
* **Field Type Dropdown**:
  * **Description**: Switches types. Compatible switches preserve configurations.
* **Label**, **Placeholder**, **Helper Text**:
  * **Condition**: Placeholder is hidden for raters, sliders, and checkboxes.
* **Default Value**:
  * **Condition**: Hidden for rating fields, upload actions, and structural elements.
  * **Problems/Gaps**: No validation ensures type-matching of defaults (e.g. text defaults typed in number fields).
* **Divider Text**:
  * **Condition**: Visible only when type is `'divider'`.

### B. Validation Tab
* **Is Required**:
  * **Type**: `Switch`
* **Min / Max Length** and **Min / Max Values**:
  * **Condition**: Shown conditionally depending on whether field is Text or Number.
  * **Problems/Gaps**: No boundary checks enforce `min <= max`.
* **SENSITIVE DATA (FLE/PII) Switch**:
  * **Problems/Gaps**: **CRITICAL LOGIC BUG FOUND**. The switch reads its value from `widget.question.isReadOnly` but writes updates to `ui['sensitive']` (line 364 of `dynamic_properties_panel.dart`). This disconnect causes the toggle state to reflect a completely different setting than the one it changes, leading to stale and broken configuration UI states.

### C. Sizing & Width Tab
* **Width Preset** (`widthPreset`):
  * **Type**: `Dropdown`
* **Visual Column Span** (`span`):
  * **Type**: Span blocks (1/4 to 4/4) selection row.
* **Custom Height (Optional)**:
  * **Type**: Slider (0 to 500)
* **Label Position**:
  * **Condition**: Hidden for dividers, images, and signature field types.
* **Label Column Width**:
  * **Condition**: Only visible if label position is `'left'`.
  * **Type**: Slider (50 to 300)
* **Vertical Bottom Margin** (0 to 64) & **Internal Padding** (0 to 48)

### D. Specific Settings Tab (`FieldSpecificSettings`)
* **Use Upload (vs URL)** & **Image URL / Upload selector**:
  * **Condition**: Visible for Image types.
* **Rating Settings** (Star levels, icons, colors):
  * **Condition**: Rating types.
* **Slider Settings** (Min range, max range, steps):
  * **Condition**: Slider types.
* **Matrix Settings** (Matrix columns and rows setup):
  * **Condition**: Matrix choices.
* **Date Range Limits** (Min / Max date range picker):
  * **Condition**: Date types.
* **Otp Settings** (Length of OTP, resend duration):
  * **Condition**: OTP types.
* **Toggle Settings** (Custom active/inactive labels):
  * **Condition**: Toggle types.

### E. Style Tab
* **Border Input Style** (outlined, rounded, underlined, filled, glass, minimalist)
* **Text Color** & **Border Color**
* **Custom Height Size** (Slider 32 to 120)
* **Prefix / Suffix Icons** (text input + quick icon swatch selections)

### F. Logic Tab
* **Trigger Condition Skip Policies**
  * **Type**: Skip jumps matching value patterns.

---

## 6. Bulk Properties Panel (`BulkQuestionPropertiesWidget`)

* **Change Type Dropdown**:
  * **Condition**: Only visible if all selected questions are structurally compatible (e.g. multiple choice, checklists).
* **Required / Hidden / Read Only / Repeatable** switches:
  * **Type**: Batch state overrides.
* **Minimum Repeats**:
  * **Condition**: Visible only when **Repeatable** is toggled `true`.


---

## 7. Data Flow, Property Bindings, and Dead Code Audit

### Summary of Major Gaps & Disconnects Fixed

1. **Orphaned Form Name & Description Inputs (Fixed)**: In `properties_panel.dart`'s `_FormPropertiesEditor`, both the Form Name (`_nameController`) and Description (`_descController`) had empty `onChanged` callbacks, causing updates to be silently lost. We added the `updateMetadata` method to the Riverpod `FormBuilderNotifier` and wired it up to these input fields to correctly persist changes.
2. **Hidden/Unconfigurable Model Fields**: Multiple properties on `FormSection` (like `icon`, `allowPartialSave`, and `minQuestionsRequired`) are defined, serialized, and handled by notifiers, but have no configuration controls in the properties panel UI.
3. **AppColors Compile Error (Fixed)**: A compile error in `property_panel.dart` caused by referencing the non-existent `AppColors.onSurfaceVariant` has been corrected to use `AppColors.textMuted`.

### Audit Reference & Dependency Matrix

| File Path & UI Component | UI Property Field | Value Source (Origin) | Update Flow (Action & State Mutation) | Gaps / Dead Code / Persistence Issues |
| :--- | :--- | :--- | :--- | :--- |
| **[properties_panel.dart](file:///home/ravi/workspace/form-builder/frontend/lib/features/form_builder/presentation/widgets/properties_panel.dart)**<br>`_FormPropertiesEditor` | Form Name | `state.name` | `_nameController.text` | **[CRITICAL] Orphaned Input (Fixed)**: `onChanged` callback was empty; name updates are now properly saved to the provider state via `updateMetadata`. |
| | Description | `state.description` | `_descController.text` | **[CRITICAL] Orphaned Input (Fixed)**: `onChanged` callback was empty; description updates are now properly saved via `updateMetadata`. |
| | Primary Color (Hex) | `state.style.primaryColor` | `_primaryColorController` -> `updateStyle(primaryColor: val)` | None. Fully bound. |
| | Background Color (Hex) | `state.style.backgroundColor` | `_bgColorController` -> `updateStyle(backgroundColor: val)` | None. Fully bound. |
| | Font Family | `state.style.fontFamily` | `_fontFamilyController` -> `updateStyle(fontFamily: val)` | None. Fully bound. |
| | Border Radius | `state.style.borderRadius` | `Slider` -> `updateStyle(borderRadius: val)` | None. Fully bound. |
| | Custom CSS (Advanced) | `state.style.customCss` | `_cssController` -> `updateStyle(customCss: val)` | None. Fully bound. |
| | Style Presets | `state.style.themeId` | `_PresetCard.onTap` -> `updateStyle(...)` | Note: `inputStyle` is set by presets but has no manual override control in the "Advanced" UI tab. |
| | Email Alerts Toggle & Fields | `state.notifications.*` | `SwitchListTile` / `TextField` -> `updateNotifications(...)` | None. Fully bound. |
| | Webhook Delivery Toggle & Fields | `state.notifications.*` | `SwitchListTile` / `TextField` -> `updateNotifications(...)` | None. Fully bound. |
| | Platform Alerts (Internal Users/Teams) | `state.notifications.*` | `SwitchListTile` / `TextField` -> `updateNotifications(...)` | None. Fully bound. |
| | Analytics Collection Toggle & Event Dropdowns | `state.analytics.*` | `SwitchListTile` / `Dropdown` -> `updateAnalytics(...)` | None. Fully bound. |
| **[properties_panel.dart](file:///home/ravi/workspace/form-builder/frontend/lib/features/form_builder/presentation/widgets/properties_panel.dart)**<br>`_SectionEditor` | Section Title | `section.title` | `titleController` -> `updateSection(title: val)` | None. Fully bound. |
| | Subtitle | `section.subtitle` | `subtitleController` -> `updateSection(subtitle: val)` | None. Fully bound. |
| | Description | `section.description` | `descriptionController` -> `updateSection(description: val)` | None. Fully bound. |
| | Internal Note | `section.internalNote` | `internalNoteController` -> `updateSection(internalNote: val)` | None. Fully bound. |
| | Tags | `section.tags` | `tagsController` -> `updateSection(tags: parsedList)` | None. Fully bound. |
| | Section Icon | `section.icon` | *None* | **Dead Reference**: Exists in the `FormSection` model, but there is no UI editor element to modify this property. |
| | Parent Section | `section.parentSectionId` | `DropdownButtonFormField` -> `updateSection(parentSectionId: val)` | None. Fully bound. |
| | Allow Partial Save | `section.allowPartialSave` | *None* | **Dead Reference / Display-Only**: Rendered as a status badge chip `_InfoChip(label: 'partial save')` if true, but cannot be modified in the UI. |
| | Min Questions Required | `section.minQuestionsRequired` | *None* | **Dead Reference**: Defined in model, but missing any input controls in the properties tabs. |
| | Other Section Settings (Repeatable, Collapsible, Navigation, Visibility, Skip logic, Colors, Header Image, Owner, Notes, visibleToRoles, editableByRoles) | `section.*` | Various switches, inputs, dropdowns -> `updateSection(...)` | None. Fully bound. |
| **[properties_panel.dart](file:///home/ravi/workspace/form-builder/frontend/lib/features/form_builder/presentation/widgets/properties_panel.dart)**<br>`_SubSectionEditor` | Sub-section Title | `subSection.title` | `titleController` -> `updateSubSection(title: val)` | None. Fully bound. |
| | Repeatable Sub-section | `subSection.repeatable` | `SwitchListTile` -> `updateSubSection(repeatable: val)` | None. Fully bound. |
| **[properties_panel.dart](file:///home/ravi/workspace/form-builder/frontend/lib/features/form_builder/presentation/widgets/properties_panel.dart)**<br>`_QuestionEditor` | Field Label | `question.label` | `labelController` -> `updateQuestion(label: val)` | None. Fully bound. |
| | Description / Hint | `question.description` | `descriptionController` -> `updateQuestion(description: val)` | None. Fully bound. |
| | Required Toggle | `question.required` | `SwitchListTile` -> `updateQuestion(required: val)` | None. Fully bound. |
| | Placeholder Hint | `question.properties['placeholder']` | `placeholderController` -> `updateQuestion(properties: val)` | None. Fully bound. |
| | Slug Key | `question.properties['slug']` | `slugController` -> `updateQuestion(properties: val)` | None. Fully bound. |
| | Card Elevation | `question.properties['elevation']` | `elevationController` -> `updateQuestion(properties: val)` | None. Fully bound. |
| | FLE / PII Encryption | `question.properties['fle_pii']` | `SwitchListTile` -> `updateQuestion(properties: val)` | None. Fully bound. |
| | Options List (Dropdown/Multi-select) | `question.properties['options']` | `optionsController` -> `updateQuestion(properties: val)` | None. Fully bound. |
| **[property_panel.dart](file:///home/ravi/workspace/form-builder/frontend/lib/features/dashboard_builder/properties/property_panel.dart)**<br>`PropertyPanel` | Widget Title & Show Header | `w.properties['title']`, `w.properties['show_title']` | `TextFormField` / `SwitchListTile` -> `updateWidgetProperties(...)` | None. Fully bound. |
| | Lock Position | `w.isLocked` | `SwitchListTile` -> `toggleLockWidget(...)` | None. Fully bound. |
| | Geometry Bounds (X, Y, Width, Height) | `w.position.*`, `w.size.*` | `TextFormField` -> `moveWidget(...)` / `resizeWidget(...)` | None. Fully bound. |
| | Layering (Bring Front, Send Back) | `w.zIndex` | `FilledButton` / `OutlinedButton` -> `bringToFront(...)` / `sendToBack(...)` | None. Fully bound. |
| | Style Properties (Colors, radius, padding) | `w.properties['background_color']`, `w.properties['border_color']`, `w.properties['border_radius']`, `w.properties['padding']` | `TextFormField` -> `updateWidgetProperties(...)` | None. Fully bound. |
| | KPI/Filter Configs | `w.properties['value_format']`, `w.properties['prefix']`, `w.properties['suffix']`, `w.properties['filter_type']`, `w.properties['static_options']` | `DropdownButtonFormField` / `TextFormField` -> `updateWidgetProperties(...)` | None. Fully bound. |