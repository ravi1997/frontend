# Comprehensive Unsqueezed Form Builder Component Tree

This document outlines the complete widget hierarchy of the Form Builder feature in your production application (`frontend/lib/modules/forms/pages/form_builder_page.dart`). 

All helper functions, custom layout widgets, and compound widgets (including those built by `PropertyBuilderUtils` or custom classes like `_VersionBadge`, `_SectionMetaChip`, etc.) are fully expanded to show their raw nesting of basic Flutter-defined components.

---

## 1. Helper Widget Expansion Blueprints

To ensure complete accuracy, here is how the utility functions from `PropertyBuilderUtils` expand:

### Blueprint A: `PropertyBuilderUtils.buildSwitch`
```text
▼ [Row]
  ├─▼ [Expanded]
  │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
  │         ├─ [Text] (label)
  │         ├─ [SizedBox] (height: DesignTokens.spaceXS) [Conditional: if description != null]
  │         └─ [Text] (description) [Conditional: if description != null]
  ├─ [SizedBox] (width: DesignTokens.spaceS)
  └─ [Switch] (value: value, onChanged: onChanged, activeThumbColor: AppColors.primary)
```

### Blueprint B: `PropertyBuilderUtils.buildTextField`
```text
▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
  ├─ [Text] (label)
  ├─ [SizedBox] (height: DesignTokens.spaceS)
  └─▼ [Focus]
       └─ [TextFormField] (controller: controller, keyboardType: keyboardType, decoration: InputDecoration(...))
```

### Blueprint C: `PropertyBuilderUtils.buildNumberSlider`
```text
▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
  ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
  │    ├─ [Text] (label)
  │    └─ [Text] (value string)
  ├─ [Slider] (value: value, min: min, max: max, activeColor: AppColors.brandBlue)
```

### Blueprint D: `PropertyBuilderUtils.buildDropdown`
```text
▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
  ├─ [Text] (label)
  ├─ [SizedBox] (height: DesignTokens.spaceS)
  └─▼ [Container] (decoration: BoxDecoration(color: AppColors.builderElement, borderRadius: ...))
       └─▼ [DropdownButtonHideUnderline]
            └─ [DropdownButton<T>] (value: value, items: items, onChanged: onChanged)
```

### Blueprint E: `PropertyBuilderUtils.buildColorPicker` (`_StatefulColorPicker`)
```text
▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
  ├─ [Text] (label)
  ├─ [SizedBox] (height: DesignTokens.spaceS)
  └─▼ [Row]
       ├─▼ [Expanded]
       │    └─ [TextFormField] (Hex input field)
       ├─ [SizedBox] (width: DesignTokens.spaceS)
       └─▼ [GestureDetector] (onTap: open color picker dialog)
            └─ [Container] (displays selected color block)
```

---

## 2. Complete Leaf-Level Widget Tree

```text
▼ [FormBuilderPage] (form_builder_page.dart)
  ▼ [Scaffold]
    ▼ [Column]
      │
      ├─► [FormBuilderTopBar] (form_builder_top_bar.dart)
      │    ▼ [Container] (decoration: BoxDecoration(color: AppColors.builderSidebar))
      │      ▼ [Row]
      │        ├─▼ [IconButton]
      │        │    └─ [Icon] (Icons.arrow_back)
      │        ├─ [SizedBox] (width: DesignTokens.spaceS)
      │        ├─▼ [Expanded]
      │        │    ▼ [SingleChildScrollView] (scrollDirection: Axis.horizontal)
      │        │      ▼ [Row]
      │        │        ├─▼ [InkWell] (onTap: selectForm)
      │        │        │    └─ [Text] (formTitle)
      │        │        ├─ [SizedBox] (width: DesignTokens.spaceM)
      │        │        ├─▼ [_VersionBadge]
      │        │        │    └─ [Container] (decoration: BoxDecoration(color: AppColors.primarySoft))
      │        │        │         └─ [Padding] (padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
      │        │        │              └─ [Text] ("v" + version)
      │        │        ├─ [SizedBox] (width: DesignTokens.spaceS)
      │        │        ├─▼ [_EditingBadge]
      │        │        │    └─ [Container] (decoration: BoxDecoration(color: AppColors.brandBlueSoft))
      │        │        │         └─ [Padding] (padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4))
      │        │        │              └─ [Text] ("Editing")
      │        │        ├─ [SizedBox] (width: DesignTokens.spaceS)
      │        │        ├─▼ [_EditingLocaleSwitcher]
      │        │        │    └─ [DropdownButtonHideUnderline]
      │        │        │         └─ [DropdownButton<String>] (value: locale)
      │        │        │              ├─ [DropdownMenuItem] -> [Text] ("English")
      │        │        │              ├─ [DropdownMenuItem] -> [Text] ("Spanish")
      │        │        │              └─ [DropdownMenuItem] -> [Text] ("French")
      │        │        └─▼ [_GitBranchSelector]
      │        │             └─ [DropdownButtonHideUnderline]
      │        │                  └─ [DropdownButton<String>] (value: branch)
      │        │                       └─ [DropdownMenuItem] -> [Text] (branch name)
      │        ├─▼ [_TopBarActionButton] (Merge & Sync)
      │        │    └─▼ [TextButton.icon]
      │        │         ├─ [FaIcon] (FontAwesomeIcons.codeBranch)
      │        │         └─ [Text] ("Merge & Sync")
      │        ├─ [SizedBox] (width: DesignTokens.spaceS)
      │        ├─▼ [_TopBarActionButton] (AI Assistant)
      │        │    └─▼ [TextButton.icon]
      │        │         ├─ [FaIcon] (FontAwesomeIcons.wandMagicSparkles)
      │        │         └─ [Text] ("AI Assistant")
      │        ├─ [SizedBox] (width: DesignTokens.spaceS)
      │        ├─▼ [_TopBarActionButton] (Preview)
      │        │    └─▼ [TextButton.icon]
      │        │         ├─ [FaIcon] (FontAwesomeIcons.eye)
      │        │         └─ [Text] ("Preview")
      │        └─▼ [_TopBarActionButton] (Publish)
      │             └─▼ [FilledButton.icon]
      │                  ├─ [FaIcon] (FontAwesomeIcons.cloudArrowUp)
      │                  └─ [Text] ("Publish")
      │
      └─▼ [Expanded] (Main Workspace Panel - Row Layout if screenWidth >= 1100)
           ▼ [Row]
             │
             ├─► [FieldLibraryWidget] (field_library_widget.dart)
             │    ▼ [DefaultTabController] (length: 3)
             │         ▼ [Container] (width: _leftPanelWidth, decoration: BoxDecoration(color: AppColors.builderSidebar))
             │              ▼ [Column] (crossAxisAlignment: CrossAxisAlignment.stretch)
             │                   ├─▼ [Container] (Sticky Header Section)
             │                   │    ▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
             │                   │         ├─▼ [Row]
             │                   │         │    ├─ [FaIcon] (FontAwesomeIcons.cubes)
             │                   │         │    ├─ [SizedBox] (width: 8)
             │                   │         │    └─ [Text] ("Elements")
             │                   │         ├─ [SizedBox] (height: DesignTokens.spaceM)
             │                   │         └─ [TextField] (Search controller: _searchController)
             │                   ├─▼ [TabBar]
             │                   │    ├─ [Tab] ("Standard")
             │                   │    ├─ [Tab] ("Custom Fields")
             │                   │    └─ [Tab] ("Saved Templates")
             │                   └─▼ [Expanded]
             │                        └─▼ [TabBarView]
             │                             ├─▼ [Standard Tab View (ListView.builder)]
             │                             │    ├─▼ [Draggable<QuestionType>]
             │                             │    │    └─▼ [Material]
             │                             │    │         └─▼ [InkWell]
             │                             │    │              ▼ [Row]
             │                             │    │                ├─ [Icon] (question icon)
             │                             │    │                ├─ [SizedBox] (width: 8)
             │                             │    │                ├─ [Text] (question type label)
             │                             │    │                ├─ [Spacer]
             │                             │    │                └─ [Icon] (Icons.add)
             │                             │    └─ ... (repeat for other categories)
             │                             ├─▼ [Custom Fields Tab View (ListView.builder)]
             │                             │    └─▼ [Draggable<CustomFieldTemplate>]
             │                             │         └─▼ [Material]
             │                             │              └─▼ [InkWell]
             │                             │                   ▼ [Row]
             │                             │                     ├─ [Icon] (Icons.star_border)
             │                             │                     ├─ [SizedBox] (width: 8)
             │                             │                     ├─ [Text] (template name)
             │                             │                     ├─ [Spacer]
             │                             │                     └─ [Icon] (Icons.add)
             │                             └─▼ [Saved Templates Tab View (ListView.builder)]
             │                                  └─▼ [Draggable<CustomFieldTemplate>]
             │                                       └─▼ [Material]
             │                                            └─▼ [InkWell]
             │                                                 ▼ [Row]
             │                                                   ├─ [Icon] (Icons.star)
             │                                                   ├─ [SizedBox] (width: 8)
             │                                                   ├─ [Text] (template name)
             │                                                   ├─ [Spacer]
             │                                                   └─ [Icon] (Icons.add)
             │
             ├─► [GestureDetector] (Left Resize Spacing Divider)
             │    └─ [MouseRegion] (cursor: SystemMouseCursors.resizeColumn)
             │         └─ [Container] (width: 1, color: AppColors.builderBorder)
             │
             ├─► [Expanded] (Center Workspace Area)
             │    └─▼ [FormCanvasWidget] (form_canvas_widget.dart)
             │         ▼ [DragTarget<Object>]
             │           ▼ [GestureDetector] (onTap: clears selection)
             │             ▼ [Container] (color: canvasColor)
             │               ▼ [SingleChildScrollView]
             │                 ▼ [Center]
             │                   ▼ [ConstrainedBox] (constraints: BoxConstraints(maxWidth: formStyle.maxWidth))
             │                     ▼ [Column]
             │                       ├─▼ [InkWell] (onTap: selectForm)
             │                       │    └─▼ [Container] (Form Title card)
             │                       │         └─ [Text] (state.form.title)
             │                       ├─ [SizedBox] (height: DesignTokens.spaceL)
             │                       │
             │                       ├─► [IF SECTIONS LIST IS EMPTY]
             │                       │    └─▼ [CustomPaint] (Empty space dashed border)
             │                       │         ▼ [Column]
             │                       │              ├─ [FaIcon] (FontAwesomeIcons.layerGroup)
             │                       │              ├─ [SizedBox]
             │                       │              ├─ [Text] ("Your form is empty")
             │                       │              ├─ [SizedBox]
             │                       │              └─ [Text] ("Start by adding a section")
             │                       │
             │                       └─► [IF SECTIONS LIST IS NOT EMPTY]
             │                            ▼ [LayoutBuilder]
             │                              ▼ [Wrap]
             │                                   └─▼ [DragTarget<SectionDragData>]
             │                                        ▼ [Draggable<SectionDragData>]
             │                                             └─▼ [SectionWidget] (section_widget.dart)
             │                                                  ▼ [DragTarget<Object>]
             │                                                    ▼ [Container] (BoxDecoration styled)
             │                                                      ▼ [Column]
             │                                                        │
             │                                                        ├─▼ [Section Header (InkWell)]
             │                                                        │    ▼ [Container] (background: headerBg)
             │                                                        │      ▼ [Column]
             │                                                        │        ├─▼ [Row]
             │                                                        │        │    ├─ [Icon] (Icons.drag_indicator)
             │                                                        │        │    ├─ [SizedBox] (width: 8)
             │                                                        │        │    ├─▼ [Expanded]
             │                                                        │        │    │    └─ [Text] (section.title)
             │                                                        │        │    ├─ [IconButton] (Icons.delete_outline)
             │                                                        │        │    └─▼ [PopupMenuButton<String>]
             │                                                        │        │         ├─ [PopupMenuItem] -> Row (Icon + Text "Duplicate")
             │                                                        │        │         ├─ [PopupMenuItem] -> Row (Icon + Text "Add Sub-section")
             │                                                        │        │         ├─ [PopupMenuItem] -> Row (Icon + Text "Move Up")
             │                                                        │        │         └─ [PopupMenuItem] -> Row (Icon + Text "Move Down")
             │                                                        │        └─▼ [Wrap] (spacing: 8, runSpacing: 8)
             │                                                        │             ├─▼ [_SectionMetaChip]
             │                                                        │             │    └─ [Container]
             │                                                        │             │         ▼ [Row]
             │                                                        │             │           ├─ [Icon] (Icons.view_agenda_outlined)
             │                                                        │             │           ├─ [SizedBox] (width: 4)
             │                                                        │             │           └─ [Text] (layout type name)
             │                                                        │             ├─▼ [_SectionMetaChip]
             │                                                        │             │    └─ [Container]
             │                                                        │             │         ▼ [Row]
             │                                                        │             │           ├─ [Icon] (Icons.format_list_bulleted)
             │                                                        │             │           ├─ [SizedBox] (width: 4)
             │                                                        │             │           └─ [Text] (question count)
             │                                                        │             └─▼ [_SectionMetaChip]
             │                                                        │                  └─ [Container]
             │                                                        │                       ▼ [Row]
             │                                                        │                         ├─ [Icon] (Icons.radio_button_checked)
             │                                                        │                         ├─ [SizedBox] (width: 4)
             │                                                        │                         └─ [Text] ("Selected")
             │                                                        │
             │                                                        ├─▼ [Questions List (Padding)]
             │                                                        │    ▼ [LayoutBuilder]
             │                                                        │      ▼ [Wrap]
             │                                                        │           └─▼ [DragTarget<QuestionDragData>]
             │                                                        │                ▼ [Draggable<QuestionDragData>]
             │                                                        │                     └─▼ [BuilderFieldWidget] (builder_field_widget.dart)
             │                                                        │                          ▼ [GestureDetector] (onTap: selectQuestion)
             │                                                        │                            ▼ [Container] (BoxDecoration)
             │                                                        │                              ▼ [Column]
             │                                                        │                                ├─▼ [Header Row]
             │                                                        │                                │    ├─ [Icon] (Icons.drag_indicator)
             │                                                        │                                │    ├─▼ [Container] (Badge background)
             │                                                        │                                │    │    └─ [Text] (question.type.toUpperCase)
             │                                                        │                                │    ├─ [Spacer]
             │                                                        │                                │    ├─ [IconButton] (Icons.copy)
             │                                                        │                                │    └─ [IconButton] (Icons.delete_outline)
             │                                                        │                                ├─ [RichText] (question.label + required asterisk '*')
             │                                                        │                                ├─ [Text] (helperText)
             │                                                        │                                └─▼ [Field Preview Panel] (_buildFieldPreview)
             │                                                        │                                     ├─► [QuestionType.shortText/number/email/date/time]
             │                                                        │                                     │    └─▼ [Container]
             │                                                        │                                     │         ▼ [Row]
             │                                                        │                                     │           ├─ [Text] (prefix icon)
             │                                                        │                                     │           ├─ [Expanded] -> [Text] (placeholder)
             │                                                        │                                     │           └─ [Text] (suffix icon)
             │                                                        │                                     ├─► [QuestionType.paragraph]
             │                                                        │                                     │    └─ [Container] -> [Text] ("Long answer text...")
             │                                                        │                                     ├─► [QuestionType.dropdown]
             │                                                        │                                     │    └─▼ [Container]
             │                                                        │                                     │         ▼ [Row]
             │                                                        │                                     │           ├─ [Text] ("Select an option")
             │                                                        │                                     │           ├─ [Spacer]
             │                                                        │                                     │           └─ [Icon] (Icons.arrow_drop_down)
             │                                                        │                                     ├─► [QuestionType.checkboxes]
             │                                                        │                                     │    └─▼ [Column]
             │                                                        │                                     │         └─▼ [Row]
             │                                                        │                                     │              ├─ [Container] (checkbox square)
             │                                                        │                                     │              ├─ [SizedBox]
             │                                                        │                                     │              └─ [Text] (option label)
             │                                                        │                                     ├─► [QuestionType.multipleChoice]
             │                                                        │                                     │    └─▼ [Column]
             │                                                        │                                     │         └─▼ [Row]
             │                                                        │                                     │              ├─ [Container] (radio circle)
             │                                                        │                                     │              ├─ [SizedBox]
             │                                                        │                                     │              └─ [Text] (option label)
             │                                                        │                                     └─► [QuestionType.attachment]
             │                                                        │                                          └─▼ [Container]
             │                                                        │                                               ▼ [Row]
             │                                                        │                                                 ├─ [Icon] (Icons.upload_file)
             │                                                        │                                                 ├─ [SizedBox]
             │                                                        │                                                 └─ [Text] ("Upload document / image")
             │                                                        │
             │                                                        └─▼ [Child Sections / Nested Subsections] (if section.sections.isNotEmpty)
             │                                                             ▼ [Padding] (left indentation)
             │                                                               └─▼ [Column]
             │                                                                    └─ [RECURSIVE SectionWidget]
             │
             ├─► [GestureDetector] (Right Resize Spacing Handle, if properties panel is open)
             │    └─ [MouseRegion] (cursor: SystemMouseCursors.resizeColumn)
             │         └─ [Container] (width: 1, color: AppColors.builderBorder)
             │
             └─► [Properties Panel Column] (Right Column)
                  │
                  ├─► [FormPropertiesWidget] (form_properties_widget.dart)
                  │    ▼ [PropertiesPanelShell]
                  │      ├─▼ [Header Component]
                  │      │    ▼ [Column]
                  │      │      ├─▼ [Padding] -> [Row]
                  │      │      │    ├─ [FaIcon] (FontAwesomeIcons.fileLines)
                  │      │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │      │      │    ├─ [Text] ("Form Properties")
                  │      │      │    ├─ [Spacer]
                  │      │      │    └─ [IconButton] (Icons.close)
                  │      │      ├─ [Divider]
                  │      │      └─▼ [Container] (Language Selector)
                  │      │           ▼ [Row]
                  │      │             ├─ [Icon] (Icons.translate)
                  │      │             ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │      │             ├─ [Text] ("Editing Language:")
                  │      │             ├─ [Spacer]
                  │      │             └─▼ [DropdownButtonHideUnderline]
                  │      │                  └─ [DropdownButton<String>] (en / es / fr language choices)
                  │      │
                  │      └─▼ [Body Component]
                  │           ▼ [Column]
                  │             ├─▼ [TabBar] (9 Scrollable tabs)
                  │             │    └─ Tabs (General, Layout, Style, Logic, Access, Submission, Quick Responses, Export, Advanced)
                  │             ├─ [Divider]
                  │             └─▼ [Expanded] -> [TabBarView] (Renders selected tab view)
                  │                  │
                  │                  ├─► [FormGeneralSettings] (general_settings_panels.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("General Settings")
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Form Title Field)
                  │                  │      │    └─ [TextFormField] (controller: _titleController)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      └─▼ [Focus] (Form Description Field)
                  │                  │           └─ [TextFormField] (controller: _descriptionController, maxLines: 3)
                  │                  │
                  │                  ├─► [FormLayoutSettings] (form_layout_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Layout Settings")
                  │                  │      ├─ [SizedBox] (height: DesignTokens.spaceM)
                  │                  │      └─ [DropdownButtonFormField<String>] (items: singleColumn / twoColumns / threeColumns)
                  │                  │
                  │                  ├─► [FormStyleSettings] (form_style_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Style Settings")
                  │                  │      ├─ [SizedBox] (height: DesignTokens.spaceM)
                  │                  │      ├─ [Text] ("Quick Palette")
                  │                  │      ├─ [SizedBox] (height: 6)
                  │                  │      ├─▼ [Wrap] (Renders background color choices)
                  │                  │      │    └─▼ [GestureDetector] (onTap: select color)
                  │                  │      │         └─▼ [Container] (color circle border)
                  │                  │      │              └─ [Icon] (Icons.check, visible if selected)
                  │                  │      ├─ [SizedBox] (height: 8)
                  │                  │      ├─▼ [_StatefulColorPicker] (Background Color picker)
                  │                  │      │    ▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
                  │                  │      │         ├─ [Text] ("Background Color")
                  │                  │      │         ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │         └─▼ [Row]
                  │                  │      │              ├─▼ [Expanded]
                  │                  │      │              │    └─ [TextFormField] (Hex input field)
                  │                  │      │              ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │              └─▼ [GestureDetector] (onTap: open color picker)
                  │                  │      │                   └─ [Container] (color square block)
                  │                  │      └─▼ [FormBrandingSettings] (form_branding_settings.dart)
                  │                  │           ▼ [Column]
                  │                  │             ├─ [SizedBox] (height: DesignTokens.spaceM)
                  │                  │             ├─ [Text] ("Branding")
                  │                  │             ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │             ├─▼ [Column] (Logo URL text field)
                  │                  │             │    ├─ [Text] ("Logo URL")
                  │                  │             │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │             │    └─▼ [Focus]
                  │                  │             │         └─ [TextFormField] (controller: _logoController)
                  │                  │             ├─ [SizedBox] (height: 12)
                  │                  │             ├─▼ [Column] (Cover image URL text field)
                  │                  │             │    ├─ [Text] ("Cover image URL")
                  │                  │             │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │             │    └─▼ [Focus]
                  │                  │             │         └─ [TextFormField] (controller: _coverController)
                  │                  │             ├─ [SizedBox] (height: 12)
                  │                  │             └─▼ [Column] (Favicon URL text field)
                  │                  │                  ├─ [Text] ("Favicon URL")
                  │                  │                  ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │                  └─▼ [Focus]
                  │                  │                       └─ [TextFormField] (controller: _faviconController)
                  │                  │
                  │                  ├─► [FormLogicSettings] (form_logic_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Workflow Logic")
                  │                  │      ├─ [SizedBox] (height: DesignTokens.spaceM)
                  │                  │      └─▼ [Expanded] -> [ListView.builder] (Lists workflows)
                  │                  │           └─▼ [Card]
                  │                  │                ▼ [ListTile]
                  │                  │                  ├─ [Icon] (Icons.route)
                  │                  │                  ├─ [Text] (workflow.name)
                  │                  │                  └─ [IconButton] (Icons.edit)
                  │                  │
                  │                  ├─► [FormAccessSettings] (form_access_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Access Control Policies")
                  │                  │      ├─▼ [DropdownButtonFormField<String>] (Public vs Restricted)
                  │                  │      └─ [SizedBox]
                  │                  │
                  │                  ├─► [FormSubmissionSettings] (form_submission_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Submission Target & Actions")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─ [TextFormField] (POST redirection target URL)
                  │                  │      ├─ [SizedBox]
                  │                  │      └─ [TextFormField] (Custom Success Message)
                  │                  │
                  │                  ├─► [FormQuickResponsesSettings] (form_quick_responses_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Canned / Saved Answers")
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [ListView.builder] (Lists canned answers)
                  │                  │           └─ [ListTile] -> [Text] (answer.shortcut)
                  │                  │
                  │                  ├─► [FormDataExportSettings] (form_data_export_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Export Template Designer")
                  │                  │      ├─ [SizedBox]
                  │                  │      └─ [DropdownButtonFormField<String>] (PDF / CSV / JSON layout options)
                  │                  │
                  │                  └─► [FormAdvancedSettings] (form_advanced_settings.dart)
                  │                       ▼ [Column]
                  │                         ├─ [Text] ("Engine Variables & Diagnostics")
                  │                         ├─ [SizedBox]
                  │                         └─ [TextFormField] (custom variables schema JSON)
                  │
                  ├─► [SectionPropertiesWidget] (section_properties_widget.dart)
                  │    ▼ [PropertiesPanelShell]
                  │      ├─▼ [Header Component]
                  │      │    ▼ [Column]
                  │      │      ├─▼ [Padding] -> [Row]
                  │      │      │    ├─ [FaIcon] (FontAwesomeIcons.layerGroup)
                  │      │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │      │      │    ├─ [Text] ("Section Properties")
                  │      │      │    ├─ [Spacer]
                  │      │      │    └─ [IconButton] (Icons.close)
                  │      │      └─ [Divider]
                  │      │
                  │      └─▼ [Body Component]
                  │           ▼ [Column]
                  │             ├─▼ [TabBar] (9 scrollable tabs)
                  │             │    └─ Tabs (General, Layout, Style, Logic, Visibility, Behavior, A11y, Analytics, Advanced)
                  │             ├─ [Divider]
                  │             └─▼ [Expanded] -> [TabBarView] (Renders selected tab view)
                  │                  │
                  │                  ├─► [SectionGeneralSettings] (general_settings_panels.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("General Settings")
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Section Title Input)
                  │                  │      │    └─ [TextFormField] (controller: _titleController)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Section Description Input)
                  │                  │      │    └─ [TextFormField] (controller: _descriptionController, maxLines: 3)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Section Help Text Input)
                  │                  │      │    └─ [TextFormField] (controller: _helpTextController, maxLines: 2)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Section Order)
                  │                  │      │    └─ [TextFormField] (controller: _orderController, keyboardType: number)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Section slug / identifier)
                  │                  │      │    └─ [TextFormField] (controller: _idController)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─▼ [Focus] (Short Label Input)
                  │                  │      │    └─ [TextFormField] (controller: _shortLabelController)
                  │                  │      ├─ [SizedBox] (height: 16)
                  │                  │      ├─ [Text] ("Tags")
                  │                  │      ├─ [SizedBox] (height: 8)
                  │                  │      ├─▼ [Wrap] (Renders active tags)
                  │                  │      │    └─▼ [InputChip]
                  │                  │      │         └─ [Text] (tag value)
                  │                  │      ├─ [SizedBox] (height: 8)
                  │                  │      └─ [TextFormField] (Tag typing controller for additions)
                  │                  │
                  │                  ├─► [SectionLayoutSettings] (section_layout_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Layout Settings")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [DropdownButtonFormField<String>] (layoutType: standard, centered, masonry, tabs)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Focus] (Grid Columns)
                  │                  │      │    └─ [TextFormField] (grid columns count count)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Row] (Is Hidden Switch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Is Hidden")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch] (value: isHidden)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Row] (Is Repeatable Switch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Is Repeatable")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch] (value: isRepeatable)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Focus] (Repeat Min)
                  │                  │      │    └─ [TextFormField]
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [Focus] (Repeat Max)
                  │                  │           └─ [TextFormField]
                  │                  │
                  │                  ├─► [SectionStyleSettings] (section_style_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Style Settings")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [_StatefulColorPicker] (Background Color picker)
                  │                  │      │    ▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
                  │                  │      │         ├─ [Text] ("Background Color")
                  │                  │      │         ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │         └─▼ [Row]
                  │                  │      │              ├─▼ [Expanded]
                  │                  │      │              │    └─ [TextFormField] (Hex input field)
                  │                  │      │              ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │              └─▼ [GestureDetector] (onTap: open color picker)
                  │                  │      │                   └─ [Container] (color preview block)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [_StatefulColorPicker] (Header background Color picker)
                  │                  │      │    ▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start)
                  │                  │      │         ├─ [Text] ("Header Background Color")
                  │                  │      │         ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │         └─▼ [Row]
                  │                  │      │              ├─▼ [Expanded]
                  │                  │      │              │    └─ [TextFormField] (Hex input field)
                  │                  │      │              ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │              └─▼ [GestureDetector] (onTap: open color picker)
                  │                  │      │                   └─ [Container] (color preview block)
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Focus] (Padding)
                  │                  │      │    └─ [TextFormField]
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Focus] (Border Width)
                  │                  │      │    └─ [TextFormField]
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [Focus] (Border Radius)
                  │                  │           └─ [TextFormField]
                  │                  │
                  │                  ├─► [SectionLogicSettings] (section_logic_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Section Navigation Logic")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [DropdownButtonFormField<String>] (nextSectionAction: continue, jump, submit)
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [DropdownButtonFormField<String>] (jumpSectionTargetId dropdown items)
                  │                  │
                  │                  ├─► [SectionVisibilitySettings] (section_visibility_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Section Visibility Rules")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [DropdownButtonFormField<String>] (visibilityRuleType: always, conditional)
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [Row] (Rules list editing buttons)
                  │                  │           └─ [TextButton] ("+ Add visibility rule condition")
                  │                  │
                  │                  ├─► [SectionExtraSettings: Behavior] (section_extra_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Behavior Settings")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Row] (Sticky Header Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Sticky header")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Collapsible Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Collapsible section")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Start Collapsed Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Start collapsed")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Required To Continue Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Required to continue")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Prevent Skipping Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Prevent skipping")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Allow Back Toggle - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         ├─ [Text] ("Allow back navigation")
                  │                  │      │    │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                  │                  │      │    │         └─ [Text] ("Enable back button navigation")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      └─▼ [Row] (Allow Edit After Submit Toggle - buildSwitch)
                  │                  │           ├─▼ [Expanded]
                  │                  │           │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │           │         └─ [Text] ("Allow edit after submit")
                  │                  │           ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │           └─ [Switch]
                  │                  │
                  │                  ├─► [SectionExtraSettings: A11y] (section_extra_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("A11y Settings")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Column] (Accessible Label field - buildTextField)
                  │                  │      │    ├─ [Text] ("Accessible label")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField]
                  │                  │      └─▼ [Column] (Tooltip Text field - buildTextField)
                  │                  │           ├─ [Text] ("Tooltip text")
                  │                  │           ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │           └─▼ [Focus]
                  │                  │                └─ [TextFormField]
                  │                  │
                  │                  ├─► [SectionExtraSettings: Analytics] (section_extra_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Analytics settings")
                  │                  │      ├─ [SizedBox]
                  │                  │      ├─▼ [Row] (Track View switch - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         ├─ [Text] ("Track section view")
                  │                  │      │    │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                  │                  │      │    │         └─ [Text] ("Log view events to dashboard")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Track Completion switch - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         ├─ [Text] ("Track completion")
                  │                  │      │    │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                  │                  │      │    │         └─ [Text] ("Log section completion events")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Row] (Track Dwell Time switch - buildSwitch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         └─ [Text] ("Track dwell time")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      └─▼ [Column] (Analytics Event Name - buildTextField)
                  │                  │           ├─ [Text] ("Analytics event name")
                  │                  │           ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │           └─▼ [Focus]
                  │                  │                └─ [TextFormField]
                  │                  │
                  │                  └─► [SectionExtraSettings: Advanced] (section_extra_settings.dart)
                  │                       ▼ [Column]
                  │                         ├─ [Text] ("Advanced settings")
                  │                         ├─ [SizedBox]
                  │                         ├─▼ [Column] (Width Mode dropdown - buildDropdown)
                  │                         │    ├─ [Text] ("Width mode")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Container] (decoration styled box)
                  │                         │         └─▼ [DropdownButtonHideUnderline]
                  │                         │              └─ [DropdownButton<String>] (value: widthMode)
                  │                         ├─▼ [Column] (Max Width slider - buildNumberSlider)
                  │                         │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                         │    │    ├─ [Text] ("Max width")
                  │                         │    │    └─ [Text] (value string)
                  │                         │    └─ [Slider] (0 to 1200)
                  │                         ├─▼ [Column] (Min Width slider - buildNumberSlider)
                  │                         │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                         │    │    ├─ [Text] ("Min width")
                  │                         │    │    └─ [Text] (value string)
                  │                         │    └─ [Slider] (0 to 800)
                  │                         ├─▼ [Column] (Field Gap slider - buildNumberSlider)
                  │                         │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                         │    │    ├─ [Text] ("Field gap")
                  │                         │    │    └─ [Text] (value string)
                  │                         │    └─ [Slider] (0 to 64)
                  │                         ├─▼ [Column] (Vertical Padding slider - buildNumberSlider)
                  │                         │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                         │    │    ├─ [Text] ("Vertical padding")
                  │                         │    │    └─ [Text] (value string)
                  │                         │    └─ [Slider] (0 to 120)
                  │                         ├─▼ [Column] (Horizontal Padding slider - buildNumberSlider)
                  │                         │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                         │    │    ├─ [Text] ("Horizontal padding")
                  │                         │    │    └─ [Text] (value string)
                  │                         │    └─ [Slider] (0 to 120)
                  │                         ├─▼ [Column] (Template - buildTextField)
                  │                         │    ├─ [Text] ("Template / preset name")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Focus]
                  │                         │         └─ [TextFormField]
                  │                         ├─▼ [Column] (Owner - buildTextField)
                  │                         │    ├─ [Text] ("Owner / reviewer")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Focus]
                  │                         │         └─ [TextFormField]
                  │                         ├─▼ [Column] (Author Notes - buildTextField)
                  │                         │    ├─ [Text] ("Author notes")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Focus]
                  │                         │         └─ [TextFormField] (maxLines: 2)
                  │                         ├─▼ [Column] (Workflow Action - buildTextField)
                  │                         │    ├─ [Text] ("Workflow action")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Focus]
                  │                         │         └─ [TextFormField]
                  │                         ├─▼ [Column] (Permissions chips - buildChips)
                  │                         │    ├─ [Text] ("Permissions")
                  │                         │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                         │    └─▼ [Focus]
                  │                         │         └─ [TextFormField]
                  │                         └─▼ [Column] (Section Anchor - buildTextField)
                  │                              ├─ [Text] ("Section anchor")
                  │                              ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                              └─▼ [Focus]
                  │                                   └─ [TextFormField]
                  │
                  ├─► [FieldPropertiesWidget] (field_properties_widget.dart)
                  │    ▼ [PropertiesPanelShell]
                  │      ├─▼ [Header Component]
                  │      │    ▼ [Padding] -> [Wrap]
                  │      │         ├─ [FaIcon] (FontAwesomeIcons.sliders)
                  │      │         ├─ [Text] ("Field Properties")
                  │      │         ├─ [TextButton.icon] (Save Template)
                  │      │         └─ [IconButton] (Icons.close)
                  │      │
                  │      └─▼ [Body Component]
                  │           ▼ [Column]
                  │             ├─▼ [TabBar] (6 scrollable tabs)
                  │             │    └─ Tabs (General, Layout, Validation, Specific, Style, Logic)
                  │             ├─ [Divider]
                  │             └─▼ [Expanded] -> [TabBarView]
                  │                  ├─► [FieldGeneralSettings] (field_general_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─▼ [Column] (Field Label)
                  │                  │      │    ├─ [Text] ("Label text")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField] (controller: _labelController)
                  │                  │      ├─▼ [Column] (Variable reference)
                  │                  │      │    ├─ [Text] ("Variable reference")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField] (controller: _variableNameController)
                  │                  │      ├─▼ [Column] (Helper text)
                  │                  │      │    ├─ [Text] ("Helper/description text")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField] (controller: _helperTextController)
                  │                  │      └─▼ [Column] (Placeholder)
                  │                  │           ├─ [Text] ("Input placeholder text")
                  │                  │           ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │           └─▼ [Focus]
                  │                  │                └─ [TextFormField] (controller: _placeholderController)
                  │                  │
                  │                  ├─► [FieldLayoutSettings] (field_layout_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─▼ [Column] (Label Position position dropdown)
                  │                  │      │    ├─ [Text] ("Label alignment position")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Container] (decoration styled box)
                  │                  │      │         └─▼ [DropdownButtonHideUnderline]
                  │                  │      │              └─ [DropdownButton<String>] (value: labelPosition)
                  │                  │      ├─▼ [Column] (Column Span slider)
                  │                  │      │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                  │      │    │    ├─ [Text] ("Grid column span")
                  │                  │      │    │    └─ [Text] (value string)
                  │                  │      │    └─ [Slider] (1 to 4)
                  │                  │      └─▼ [Column] (Bottom Margin slider)
                  │                  │           ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                  │           │    ├─ [Text] ("Bottom margin")
                  │                  │           │    └─ [Text] (value string)
                  │                  │           └─ [Slider] (0 to 64)
                  │                  │
                  │                  ├─► [DynamicPropertiesPanel] (dynamic_properties_panel.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Field validation options")
                  │                  │      ├─▼ [Row] (Required switch)
                  │                  │      │    ├─▼ [Expanded]
                  │                  │      │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                  │                  │      │    │         ├─ [Text] ("Required")
                  │                  │      │    │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                  │                  │      │    │         └─ [Text] ("This field is mandatory")
                  │                  │      │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │    └─ [Switch]
                  │                  │      ├─▼ [Column] (Min Length input box)
                  │                  │      │    ├─ [Text] ("Minimum characters constraint")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField]
                  │                  │      ├─▼ [Column] (Max Length input box)
                  │                  │      │    ├─ [Text] ("Maximum characters constraint")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField]
                  │                  │      └─▼ [Column] (Validation Regex input box)
                  │                  │           ├─ [Text] ("Custom regex matching validation")
                  │                  │           ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │           └─▼ [Focus]
                  │                  │                └─ [TextFormField]
                  │                  │
                  │                  ├─► [FieldSpecificSettings] (field_specific_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─► [IF FIELD TYPE HAS OPTIONS]
                  │                  │      │    ▼ [Column]
                  │                  │      │         ├─ [Text] ("Edit Selection Options List")
                  │                  │      │         ├─▼ [Expanded] -> [ListView.builder] (Lists options)
                  │                  │      │         │    └─▼ [Row]
                  │                  │      │         │         ├─ [Icon] (Icons.drag_handle)
                  │                  │      │         │         ├─ [Expanded] -> [TextFormField] (Option label)
                  │                  │      │         │         └─ [IconButton] (Icons.delete_outline)
                  │                  │      │         └─ [TextButton] ("+ Add another option choice")
                  │                  │      │
                  │                  │      ├─► [IF FIELD TYPE IS DATE RANGE]
                  │                  │      │    ▼ [Column]
                  │                  │      │         ├─ [DropdownButtonFormField] (Min date selector limit)
                  │                  │      │         └─ [DropdownButtonFormField] (Max date selector limit)
                  │                  │      │
                  │                  │      └─► [IF FIELD TYPE IS SLIDER / RATING]
                  │                  │           ▼ [Column]
                  │                  │                ├─ [TextFormField] (Min numerical range)
                  │                  │                ├─ [TextFormField] (Max numerical range)
                  │                  │                └─ [TextFormField] (Rating increments)
                  │                  │
                  │                  ├─► [FieldStyleSettings] (field_style_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─▼ [Column] (Border style - buildDropdown)
                  │                  │      │    ├─ [Text] ("Border input style")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Container]
                  │                  │      │         └─▼ [DropdownButtonHideUnderline]
                  │                  │      │              └─ [DropdownButton<String>]
                  │                  │      ├─▼ [_StatefulColorPicker] (Input text color picker)
                  │                  │      │    ▼ [Column]
                  │                  │      │         ├─ [Text] ("Text Color")
                  │                  │      │         ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │         └─▼ [Row]
                  │                  │      │              ├─▼ [Expanded]
                  │                  │      │              │    └─ [TextFormField]
                  │                  │      │              ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │              └─▼ [GestureDetector]
                  │                  │      │                   └─ [Container] (color block)
                  │                  │      ├─▼ [_StatefulColorPicker] (Border color picker)
                  │                  │      │    ▼ [Column]
                  │                  │      │         ├─ [Text] ("Border Color")
                  │                  │      │         ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │         └─▼ [Row]
                  │                  │      │              ├─▼ [Expanded]
                  │                  │      │              │    └─ [TextFormField]
                  │                  │      │              ├─ [SizedBox] (width: DesignTokens.spaceS)
                  │                  │      │              └─▼ [GestureDetector]
                  │                  │      │                   └─ [Container] (color block)
                  │                  │      ├─▼ [Column] (Height slider - buildNumberSlider)
                  │                  │      │    ├─▼ [Row] (mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  │                  │      │    │    ├─ [Text] ("Custom height size")
                  │                  │      │    │    └─ [Text] (value string)
                  │                  │      │    └─ [Slider] (32 to 120)
                  │                  │      ├─▼ [Column] (Prefix Icon text box - buildTextField)
                  │                  │      │    ├─ [Text] ("Prefix icon code / emoji")
                  │                  │      │    ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │      │    └─▼ [Focus]
                  │                  │      │         └─ [TextFormField]
                  │                  │      └─▼ [Column] (Suffix Icon text box - buildTextField)
                  │                  │           ├─ [Text] ("Suffix icon code / emoji")
                  │                  │           ├─ [SizedBox] (height: DesignTokens.spaceS)
                  │                  │           └─▼ [Focus]
                  │                  │                └─ [TextFormField]
                  │                  │
                  │                  ├─► [FieldLogicSettings] (field_logic_settings.dart)
                  │                  │    ▼ [Column]
                  │                  │      ├─ [Text] ("Trigger Condition Skip Policies")
                  │                  │      ├─ [SizedBox]
                  │                  │      └─▼ [DropdownButtonFormField<String>] (If value matches option -> skip/jump to Target Section)
                  │
                  └─► [BulkQuestionPropertiesWidget] (bulk_question_properties_widget.dart)
                       ▼ [Container]
                         ▼ [Column]
                           ├─▼ [Padding] -> [Row]
                           │    ├─ [Icon] (Icons.layers_outlined)
                           │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                           │    ├─ [Text] ("Bulk Edit (N Questions)")
                           │    ├─ [Spacer]
                           │    └─ [IconButton] (Icons.close -> clearQuestionSelections)
                           ├─ [Divider]
                           └─▼ [Expanded] -> [SingleChildScrollView]
                                ▼ [Column]
                                     ├─ [Text] ("COMMON CHANGES")
                                     ├─ [SizedBox]
                                     ├─▼ [DropdownButtonFormField<QuestionType>] (Type converter selection)
                                     ├─ [SizedBox]
                                     ├─▼ [Row] (Apply required settings - buildSwitch)
                                     │    ├─▼ [Expanded]
                                     │    │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                                     │    │         ├─ [Text] ("Required")
                                     │    │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                                     │    │         └─ [Text] ("Apply required validation to all selected questions.")
                                     │    ├─ [SizedBox] (width: DesignTokens.spaceS)
                                     │    └─ [Switch]
                                     ├─ [SizedBox]
                                     └─▼ [Row] (Apply hidden settings - buildSwitch)
                                          ├─▼ [Expanded]
                                          │    └─▼ [Column] (crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
                                          │         ├─ [Text] ("Hidden")
                                          │         ├─ [SizedBox] (height: DesignTokens.spaceXS)
                                          │         └─ [Text] ("Apply visibility changes to all selected questions.")
                                          ├─ [SizedBox] (width: DesignTokens.spaceS)
                                          └─ [Switch]
```
