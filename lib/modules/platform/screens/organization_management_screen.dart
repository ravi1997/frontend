import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../organization_repository.dart';
import 'package:frontend/core/services/snackbar_service.dart';

class OrganizationManagementScreen extends ConsumerStatefulWidget {
  const OrganizationManagementScreen({super.key});

  @override
  ConsumerState<OrganizationManagementScreen> createState() => _OrganizationManagementScreenState();
}

class _OrganizationManagementScreenState extends ConsumerState<OrganizationManagementScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _orgs = [];
  Map<String, dynamic>? _selectedOrgStats;
  String? _selectedOrgIdForStats;
  bool _isLoadingStats = false;

  @override
  void initState() {
    super.initState();
    _fetchOrgs();
  }

  Future<void> _fetchOrgs() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(organizationRepositoryProvider);
      final list = await repo.listOrgs();
      setState(() {
        _orgs = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ref.read(snackbarServiceProvider).showError('Failed to fetch organizations: $e');
    }
  }

  Future<void> _toggleOrgStatus(String orgId, String currentStatus) async {
    final newStatus = currentStatus == 'active' ? 'suspended' : 'active';
    try {
      final repo = ref.read(organizationRepositoryProvider);
      await repo.updateOrgStatus(orgId, newStatus);
      ref.read(snackbarServiceProvider).showSuccess('Organization status updated successfully');
      _fetchOrgs();
      if (_selectedOrgIdForStats == orgId) {
        _fetchOrgStats(orgId);
      }
    } catch (e) {
      ref.read(snackbarServiceProvider).showError('Failed to update organization status: $e');
    }
  }

  Future<void> _fetchOrgStats(String orgId) async {
    setState(() {
      _selectedOrgIdForStats = orgId;
      _isLoadingStats = true;
      _selectedOrgStats = null;
    });
    try {
      final repo = ref.read(organizationRepositoryProvider);
      final stats = await repo.getOrgStats(orgId);
      setState(() {
        _selectedOrgStats = stats;
        _isLoadingStats = false;
      });
    } catch (e) {
      setState(() => _isLoadingStats = false);
      ref.read(snackbarServiceProvider).showError('Failed to load stats: $e');
    }
  }

  Future<void> _showCreateOrgDialog() async {
    final nameController = TextEditingController();
    final slugController = TextEditingController();
    final domainController = TextEditingController();
    final adminEmailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Create Organization',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Name',
                      hintText: 'e.g. Acme Corp',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: slugController,
                    decoration: const InputDecoration(
                      labelText: 'Slug / Domain Identifier',
                      hintText: 'e.g. acme',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: domainController,
                    decoration: const InputDecoration(
                      labelText: 'Email Domain',
                      hintText: 'e.g. acme.com',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: adminEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Admin Email',
                      hintText: 'admin@acme.com',
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  try {
                    final repo = ref.read(organizationRepositoryProvider);
                    await repo.createOrg({
                      'name': nameController.text.trim(),
                      'slug': slugController.text.trim(),
                      'domain': domainController.text.trim(),
                      'admin_email': adminEmailController.text.trim(),
                    });
                    ref.read(snackbarServiceProvider).showSuccess('Organization created successfully');
                    _fetchOrgs();
                  } catch (e) {
                    ref.read(snackbarServiceProvider).showError('Failed to create organization: $e');
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAssignAdminDialog(String orgId) async {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Assign Organization Admin',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Admin Email',
                hintText: 'admin@example.com',
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  try {
                    final repo = ref.read(organizationRepositoryProvider);
                    await repo.assignOrgAdmin(orgId, emailController.text.trim());
                    ref.read(snackbarServiceProvider).showSuccess('Admin assigned successfully');
                    _fetchOrgs();
                  } catch (e) {
                    ref.read(snackbarServiceProvider).showError('Failed to assign admin: $e');
                  }
                }
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Enterprise Organizations Manager',
          style: GoogleFonts.inter(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF475569)),
            onPressed: _fetchOrgs,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isDesktop
              ? Row(
                  children: [
                    Expanded(flex: 3, child: _buildOrgsList()),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(flex: 2, child: _buildSidePanel()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(child: _buildOrgsList()),
                    if (_selectedOrgIdForStats != null) ...[
                      const Divider(height: 1, thickness: 1),
                      SizedBox(
                        height: 300,
                        child: _buildSidePanel(),
                      ),
                    ]
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateOrgDialog,
        backgroundColor: const Color(0xFF4338CA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrgsList() {
    if (_orgs.isEmpty) {
      return Center(
        child: Text(
          'No organizations found.',
          style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _orgs.length,
      itemBuilder: (context, index) {
        final org = _orgs[index];
        final id = org['id']?.toString() ?? '';
        final name = org['name']?.toString() ?? 'Untitled';
        final slug = org['slug']?.toString() ?? '';
        final domain = org['domain']?.toString() ?? '';
        final status = org['status']?.toString() ?? 'active';
        final isSuspended = status == 'suspended';
        final isSelected = _selectedOrgIdForStats == id;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? const Color(0xFF4338CA) : const Color(0xFFE2E8F0),
              width: isSelected ? 2 : 1,
            ),
          ),
          elevation: 0,
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            title: Row(
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSuspended ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: isSuspended ? const Color(0xFF991B1B) : const Color(0xFF166534),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text('Slug: $slug | Domain: $domain', style: GoogleFonts.inter(color: const Color(0xFF64748B))),
                if (org['admin_email'] != null) ...[
                  const SizedBox(height: 4),
                  Text('Admin: ${org['admin_email']}', style: GoogleFonts.inter(color: const Color(0xFF475569), fontWeight: FontWeight.w500)),
                ]
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Assign Admin',
                  icon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF475569)),
                  onPressed: () => _showAssignAdminDialog(id),
                ),
                IconButton(
                  tooltip: isSuspended ? 'Activate' : 'Suspend',
                  icon: Icon(
                    isSuspended ? Icons.play_circle_outline : Icons.pause_circle_outline,
                    color: isSuspended ? const Color(0xFF166534) : const Color(0xFF991B1B),
                  ),
                  onPressed: () => _toggleOrgStatus(id, status),
                ),
              ],
            ),
            onTap: () => _fetchOrgStats(id),
          ),
        );
      },
    );
  }

  Widget _buildSidePanel() {
    if (_selectedOrgIdForStats == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Select an organization to view stats and quotas.',
            style: GoogleFonts.inter(color: const Color(0xFF64748B)),
          ),
        ),
      );
    }
    if (_isLoadingStats) {
      return const Center(child: CircularProgressIndicator());
    }
    final stats = _selectedOrgStats ?? {};
    final formsCount = stats['forms_count'] ?? 0;
    final submissionsCount = stats['submissions_count'] ?? 0;
    final totalUsers = stats['total_users'] ?? 0;
    final storageUsed = stats['storage_used_bytes'] ?? 0;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Organization Stats',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() {
                  _selectedOrgIdForStats = null;
                  _selectedOrgStats = null;
                }),
              )
            ],
          ),
          const Divider(height: 24),
          _buildStatRow(Icons.description_outlined, 'Total Forms', '$formsCount'),
          _buildStatRow(Icons.assignment_turned_in_outlined, 'Submissions', '$submissionsCount'),
          _buildStatRow(Icons.people_outline, 'Active Members', '$totalUsers'),
          _buildStatRow(Icons.storage_outlined, 'Storage Used', '${(storageUsed / (1024 * 1024)).toStringAsFixed(2)} MB'),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4338CA), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
