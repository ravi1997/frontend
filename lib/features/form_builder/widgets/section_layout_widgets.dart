// ignore_for_file: avoid_dynamic_calls
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// ACCORDION — collapsible section; works standalone (no sub-sections needed)
// ---------------------------------------------------------------------------
class AccordionSection extends StatefulWidget {
  final dynamic section;
  final String locale;
  final Color sectionBg;
  final Map<String, dynamic> metadata;
  final Widget questionsGrid;
  final List<Widget> childSections;

  const AccordionSection({
    super.key,
    required this.section,
    required this.locale,
    required this.sectionBg,
    required this.metadata,
    required this.questionsGrid,
    required this.childSections,
  });

  @override
  State<AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<AccordionSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _expanded = widget.metadata['accordionStartExpanded'] as bool? ?? false;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: _expanded ? 1.0 : 0.0,
    );
    _heightFactor = _ctrl.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        (widget.section.title?.translate(widget.locale) as String?) ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.sectionBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title.isEmpty ? 'Section' : title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 260),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightFactor,
            child: Column(
              children: [
                const Divider(height: 1, color: AppColors.borderLight),
                widget.questionsGrid,
                ...widget.childSections,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TABBED — requires sub-sections (each sub-section = one tab)
// Condition: section.sections.isNotEmpty
// ---------------------------------------------------------------------------
class TabbedSection extends StatefulWidget {
  final dynamic section;
  final List<dynamic> tabs;
  final String locale;
  final Color sectionBg;
  final Color headerBg;
  final Map<String, dynamic> metadata;
  final dynamic sectionStyle;
  final Widget Function(dynamic) buildQuestionsGrid;

  const TabbedSection({
    super.key,
    required this.section,
    required this.tabs,
    required this.locale,
    required this.sectionBg,
    required this.headerBg,
    required this.metadata,
    required this.sectionStyle,
    required this.buildQuestionsGrid,
  });

  @override
  State<TabbedSection> createState() => _TabbedSectionState();
}

class _TabbedSectionState extends State<TabbedSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showHeader = widget.sectionStyle.showHeader as bool? ?? false;
    final radius = widget.sectionStyle.borderRadius as double? ?? 10.0;
    final sectionTitle =
        (widget.section.title?.translate(widget.locale) as String?) ?? '';
    final tabPosition = widget.metadata['tabPosition']?.toString() ?? 'top';
    final scrollable = widget.metadata['tabScrollable'] as bool? ?? true;

    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: scrollable,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textGrey,
      indicatorColor: AppColors.primary,
      tabs: widget.tabs.map<Tab>((tab) {
        final label = (tab.title?.translate(widget.locale) as String?) ?? '';
        return Tab(text: label.isEmpty ? 'Tab' : label);
      }).toList(),
    );

    final tabBarView = SizedBox(
      height: 320,
      child: TabBarView(
        controller: _tabController,
        children: widget.tabs
            .map<Widget>(
              (tab) =>
                  SingleChildScrollView(child: widget.buildQuestionsGrid(tab)),
            )
            .toList(),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.sectionBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader && sectionTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                sectionTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
            ),
          if (tabPosition == 'top') tabBar,
          if (tabPosition == 'top')
            const Divider(height: 1, color: AppColors.borderLight),
          tabBarView,
          if (tabPosition == 'bottom')
            const Divider(height: 1, color: AppColors.borderLight),
          if (tabPosition == 'bottom') tabBar,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SIDEBAR — requires sub-sections (nav list on left, content on right)
// Condition: section.sections.isNotEmpty
// ---------------------------------------------------------------------------
class SidebarSection extends StatefulWidget {
  final dynamic section;
  final String locale;
  final Color sectionBg;
  final Color headerBg;
  final Map<String, dynamic> metadata;
  final dynamic sectionStyle;
  final Widget Function(dynamic) buildQuestionsGrid;
  final Widget Function(dynamic) buildChildSection;

  const SidebarSection({
    super.key,
    required this.section,
    required this.locale,
    required this.sectionBg,
    required this.headerBg,
    required this.metadata,
    required this.sectionStyle,
    required this.buildQuestionsGrid,
    required this.buildChildSection,
  });

  @override
  State<SidebarSection> createState() => _SidebarSectionState();
}

class _SidebarSectionState extends State<SidebarSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final children = widget.section.sections as List;
    final showHeader = widget.sectionStyle.showHeader as bool? ?? false;
    final radius = widget.sectionStyle.borderRadius as double? ?? 10.0;
    final sectionTitle =
        (widget.section.title?.translate(widget.locale) as String?) ?? '';
    final sidebarWidth =
        (widget.metadata['sidebarWidth'] as num?)?.toDouble() ?? 180.0;
    final sidebarPosition =
        widget.metadata['sidebarPosition']?.toString() ?? 'left';

    final navPanel = Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: AppColors.builderElement,
        borderRadius: BorderRadius.horizontal(
          left: sidebarPosition == 'left'
              ? Radius.circular(radius)
              : Radius.zero,
          right: sidebarPosition == 'right'
              ? Radius.circular(radius)
              : Radius.zero,
        ),
        border: Border(
          right: sidebarPosition == 'left'
              ? const BorderSide(color: AppColors.borderLight)
              : BorderSide.none,
          left: sidebarPosition == 'right'
              ? const BorderSide(color: AppColors.borderLight)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader && sectionTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                sectionTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ...children.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final label = (s.title?.translate(widget.locale) as String?) ?? '';
            final isActive = i == _selected;
            return InkWell(
              onTap: () => setState(() => _selected = i),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  border: isActive
                      ? Border(
                          left: sidebarPosition == 'left'
                              ? const BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                )
                              : BorderSide.none,
                          right: sidebarPosition == 'right'
                              ? const BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                )
                              : BorderSide.none,
                        )
                      : null,
                ),
                child: Text(
                  label.isEmpty ? 'Section ${i + 1}' : label,
                  style: TextStyle(
                    color: isActive ? AppColors.primary : AppColors.textDark,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );

    final contentPanel = Expanded(
      child: SingleChildScrollView(
        child: widget.buildQuestionsGrid(children[_selected]),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.sectionBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (sidebarPosition == 'left') navPanel,
            contentPanel,
            if (sidebarPosition == 'right') navPanel,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// WIZARD — requires sub-sections (each = one step)
// Condition: section.sections.isNotEmpty
// ---------------------------------------------------------------------------
class WizardSection extends StatefulWidget {
  final dynamic section;
  final List<dynamic> steps;
  final String locale;
  final Color sectionBg;
  final Map<String, dynamic> metadata;
  final dynamic sectionStyle;
  final Widget Function(dynamic) buildQuestionsGrid;

  const WizardSection({
    super.key,
    required this.section,
    required this.steps,
    required this.locale,
    required this.sectionBg,
    required this.metadata,
    required this.sectionStyle,
    required this.buildQuestionsGrid,
  });

  @override
  State<WizardSection> createState() => _WizardSectionState();
}

class _WizardSectionState extends State<WizardSection> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = widget.steps;
    final total = steps.length;
    final currentSection = steps[_currentStep];
    final radius = widget.sectionStyle.borderRadius as double? ?? 10.0;
    final stepTitle =
        (currentSection.title?.translate(widget.locale) as String?) ??
        'Step ${_currentStep + 1}';
    final showProgress = widget.metadata['wizardShowProgress'] as bool? ?? true;
    final allowBack = widget.metadata['wizardAllowBack'] as bool? ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.sectionBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step progress header
          if (showProgress)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(total, (i) {
                      final isActive = i == _currentStep;
                      final isDone = i < _currentStep;
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isDone || isActive
                                      ? AppColors.primary
                                      : AppColors.borderLight,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            if (i < total - 1) const SizedBox(width: 4),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of $total',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          stepTitle.isEmpty
                              ? 'Step ${_currentStep + 1}'
                              : stepTitle,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (!showProgress) const SizedBox(height: 16),
          // Current step questions
          widget.buildQuestionsGrid(currentSection),
          // Navigation
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0 && allowBack)
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _currentStep--),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                    ),
                  )
                else
                  const SizedBox(),
                ElevatedButton.icon(
                  onPressed: _currentStep < total - 1
                      ? () => setState(() => _currentStep++)
                      : null,
                  icon: Icon(
                    _currentStep < total - 1
                        ? Icons.arrow_forward
                        : Icons.check,
                    size: 16,
                  ),
                  label: Text(_currentStep < total - 1 ? 'Next' : 'Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MASONRY — staggered 2-column layout for sub-sections
// Condition: section.sections.length >= 2
// ---------------------------------------------------------------------------
class MasonrySection extends StatelessWidget {
  final dynamic section;
  final String locale;
  final Color sectionBg;
  final Color headerBg;
  final Map<String, dynamic> metadata;
  final dynamic sectionStyle;
  final Widget Function(dynamic) buildChildSection;

  const MasonrySection({
    super.key,
    required this.section,
    required this.locale,
    required this.sectionBg,
    required this.headerBg,
    required this.metadata,
    required this.sectionStyle,
    required this.buildChildSection,
  });

  @override
  Widget build(BuildContext context) {
    final children = section.sections as List;
    final radius = sectionStyle.borderRadius as double? ?? 10.0;
    final showHeader = sectionStyle.showHeader as bool? ?? false;
    final sectionTitle = (section.title?.translate(locale) as String?) ?? '';

    final leftItems = <Widget>[];
    final rightItems = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i.isEven) {
        leftItems.add(buildChildSection(children[i]));
      } else {
        rightItems.add(buildChildSection(children[i]));
      }
    }

    final masonryGap = (metadata['masonryGap'] as num?)?.toDouble() ?? 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: sectionBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader && sectionTitle.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: headerBg,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(radius),
                ),
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Text(
                sectionTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: leftItems)),
                SizedBox(width: masonryGap),
                Expanded(child: Column(children: rightItems)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
