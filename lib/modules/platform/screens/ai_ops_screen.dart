import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ai_ops_repository.dart';
import 'package:frontend/shared/widgets/snackbar.dart';

class AIOpsScreen extends ConsumerStatefulWidget {
  const AIOpsScreen({super.key});

  @override
  ConsumerState<AIOpsScreen> createState() => _AIOpsScreenState();
}

class _AIOpsScreenState extends ConsumerState<AIOpsScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _status = {};
  final _cyclesController = TextEditingController(text: '1');
  final _datasetSizeController = TextEditingController(text: '10000');
  bool _fastMode = true;
  String? _activeTaskId;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  @override
  void dispose() {
    _cyclesController.dispose();
    _datasetSizeController.dispose();
    super.dispose();
  }

  Future<void> _fetchStatus() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(aiOpsRepositoryProvider);
      final status = await repo.getLoraStatus();
      setState(() {
        _status = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ref.read(snackbarServiceProvider).showError('Failed to load status: $e');
    }
  }

  Future<void> _triggerLoop() async {
    final cycles = int.tryParse(_cyclesController.text) ?? 1;
    final size = int.tryParse(_datasetSizeController.text) ?? 10000;
    
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(aiOpsRepositoryProvider);
      final res = await repo.triggerImprovementLoop(
        cycles: cycles,
        targetDatasetSize: size,
        fast: _fastMode,
      );
      final taskId = res['task_id']?.toString();
      setState(() {
        _activeTaskId = taskId;
        _isLoading = false;
      });
      ref.read(snackbarServiceProvider).showSuccess('LoRA loop initiated successfully');
      _fetchStatus();
    } catch (e) {
      setState(() => _isLoading = false);
      ref.read(snackbarServiceProvider).showError('Failed to trigger loop: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'AI Operations Hub (LoRA)',
          style: GoogleFonts.inter(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF475569)),
            onPressed: _fetchStatus,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusOverview(),
                  const SizedBox(height: 24),
                  _buildControlsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusOverview() {
    final cycle = _status['cycle'] ?? 'N/A';
    final lastStarted = _status['last_cycle_started_at'] ?? 'Never';
    final lastFinished = _status['last_cycle_finished_at'] ?? 'Never';
    final exitCode = _status['last_training_exit_code'];
    final targetSize = _status['target_dataset_size'] ?? 'N/A';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pipeline Status Overview',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF0F172A),
              ),
            ),
            const Divider(height: 24),
            _buildStatusItem('Current Active Cycle', '$cycle'),
            _buildStatusItem('Target Dataset Size', '$targetSize'),
            _buildStatusItem('Last Execution Started', '$lastStarted'),
            _buildStatusItem('Last Execution Finished', '$lastFinished'),
            _buildStatusItem(
              'Last Training Exit Status',
              exitCode == null
                  ? 'N/A'
                  : exitCode == 0
                      ? 'Success (0)'
                      : 'Failed ($exitCode)',
              color: exitCode == null
                  ? null
                  : exitCode == 0
                      ? const Color(0xFF166534)
                      : const Color(0xFF991B1B),
            ),
            if (_activeTaskId != null) ...[
              const Divider(height: 24),
              _buildStatusItem('Active Task Identifier', _activeTaskId!, color: const Color(0xFF4338CA)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF475569),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color ?? const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trigger LoRA Fine-Tuning Cycle',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color(0xFF0F172A),
              ),
            ),
            const Divider(height: 24),
            TextField(
              controller: _cyclesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Improvement Cycles Count',
                hintText: 'e.g. 1',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _datasetSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Dataset Size',
                hintText: 'e.g. 10000',
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                'Fast Mode (Run fast scaffold)',
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF475569)),
              ),
              value: _fastMode,
              activeThumbColor: const Color(0xFF4338CA),
              onChanged: (val) => setState(() => _fastMode = val),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _triggerLoop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4338CA),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Launch Fine-Tuning Loop',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
