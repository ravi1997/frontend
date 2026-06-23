import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/networking/dio_provider.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';

class ComplianceManagementScreen extends ConsumerStatefulWidget {
  const ComplianceManagementScreen({super.key});

  @override
  ConsumerState<ComplianceManagementScreen> createState() => _ComplianceManagementScreenState();
}

class _ComplianceManagementScreenState extends ConsumerState<ComplianceManagementScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _organizations = [];
  Map<String, dynamic>? _selectedOrg;
  List<Map<String, dynamic>> _complianceStandards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = ref.read(apiClientProvider);
      _organizations = List<Map<String, dynamic>>.from(await api.listOrganizations());
      _complianceStandards =
          List<Map<String, dynamic>>.from(await api.listComplianceStandards());

      if (_organizations.isNotEmpty) {
        _selectedOrg = _organizations.first;
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateOrgCompliance(String orgId, List<String> complianceIds) async {
    try {
      await ref.read(apiClientProvider).updateOrganizationCompliance(orgId, complianceIds);
      ref.read(snackbarServiceProvider).showSuccess('Compliance settings updated successfully');
      await _loadData();
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Error updating compliance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compliance Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget()
          : _error != null
              ? AppErrorWidget(
                  error: _error!,
                  onRetry: _loadData,
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Organization selector
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<Map<String, dynamic>>(
            initialValue: _selectedOrg,
            decoration: const InputDecoration(
              labelText: 'Select Organization',
              border: OutlineInputBorder(),
            ),
            items: _organizations.map((org) {
              return DropdownMenuItem(
                value: org,
                child: Text(org['name'].toString()),
              );
            }).toList(growable: false),
            onChanged: (value) {
              setState(() {
                _selectedOrg = value;
              });
            },
          ),
        ),

        // Compliance settings
        if (_selectedOrg != null) ...[
          Expanded(
            child: _buildComplianceSettings(),
          ),
        ],
      ],
    );
  }

  Widget _buildComplianceSettings() {
    final orgComplianceIds = List<String>.from(_selectedOrg!['compliance_ids'] ?? []);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance Standards',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            ..._complianceStandards.map((standard) {
              final isSelected = orgComplianceIds.contains(standard['id']);
                return CheckboxListTile(
                title: Text(standard['name'].toString()),
                subtitle: Text(standard['description'].toString()),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      orgComplianceIds.add(standard['id']);
                    } else {
                      orgComplianceIds.remove(standard['id']);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _updateOrgCompliance(_selectedOrg!['id'], orgComplianceIds);
                },
                child: const Text('Update Compliance Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
