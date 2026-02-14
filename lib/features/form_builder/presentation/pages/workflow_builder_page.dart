import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/workflow_controller.dart';
import '../../domain/entities/workflow.dart';
import '../../domain/entities/workflow_enums.dart';
import '../../domain/entities/workflow_step.dart';

/// Workflow Builder Page.
///
/// Provides a visual interface for creating and editing workflow definitions.
class WorkflowBuilderPage extends ConsumerStatefulWidget {
  final String formId;
  final String? workflowId;

  const WorkflowBuilderPage({super.key, required this.formId, this.workflowId});

  @override
  ConsumerState<WorkflowBuilderPage> createState() =>
      _WorkflowBuilderPageState();
}

class _WorkflowBuilderPageState extends ConsumerState<WorkflowBuilderPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stepNameController = TextEditingController();
  final _assigneeController = TextEditingController();

  bool _isLoading = false;
  Workflow? _currentWorkflow;

  @override
  void initState() {
    super.initState();
    _loadWorkflow();
  }

  Future<void> _loadWorkflow() async {
    setState(() => _isLoading = true);
    try {
      if (widget.workflowId != null) {
        final workflow = await ref
            .read(workflowControllerProvider.notifier)
            .getWorkflow(widget.workflowId!);
        if (!mounted) return;
        _currentWorkflow = workflow;
        _nameController.text = _currentWorkflow!.name;
        _descriptionController.text = _currentWorkflow!.description ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to load workflow: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createWorkflow() async {
    if (_nameController.text.isEmpty) {
      _showError('Please enter a workflow name');
      return;
    }

    try {
      final workflow = await ref
          .read(workflowControllerProvider.notifier)
          .createWorkflow(
            formId: widget.formId,
            name: _nameController.text,
            description: _descriptionController.text,
          );
      if (!mounted) return;
      setState(() => _currentWorkflow = workflow);
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to create workflow: $e');
    }
  }

  Future<void> _addStep(WorkflowStepType type) async {
    if (_stepNameController.text.isEmpty) {
      _showError('Please enter a step name');
      return;
    }
    if (_currentWorkflow == null) {
      _showError('Please create or load a workflow first');
      return;
    }

    try {
      await ref
          .read(workflowControllerProvider.notifier)
          .addStep(
            _currentWorkflow!.id,
            name: _stepNameController.text,
            type: type,
            assigneeId: _assigneeController.text.isNotEmpty
                ? _assigneeController.text
                : null,
          );
      if (!mounted) return;
      _stepNameController.clear();
      _assigneeController.clear();
      await _loadWorkflow();
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to add step: $e');
    }
  }

  Future<void> _deleteStep(String stepId) async {
    if (_currentWorkflow == null) return;

    try {
      await ref
          .read(workflowControllerProvider.notifier)
          .removeStep(_currentWorkflow!.id, stepId);
      if (!mounted) return;
      await _loadWorkflow();
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to delete step: $e');
    }
  }

  Future<void> _activateWorkflow() async {
    if (_currentWorkflow == null) return;

    try {
      await ref
          .read(workflowControllerProvider.notifier)
          .activateWorkflow(_currentWorkflow!.id);
      if (!mounted) return;
      await _loadWorkflow();
      if (!mounted) return;
      _showSuccess('Workflow activated successfully');
    } catch (e) {
      if (!mounted) return;
      _showError('Failed to activate workflow: $e');
    }
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
    ref.watch(workflowControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentWorkflow?.name ?? 'Workflow Builder'),
        actions: [
          if (_currentWorkflow != null)
            TextButton.icon(
              onPressed: _currentWorkflow!.status == WorkflowStatus.draft
                  ? _activateWorkflow
                  : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Activate'),
            ),
          TextButton.icon(
            onPressed: _currentWorkflow != null ? _createWorkflow : null,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWorkflowInfo(),
                  const SizedBox(height: 24),
                  _buildStepPalette(),
                  const SizedBox(height: 24),
                  _buildWorkflowCanvas(),
                  const SizedBox(height: 24),
                  _buildWorkflowList(),
                ],
              ),
            ),
    );
  }

  Widget _buildWorkflowInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workflow Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workflow Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _currentWorkflow == null ? _createWorkflow : null,
              child: Text(
                _currentWorkflow == null
                    ? 'Create Workflow'
                    : 'Update Workflow',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepPalette() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Step', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _stepNameController,
              decoration: const InputDecoration(
                labelText: 'Step Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _assigneeController,
              decoration: const InputDecoration(
                labelText: 'Assignee (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _addStep(WorkflowStepType.start),
                  icon: const Icon(Icons.play_circle),
                  label: const Text('Start'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addStep(WorkflowStepType.approval),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Approval'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addStep(WorkflowStepType.automation),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Automation'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addStep(WorkflowStepType.condition),
                  icon: const Icon(Icons.call_split),
                  label: const Text('Condition'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addStep(WorkflowStepType.end),
                  icon: const Icon(Icons.stop_circle),
                  label: const Text('End'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowCanvas() {
    final steps = _currentWorkflow?.steps ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workflow Steps',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (_currentWorkflow != null)
                  Chip(
                    label: Text(_currentWorkflow!.status.name.toUpperCase()),
                    backgroundColor: _getStatusColor(_currentWorkflow!.status),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (steps.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No steps added yet. Add steps from the palette above.',
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return _buildStepItem(step, index);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(WorkflowStep step, int index) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text(step.name),
      subtitle: Text(step.type.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteStep(step.id),
      ),
      onTap: () => _showStepEditorDialog(step),
    );
  }

  void _showStepEditorDialog(WorkflowStep step) {
    final nameController = TextEditingController(text: step.name);
    final descriptionController = TextEditingController(text: step.description);
    final assigneeController = TextEditingController(text: step.assigneeId);
    final dueInDaysController = TextEditingController(
      text: step.dueInDays?.toString() ?? '',
    );

    bool localManual = step.requiresManualAction;
    bool localSkippable = step.skippable;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Step: ${step.type.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Step Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: assigneeController,
                decoration: const InputDecoration(
                  labelText: 'Assignee ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dueInDaysController,
                decoration: const InputDecoration(
                  labelText: 'Due In Days',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: const Text('Requires Manual Action'),
                        value: localManual,
                        onChanged: (value) {
                          setDialogState(() {
                            localManual = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Skippable'),
                        value: localSkippable,
                        onChanged: (value) {
                          setDialogState(() {
                            localSkippable = value ?? false;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_currentWorkflow == null) return;

              final updatedStep = step.copyWith(
                name: nameController.text,
                description: descriptionController.text,
                assigneeId: assigneeController.text.isNotEmpty
                    ? assigneeController.text
                    : null,
                dueInDays: int.tryParse(dueInDaysController.text),
                requiresManualAction: localManual,
                skippable: localSkippable,
              );

              try {
                await ref
                    .read(workflowControllerProvider.notifier)
                    .updateStep(_currentWorkflow!.id, updatedStep);
                if (context.mounted) Navigator.pop(context);
                if (!mounted) return;
                await _loadWorkflow();
              } catch (e) {
                if (!mounted) return;
                _showError('Failed to update step: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowList() {
    final workflows = ref.watch(workflowControllerProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Workflows',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (workflows.isEmpty)
              const Text('No workflows found for this form.')
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: workflows.length,
                itemBuilder: (context, index) {
                  final workflow = workflows[index];
                  return ListTile(
                    title: Text(workflow.name),
                    subtitle: Text(workflow.status.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.push(
                              '/forms/${widget.formId}/workflows/${workflow.id}',
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await ref
                                .read(workflowControllerProvider.notifier)
                                .deleteWorkflow(workflow.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(WorkflowStatus status) {
    switch (status) {
      case WorkflowStatus.active:
        return Colors.green;
      case WorkflowStatus.paused:
        return Colors.orange;
      case WorkflowStatus.draft:
        return Colors.grey;
      case WorkflowStatus.completed:
        return Colors.blue;
      case WorkflowStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stepNameController.dispose();
    _assigneeController.dispose();
    super.dispose();
  }
}
