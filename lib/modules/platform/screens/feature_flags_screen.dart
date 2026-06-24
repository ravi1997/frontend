import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/app/theme/tokens.dart';
import 'package:frontend/core/widgets/responsive.dart';
import '../feature_flag_repository.dart';
import '../organization_repository.dart';
import 'package:frontend/core/services/snackbar_service.dart';

class FeatureFlagsScreen extends ConsumerStatefulWidget {
  const FeatureFlagsScreen({super.key});

  @override
  ConsumerState<FeatureFlagsScreen> createState() => _FeatureFlagsScreenState();
}

class _FeatureFlagsScreenState extends ConsumerState<FeatureFlagsScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _flags = [];
  List<Map<String, dynamic>> _orgs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final flagRepo = ref.read(featureFlagRepositoryProvider);
      final orgRepo = ref.read(organizationRepositoryProvider);
      
      final flagsList = await flagRepo.listFeatureFlags();
      final orgsList = await orgRepo.listOrgs();
      
      setState(() {
        _flags = flagsList;
        _orgs = orgsList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ref.read(snackbarServiceProvider).showError('Failed to load settings: $e');
    }
  }

  Future<void> _toggleGlobalFlag(String flagKey, bool currentVal) async {
    try {
      final flagRepo = ref.read(featureFlagRepositoryProvider);
      await flagRepo.updateGlobalFeatureFlag(flagKey, !currentVal);
      ref.read(snackbarServiceProvider).showSuccess('Global flag updated successfully');
      _loadData();
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Failed to update global flag: $e');
    }
  }

  Future<void> _updateOverride(String flagKey, String orgId, bool isEnabled) async {
    try {
      final flagRepo = ref.read(featureFlagRepositoryProvider);
      await flagRepo.updateFeatureFlagOverride(flagKey, orgId, isEnabled);
      ref.read(snackbarServiceProvider).showSuccess('Organization override configured successfully');
      _loadData();
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Failed to configure override: $e');
    }
  }

  void _showAddOverrideDialog(String flagKey) {
    if (_orgs.isEmpty) {
      ref.read(snackbarServiceProvider).showError('No organizations available to override.');
      return;
    }

    String selectedOrgId = _orgs.first['id'].toString();
    bool isEnabled = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusL),
              ),
              title: Text(
                'Add Tenant Override',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedOrgId,
                    decoration: const InputDecoration(labelText: 'Select Organization'),
                    items: _orgs.map((org) {
                      return DropdownMenuItem<String>(
                        value: org['id'].toString(),
                        child: Text(org['name']?.toString() ?? 'Untitled'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedOrgId = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Override Value'),
                    value: isEnabled,
                    onChanged: (val) {
                      setDialogState(() => isEnabled = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateOverride(flagKey, selectedOrgId, isEnabled);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(
          'Feature Rollout Gates Manager',
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flags.isEmpty
              ? Center(
                child: Text(
                  'No feature flags defined.',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                    fontSize: DesignTokens.fontM,
                  ),
                ),
              )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(DesignTokens.spaceL),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Responsive.maxContentWidth(context),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _flags.length,
                        itemBuilder: (context, index) {
                    final flag = _flags[index];
                    final key = flag['key']?.toString() ?? '';
                    final name = flag['name']?.toString() ?? key;
                    final desc = flag['description']?.toString() ?? 'No description provided';
                    final isEnabled = flag['is_enabled'] as bool? ?? false;
                    final rawOverrides = flag['per_org_overrides'];
                    final overrides = rawOverrides is Map ? Map<String, dynamic>.from(rawOverrides) : <String, dynamic>{};

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                      margin: const EdgeInsets.only(bottom: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(DesignTokens.spaceL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: DesignTokens.fontM,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Key: $key',
                                        style: GoogleFonts.inter(
                                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                          fontSize: DesignTokens.fontS,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: isEnabled,
                                  activeThumbColor: Theme.of(context).colorScheme.primary,
                                  onChanged: (val) => _toggleGlobalFlag(key, isEnabled),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              desc,
                              style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                fontSize: DesignTokens.fontM,
                                height: 1.5,
                              ),
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Organization Overrides',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: DesignTokens.fontM,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _showAddOverrideDialog(key),
                                  icon: const Icon(Icons.add_circle_outline, size: 18),
                                  label: const Text('Add Override'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            if (overrides.isEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'No tenant-specific overrides configured.',
                                style: GoogleFonts.inter(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontSize: DesignTokens.fontS,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: overrides.length,
                                itemBuilder: (context, oIndex) {
                                  final orgId = overrides.keys.elementAt(oIndex);
                                  final orgVal = overrides[orgId] as bool? ?? false;
                                  final orgName = _orgs.firstWhere(
                                    (o) => o['id'].toString() == orgId,
                                    orElse: () => {'name': orgId},
                                  )['name'];

                                    return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: DesignTokens.spaceXS),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            orgName.toString(),
                                            style: GoogleFonts.inter(
                                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                orgVal ? 'Enabled' : 'Disabled',
                                                style: GoogleFonts.inter(
                                                color: orgVal ? DesignTokens.success : DesignTokens.error,
                                                fontSize: DesignTokens.fontS,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              tooltip: orgVal ? 'Disable override' : 'Enable override',
                                              icon: Icon(
                                                orgVal ? Icons.toggle_on : Icons.toggle_off,
                                                size: 24,
                                                color: orgVal
                                                    ? DesignTokens.success
                                                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                              ),
                                              onPressed: () => _updateOverride(key, orgId, !orgVal),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                      ),
                    );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }
}
