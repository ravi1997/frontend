import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportBlock {
  final String id;
  final String type; // "header", "metric", "rich_text", "chart", "table"
  Map<String, dynamic> config;

  ReportBlock({
    required this.id,
    required this.type,
    required this.config,
  });
}

class ReportBuilderPage extends StatefulWidget {
  final String projectId;

  const ReportBuilderPage({super.key, required this.projectId});

  @override
  State<ReportBuilderPage> createState() => _ReportBuilderPageState();
}

class _ReportBuilderPageState extends State<ReportBuilderPage> {
  final List<ReportBlock> _blocks = [];

  // Form Fields
  final _nameController = TextEditingController(text: 'Monthly Submission Peak Report');
  String _triggerType = 'schedule'; // 'schedule' or 'threshold'
  String _cronExpression = '0 9 * * 1';
  int _thresholdLimit = 100;

  @override
  void initState() {
    super.initState();
    // Default initial structural blocks
    _blocks.addAll([
      ReportBlock(
        id: 'block-1',
        type: 'header',
        config: {'title': 'Quarterly Operations Summary'},
      ),
      ReportBlock(
        id: 'block-2',
        type: 'metric',
        config: {'metric_id': 'Total Submissions Rate'},
      ),
      ReportBlock(
        id: 'block-3',
        type: 'rich_text',
        config: {'text': 'This automated breakdown contains performance calculations compiled directly from tenant workflows.'},
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B091B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161435),
        title: Text(
          'Automated Report Builder',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Color(0xFF10B981)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report layout saved successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left Pane: Drag-and-drop structural list using ReorderableListView
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Structure',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final block = _blocks.removeAt(oldIndex);
                          _blocks.insert(newIndex, block);
                        });
                      },
                      children: _blocks.map((block) => _buildBlockCard(block)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Right Pane: Block settings and Scheduling parameters
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF161435),
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  Text(
                    'Trigger Settings',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Report Name
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Report Name',
                      labelStyle: const TextStyle(color: Color(0xFF818CF8)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Trigger Type
                  DropdownButtonFormField<String>(
                    initialValue: _triggerType,
                    dropdownColor: const Color(0xFF161435),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Trigger Model',
                      labelStyle: const TextStyle(color: Color(0xFF818CF8)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'schedule', child: Text('Interval (CRON)')),
                      DropdownMenuItem(value: 'threshold', child: Text('Submission Count Threshold')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _triggerType = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  if (_triggerType == 'schedule')
                    TextField(
                      onChanged: (val) => _cronExpression = val,
                      controller: TextEditingController(text: _cronExpression),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'CRON Expression',
                        labelStyle: const TextStyle(color: Color(0xFF818CF8)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  else
                    TextField(
                      onChanged: (val) => _thresholdLimit = int.tryParse(val) ?? 100,
                      controller: TextEditingController(text: _thresholdLimit.toString()),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Submission Threshold Limit',
                        labelStyle: const TextStyle(color: Color(0xFF818CF8)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Block adder buttons
                  Text(
                    'Add Blocks',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBlockAdder('Header', 'header', Icons.title, const Color(0xFFEF4444)),
                      _buildBlockAdder('Metric', 'metric', Icons.analytics, const Color(0xFF3B82F6)),
                      _buildBlockAdder('Rich Text', 'rich_text', Icons.text_snippet, const Color(0xFFF59E0B)),
                      _buildBlockAdder('Chart', 'chart', Icons.bar_chart, const Color(0xFF10B981)),
                      _buildBlockAdder('Table', 'table', Icons.table_chart, const Color(0xFF8B5CF6)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockCard(ReportBlock block) {
    IconData icon;
    Color color;
    String details = '';

    if (block.type == 'header') {
      icon = Icons.title;
      color = const Color(0xFFEF4444);
      details = block.config['title'] ?? 'Title';
    } else if (block.type == 'metric') {
      icon = Icons.analytics;
      color = const Color(0xFF3B82F6);
      details = block.config['metric_id'] ?? 'Metric variable';
    } else if (block.type == 'rich_text') {
      icon = Icons.text_snippet;
      color = const Color(0xFFF59E0B);
      details = block.config['text'] ?? 'Description text';
    } else if (block.type == 'chart') {
      icon = Icons.bar_chart;
      color = const Color(0xFF10B981);
      details = 'Interactive Chart.js Graph';
    } else {
      icon = Icons.table_chart;
      color = const Color(0xFF8B5CF6);
      details = 'Grid Columns mapping summary';
    }

    return Card(
      key: ValueKey(block.id),
      color: const Color(0xFF1E1B4B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          block.type.toUpperCase(),
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          details,
          style: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 11),
        ),
        trailing: const Icon(Icons.drag_handle, color: Color(0xFF818CF8)),
      ),
    );
  }

  Widget _buildBlockAdder(String name, String type, IconData icon, Color color) {
    return ActionChip(
      backgroundColor: const Color(0xFF1E1B4B),
      side: const BorderSide(color: Color(0xFF4F46E5)),
      avatar: Icon(icon, color: color, size: 16),
      label: Text(name, style: const TextStyle(color: Colors.white, fontSize: 11)),
      onPressed: () {
        setState(() {
          final nextId = 'block-${_blocks.length + 1}';
          _blocks.add(ReportBlock(
            id: nextId,
            type: type,
            config: type == 'header'
                ? {'title': 'New Header Block'}
                : type == 'metric'
                    ? {'metric_id': 'Calculated Metric'}
                    : type == 'rich_text'
                        ? {'text': 'Enter description...'}
                        : {},
          ));
        });
      },
    );
  }
}
