import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/widgets/responsive.dart';
import '../api_key_repository.dart';

class ApiKeyManagementScreen extends ConsumerStatefulWidget {
  const ApiKeyManagementScreen({super.key});

  @override
  ConsumerState<ApiKeyManagementScreen> createState() =>
      _ApiKeyManagementScreenState();
}

class _ApiKeyManagementScreenState extends ConsumerState<ApiKeyManagementScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _keys = [];

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(apiKeyRepositoryProvider);
      final keys = await repo.listApiKeys();
      setState(() {
        _keys = keys;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ref.read(snackbarServiceProvider).showError('Failed to load API keys: $e');
    }
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          ),
          title: Text(
            'Create API Key',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Key Name',
                hintText: 'e.g. External Mail',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(context);
                try {
                  final navigator = Navigator.of(context);
                  final repo = ref.read(apiKeyRepositoryProvider);
                  final created = await repo.createApiKey(
                    name: nameController.text.trim(),
                  );
                  final rawKey = created['raw_key']?.toString();
                  ref.read(snackbarServiceProvider).showSuccess('API key created successfully');
                  _loadKeys();
                  if (rawKey != null && mounted) {
                    await showDialog(
                      context: navigator.context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                        ),
                        title: Text(
                          'Secret Key',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                        content: SelectableText(rawKey),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e) {
                  ref.read(snackbarServiceProvider).showError('Failed to create API key: $e');
                }
              },
              child: const Text('Create'),
            ),
          ],
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
          'API Key Management',
          style: GoogleFonts.inter(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKeys,
          ),
          TextButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add),
            label: const Text('New Key'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _keys.isEmpty
              ? Center(
                  child: Text(
                    'No API keys have been created yet.',
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
                        itemCount: _keys.length,
                        itemBuilder: (context, index) {
                          final key = _keys[index];
                          final name = key['name']?.toString() ?? 'Untitled';
                          final prefix = key['key_prefix']?.toString() ?? '';
                          final active = key['is_active'] as bool? ?? false;
                          final expiresAt = key['expires_at']?.toString();
                          final lastUsedAt = key['last_used_at']?.toString();

                          return Card(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(DesignTokens.spaceL),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: DesignTokens.fontM,
                                          ),
                                        ),
                                      ),
                                      Chip(
                                        label: Text(active ? 'Active' : 'Inactive'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Prefix: $prefix'),
                                  if (expiresAt != null) Text('Expires: $expiresAt'),
                                  if (lastUsedAt != null) Text('Last used: $lastUsedAt'),
                                ],
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
