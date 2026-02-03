import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/signature_controller.dart';
import '../widgets/signature_pad_widget.dart';
import '../../domain/entities/signature_request.dart';

/// Signature Request Page.
///
/// Provides UI for managing signature requests and collecting signatures.
class SignatureRequestPage extends ConsumerStatefulWidget {
  final String formId;

  const SignatureRequestPage({super.key, required this.formId});

  @override
  ConsumerState<SignatureRequestPage> createState() =>
      _SignatureRequestPageState();
}

class _SignatureRequestPageState extends ConsumerState<SignatureRequestPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;
  String? _selectedRequestId;
  String? _currentSignatureData;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(signatureControllerProvider.notifier)
          .loadRequests(widget.formId);
    } catch (e) {
      _showError('Failed to load requests: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createAndSendRequest() async {
    if (_emailController.text.isEmpty || _nameController.text.isEmpty) {
      _showError('Please enter email and name');
      return;
    }

    try {
      final request = await ref
          .read(signatureControllerProvider.notifier)
          .createRequest(
            formId: widget.formId,
            signerEmail: _emailController.text,
            signerName: _nameController.text,
            message: _messageController.text,
          );

      await ref
          .read(signatureControllerProvider.notifier)
          .sendRequest(request.id);

      _clearForm();
      _showSuccess('Signature request sent to ${_emailController.text}');
    } catch (e) {
      _showError('Failed to send request: $e');
    }
  }

  Future<void> _cancelRequest(String requestId) async {
    try {
      await ref
          .read(signatureControllerProvider.notifier)
          .cancelRequest(requestId);
      _showSuccess('Request cancelled');
    } catch (e) {
      _showError('Failed to cancel: $e');
    }
  }

  Future<void> _saveSignature() async {
    if (_selectedRequestId == null || _currentSignatureData == null) {
      _showError('Please provide a signature');
      return;
    }

    try {
      await ref
          .read(signatureControllerProvider.notifier)
          .recordSignature(
            requestId: _selectedRequestId!,
            signatureData: _currentSignatureData!,
            ipAddress: '127.0.0.1',
          );
      _showSuccess('Signature saved!');
      setState(() => _selectedRequestId = null);
    } catch (e) {
      _showError('Failed to save signature: $e');
    }
  }

  void _clearForm() {
    _emailController.clear();
    _nameController.clear();
    _messageController.clear();
    _currentSignatureData = null;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(signatureControllerProvider);
    final pending = requests
        .where((r) => r.status == SignatureRequestStatus.pending)
        .toList();
    final sent = requests
        .where((r) => r.status == SignatureRequestStatus.sent)
        .toList();
    final signed = requests
        .where((r) => r.status == SignatureRequestStatus.signed)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature Requests'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRequests),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRequestCreator(),
                  const SizedBox(height: 24),
                  _buildStatsRow(pending.length, sent.length, signed.length),
                  const SizedBox(height: 24),
                  if (_selectedRequestId != null) _buildSignaturePad(),
                  const SizedBox(height: 24),
                  _buildRequestsList('Pending', pending, Icons.pending),
                  const SizedBox(height: 16),
                  _buildRequestsList('Awaiting Signature', sent, Icons.send),
                  const SizedBox(height: 16),
                  _buildRequestsList('Completed', signed, Icons.check_circle),
                ],
              ),
            ),
    );
  }

  Widget _buildRequestCreator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Signature',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Signer Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Signer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _createAndSendRequest,
                icon: const Icon(Icons.send),
                label: const Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int pending, int sent, int signed) {
    return Row(
      children: [
        _buildStatCard('Pending', pending, Colors.orange),
        const SizedBox(width: 12),
        _buildStatCard('Sent', sent, Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard('Signed', signed, Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$count', style: TextStyle(fontSize: 24, color: color)),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignaturePad() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign Below', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            SignaturePadWidget(
              onSigned: (data) {
                setState(() => _currentSignatureData = data);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _selectedRequestId = null);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentSignatureData?.isNotEmpty == true
                        ? _saveSignature
                        : null,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(
    String title,
    List<SignatureRequest> requests,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('${requests.length}'),
              ],
            ),
            const SizedBox(height: 16),
            if (requests.isEmpty)
              const Text('No requests')
            else
              ...requests.map((request) => _buildRequestCard(request)),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(SignatureRequest request) {
    return ListTile(
      title: Text(request.signerName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(request.signerEmail),
          Text(
            'Created: ${request.createdAt.toString().split('.').first}',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
      trailing: request.status == SignatureRequestStatus.pending
          ? IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _cancelRequest(request.id),
            )
          : request.status == SignatureRequestStatus.signed
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        if (request.status == SignatureRequestStatus.sent) {
          setState(() => _selectedRequestId = request.id);
        }
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
