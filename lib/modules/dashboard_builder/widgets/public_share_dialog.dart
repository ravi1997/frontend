import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../models/dashboard_models.dart';

class PublicShareDialog extends ConsumerStatefulWidget {
  final DashboardModel dashboard;
  final Function(DashboardModel)? onDashboardUpdated;

  const PublicShareDialog({
    Key? key,
    required this.dashboard,
    this.onDashboardUpdated,
  }) : super(key: key);

  @override
  _PublicShareDialogState createState() => _PublicShareDialogState();
}

class _PublicShareDialogState extends ConsumerState<PublicShareDialog> {
  bool _isPublic = false;
  String? _publicToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isPublic = widget.dashboard.isPublic;
    _publicToken = widget.dashboard.publicToken;
  }

  Future<void> _togglePublicSharing() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedDashboard = widget.dashboard.copyWith(
        isPublic: !_isPublic,
        publicToken: !_isPublic ? _generatePublicToken() : null,
      );
      
      widget.onDashboardUpdated?.call(updatedDashboard);
      
      setState(() {
        _isPublic = !_isPublic;
        _publicToken = updatedDashboard.publicToken;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isPublic ? 'Dashboard is now public' : 'Dashboard is now private'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update sharing settings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _generatePublicToken() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(16, (index) => chars[random % chars.length]).join();
  }

  void _copyPublicLink() {
    if (_publicToken == null) return;
    
    final link = 'https://yourdomain.com/dashboard/public/$_publicToken';
    Share.share(link, subject: 'Public Dashboard: ${widget.dashboard.name}');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Public Sharing'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Public Toggle
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Make Public',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Anyone with the link can view this dashboard',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isPublic,
                  onChanged: _isLoading ? null : (value) => _togglePublicSharing(),
                ),
              ],
            ),
            
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ] else if (_isPublic && _publicToken != null) ...[
              const SizedBox(height: 24),
              
              // Public Link Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.link,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Public Link',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Link Display
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'https://yourdomain.com/dashboard/public/$_publicToken',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 16),
                            onPressed: _copyPublicLink,
                            tooltip: 'Copy Link',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Share Options
              Text(
                'Share Options',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy Link'),
                      onPressed: _copyPublicLink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      onPressed: _copyPublicLink,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Warning
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Public dashboards are visible to anyone with the link. Make sure you want to share this data.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class PublicShareButton extends ConsumerWidget {
  final DashboardModel dashboard;
  final Function(DashboardModel)? onDashboardUpdated;

  const PublicShareButton({
    Key? key,
    required this.dashboard,
    this.onDashboardUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        dashboard.isPublic ? Icons.public : Icons.public_off,
        color: dashboard.isPublic ? Colors.green : Colors.grey,
      ),
      tooltip: dashboard.isPublic ? 'Public Dashboard' : 'Make Public',
      onPressed: () => _showShareDialog(context),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PublicShareDialog(
        dashboard: dashboard,
        onDashboardUpdated: onDashboardUpdated,
      ),
    );
  }
}

class PublicDashboardPage extends ConsumerWidget {
  final String publicToken;

  const PublicDashboardPage({
    Key? key,
    required this.publicToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FutureBuilder<DashboardModel?>(
        future: _fetchPublicDashboard(publicToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return _buildErrorState();
          }
          
          final dashboard = snapshot.data!;
          
          return _buildDashboardView(dashboard);
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Dashboard Not Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This dashboard may be private or the link is invalid.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardView(DashboardModel dashboard) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboard.name),
        actions: [
          if (dashboard.description != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showDashboardInfo(context, dashboard),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: dashboard.canvas.backgroundColor,
        ),
        child: Stack(
          children: [
            // Dashboard widgets would be rendered here
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Public Dashboard',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dashboard.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (dashboard.description != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        dashboard.description!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDashboardInfo(BuildContext context, DashboardModel dashboard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dashboard.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dashboard.description != null) ...[
              Text(
                dashboard.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Created: ${_formatDate(dashboard.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Last Updated: ${_formatDate(dashboard.updatedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<DashboardModel?> _fetchPublicDashboard(String publicToken) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would fetch the dashboard from the API
    // For now, return null to simulate "not found"
    return null;
  }
}