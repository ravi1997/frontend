"""
lib/modules/forms/widgets/form_builder_assistant_widget.dart
Form Builder Assistant chat interface for LLM-powered form building assistance.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/form_builder_assistant_models.dart';
import '../providers/form_builder_assistant_provider.dart';

class FormBuilderAssistantWidget extends ConsumerStatefulWidget {
  final String formId;
  final String projectId;

  const FormBuilderAssistantWidget({
    super.key,
    required this.formId,
    required this.projectId,
  });

  @override
  ConsumerState<FormBuilderAssistantWidget> createState() => _FormBuilderAssistantWidgetState();
}

class _FormBuilderAssistantWidgetState extends ConsumerState<FormBuilderAssistantWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    ref.read(formBuilderAssistantProvider(widget.formId).notifier).sendMessage(message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final assistantState = ref.watch(formBuilderAssistantProvider(widget.formId));
    final isTyping = assistantState.isProcessing;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Form Builder Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'AI-powered form building assistance',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close assistant',
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: _buildMessagesList(assistantState),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                // Quick actions
                _buildQuickActions(),
                const SizedBox(height: 12),
                
                // Message input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything about building your form...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: isTyping ? null : _sendMessage,
                          ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(FormBuilderAssistantState assistantState) {
    if (assistantState.messages.isEmpty) {
      return _buildWelcomeMessage();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: assistantState.messages.length,
      itemBuilder: (context, index) {
        final message = assistantState.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.psychology,
                color: Colors.purple[600],
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hello! I\'m your Form Builder Assistant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I can help you build better forms faster. Ask me anything!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSuggestionChip('Add a contact form'),
                _buildSuggestionChip('Create a survey'),
                _buildSuggestionChip('Best practices for forms'),
                _buildSuggestionChip('Add conditional logic'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _messageController.text = text;
      },
      backgroundColor: Colors.purple[50],
      labelStyle: TextStyle(color: Colors.purple[700]),
    );
  }

  Widget _buildMessageBubble(FormBuilderAssistantMessage message) {
    final isUser = message.role == 'user';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ] else
            const SizedBox(width: 44),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.purple[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: TextStyle(
                        color: isUser ? Colors.purple[900] : Colors.black87,
                      ),
                    ),
                  if (message.actions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...message.actions.map((action) => _buildActionChip(action)),
                  ],
                  if (message.metadata?['thinking'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Thinking...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.purple[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionChip(FormBuilderAssistantAction action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ActionChip(
        label: Text(action.label),
        onPressed: () => _executeAction(action),
        backgroundColor: Colors.blue[50],
        labelStyle: TextStyle(color: Colors.blue[700]),
        avatar: Icon(_getActionIcon(action.type), size: 16),
      ),
    );
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'add_field':
        return Icons.add_circle_outline;
      case 'modify_field':
        return Icons.edit;
      case 'add_section':
        return Icons.segment;
      case 'set_theme':
        return Icons.palette;
      case 'configure_logic':
        return Icons.code;
      default:
        return Icons.play_arrow;
    }
  }

  void _executeAction(FormBuilderAssistantAction action) {
    // Execute the suggested action
    ref.read(formBuilderAssistantProvider(widget.formId).notifier).executeAction(action);
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 8,
      children: [
        _buildQuickActionButton(
          icon: Icons.add_circle_outline,
          label: 'Add Field',
          onPressed: () => _messageController.text = 'Add a text field for name',
        ),
        _buildQuickActionButton(
          icon: Icons.segment,
          label: 'Add Section',
          onPressed: () => _messageController.text = 'Create a new section',
        ),
        _buildQuickActionButton(
          icon: Icons.code,
          label: 'Add Logic',
          onPressed: () => _messageController.text = 'Add conditional logic',
        ),
        _buildQuickActionButton(
          icon: Icons.palette,
          label: 'Theme',
          onPressed: () => _messageController.text = 'Change form theme',
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}