import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/error_widget.dart';

class QuotaManagementScreen extends ConsumerStatefulWidget {
  const QuotaManagementScreen({super.key});

  @override
  ConsumerState<QuotaManagementScreen> createState() => _QuotaManagementScreenState();
}

class _QuotaManagementScreenState extends ConsumerState<QuotaManagementScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _organizations = [];
  Map<String, dynamic>? _selectedOrg;
  Map<String, dynamic>? _quotaInfo;

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
      final apiService = ref.read(apiServiceProvider);
      // Load organizations
      final orgsResponse = await apiService.get('/admin/organizations');
      if (orgsResponse.success) {
        _organizations = List<Map<String, dynamic>>.from(orgsResponse.data['organizations']);
      }

      if (_organizations.isNotEmpty) {
        _selectedOrg = _organizations.first;
        await _loadQuotaInfo(_selectedOrg!['id']);
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

  Future<void> _loadQuotaInfo(String orgId) async {
    try {
      final response = await ref.read(apiServiceProvider).get('/admin/organizations/$orgId/quota');
      if (response.success) {
        setState(() {
          _quotaInfo = Map<String, dynamic>.from(response.data);
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _updateQuota(String orgId, int quotaBytes) async {
    try {
      final response = await ref.read(apiServiceProvider).put(
        '/admin/organizations/$orgId/quota',
        data: {'quota_bytes': quotaBytes},
      );

      if (response.success) {
        ref.read(snackbarServiceProvider).showSuccess('Quota updated successfully');
        await _loadQuotaInfo(orgId); // Refresh quota info
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Error updating quota: $e');
    }
  }

  void _showUpdateQuotaDialog() {
    if (_quotaInfo == null) return;

    final TextEditingController controller = TextEditingController(
      text: (_quotaInfo!['quota_bytes'] / (1024 * 1024 * 1024)).toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Storage Quota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Quota (GB)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Current quota: ${(_quotaInfo!['quota_bytes'] / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newQuotaGb = double.tryParse(controller.text);
              if (newQuotaGb != null) {
                Navigator.of(context).pop();
                _updateQuota(_selectedOrg!['id'], (newQuotaGb * 1024 * 1024 * 1024).toInt());
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Quota Management'),
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
              if (value != null) {
                _loadQuotaInfo(value['id']);
              }
            },
          ),
        ),

        // Quota information
        if (_quotaInfo != null) ...[
          Expanded(
            child: _buildQuotaInfo(),
          ),
        ],
      ],
    );
  }

  Widget _buildQuotaInfo() {
    final quotaBytes = _quotaInfo!['quota_bytes'];
    final usedBytes = _quotaInfo!['used_bytes']['total'];
    final availableBytes = _quotaInfo!['available_bytes'];
    final usageRatio = _quotaInfo!['usage_ratio'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quota overview card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storage Quota Overview',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  // Progress bar
                  LinearProgressIndicator(
                    value: usageRatio.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      usageRatio > 0.9 ? Colors.red : usageRatio > 0.8 ? Colors.orange : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Usage statistics
                  Text(
                    '${(usedBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB '
                    'of ${(quotaBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB used '
                    '(${(usageRatio * 100).toStringAsFixed(1)}%)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Available: ${(availableBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          // Detailed breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Storage Breakdown',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16.0),
                  _buildStorageRow('Files', _quotaInfo!['used_bytes']['files']),
                  _buildStorageRow('Database', _quotaInfo!['used_bytes']['database']),
                  _buildStorageRow('Audit Logs', _quotaInfo!['used_bytes']['audit_logs']),
                  const Divider(),
                  _buildStorageRow('Total', usedBytes, isTotal: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16.0),

          // Update quota button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showUpdateQuotaDialog,
              child: const Text('Update Quota'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageRow(String label, int bytes, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
            style: isTotal
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
