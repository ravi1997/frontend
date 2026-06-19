"""
lib/modules/analysis_coder/models/analysis_models.dart
Data models for the analysis coder.
"""

import 'package:json_annotation/json_annotation.dart';

part 'analysis_models.g.dart';

@JsonSerializable()
class Analysis {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final List<String> linkedFormIds;
  final List<String> executionModes;
  final String? schedule;
  final int reactiveDebounceMs;
  final AnalysisGraph graph;
  final String? lastRunId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Analysis({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.linkedFormIds,
    required this.executionModes,
    this.schedule,
    required this.reactiveDebounceMs,
    required this.graph,
    this.lastRunId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory Analysis.fromJson(Map<String, dynamic> json) => _$AnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisToJson(this);
}

@JsonSerializable()
class AnalysisGraph {
  final List<AnalysisNode> nodes;
  final List<AnalysisEdge> edges;
  
  AnalysisGraph({
    required this.nodes,
    required this.edges,
  });
  
  factory AnalysisGraph.fromJson(Map<String, dynamic> json) => _$AnalysisGraphFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisGraphToJson(this);
}

@JsonSerializable()
class AnalysisNode {
  final String id;
  final String nodeType;
  final String name;
  final String? description;
  final Map<String, dynamic> config;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;
  final Map<String, double> position;
  
  AnalysisNode({
    required this.id,
    required this.nodeType,
    required this.name,
    this.description,
    required this.config,
    required this.inputPorts,
    required this.outputPorts,
    required this.position,
  });
  
  factory AnalysisNode.fromJson(Map<String, dynamic> json) => _$AnalysisNodeFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisNodeToJson(this);
}

@JsonSerializable()
class NodePort {
  final String id;
  final String name;
  final String dataType;
  final String? description;
  final bool isRequired;
  final dynamic defaultValue;
  
  NodePort({
    required this.id,
    required this.name,
    required this.dataType,
    this.description,
    required this.isRequired,
    this.defaultValue,
  });
  
  factory NodePort.fromJson(Map<String, dynamic> json) => _$NodePortFromJson(json);
  Map<String, dynamic> toJson() => _$NodePortToJson(this);
}

@JsonSerializable()
class AnalysisEdge {
  final String source;
  final String target;
  final String sourcePort;
  final String targetPort;
  
  AnalysisEdge({
    required this.source,
    required this.target,
    required this.sourcePort,
    required this.targetPort,
  });
  
  factory AnalysisEdge.fromJson(Map<String, dynamic> json) => _$AnalysisEdgeFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisEdgeToJson(this);
}

@JsonSerializable()
class AnalysisRun {
  final String id;
  final String analysisId;
  final String trigger;
  final String? triggeredBy;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? executionTimeSeconds;
  final Map<String, dynamic> nodeStatuses;
  final String? errorSummary;
  final DateTime createdAt;
  
  AnalysisRun({
    required this.id,
    required this.analysisId,
    required this.trigger,
    this.triggeredBy,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.executionTimeSeconds,
    required this.nodeStatuses,
    this.errorSummary,
    required this.createdAt,
  });
  
  factory AnalysisRun.fromJson(Map<String, dynamic> json) => _$AnalysisRunFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisRunToJson(this);
}

@JsonSerializable()
class AnalysisResult {
  final String id;
  final String analysisId;
  final String runId;
  final String nodeId;
  final String outputType;
  final Map<String, dynamic> data;
  final int? rowCount;
  final List<Map<String, dynamic>> columnDefinitions;
  final DateTime createdAt;
  
  AnalysisResult({
    required this.id,
    required this.analysisId,
    required this.runId,
    required this.nodeId,
    required this.outputType,
    required this.data,
    this.rowCount,
    required this.columnDefinitions,
    required this.createdAt,
  });
  
  factory AnalysisResult.fromJson(Map<String, dynamic> json) => _$AnalysisResultFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisResultToJson(this);
}

@JsonSerializable()
class AnalysisExport {
  final String id;
  final String analysisId;
  final String? runId;
  final String format;
  final List<String> nodeIds;
  final String? filePath;
  final int? fileSizeBytes;
  final String status;
  final DateTime createdAt;
  final DateTime? expiresAt;
  
  AnalysisExport({
    required this.id,
    required this.analysisId,
    this.runId,
    required this.format,
    required this.nodeIds,
    this.filePath,
    this.fileSizeBytes,
    required this.status,
    required this.createdAt,
    this.expiresAt,
  });
  
  factory AnalysisExport.fromJson(Map<String, dynamic> json) => _$AnalysisExportFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisExportToJson(this);
}

@JsonSerializable()
class NodeDefinition {
  final String type;
  final String category;
  final String name;
  final String description;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;
  final Map<String, dynamic> defaultConfig;
  final String icon;
  final Color color;
  
  NodeDefinition({
    required this.type,
    required this.category,
    required this.name,
    required this.description,
    required this.inputPorts,
    required this.outputPorts,
    required this.defaultConfig,
    required this.icon,
    required this.color,
  });
  
  factory NodeDefinition.fromJson(Map<String, dynamic> json) => _$NodeDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$NodeDefinitionToJson(this);
}

class NodeLibrary {
  static const List<NodeDefinition> nodes = [
    // Data Sources
    NodeDefinition(
      type: 'form_responses',
      category: 'Data Sources',
      name: 'Form Responses',
      description: 'Load responses from a form',
      inputPorts: [],
      outputPorts: [
        NodePort(id: 'output', name: 'Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'form_id': ''},
      icon: '📊',
      color: Colors.blue,
    ),
    NodeDefinition(
      type: 'csv_upload',
      category: 'Data Sources',
      name: 'CSV Upload',
      description: 'Load data from a CSV file',
      inputPorts: [],
      outputPorts: [
        NodePort(id: 'output', name: 'Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'file_path': ''},
      icon: '📄',
      color: Colors.green,
    ),
    NodeDefinition(
      type: 'manual_data_entry',
      category: 'Data Sources',
      name: 'Manual Data Entry',
      description: 'Enter data manually',
      inputPorts: [],
      outputPorts: [
        NodePort(id: 'output', name: 'Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'data': [], 'columns': []},
      icon: '✏️',
      color: Colors.orange,
    ),
    NodeDefinition(
      type: 'cross_form_join',
      category: 'Data Sources',
      name: 'Cross Form Join',
      description: 'Join data from multiple forms',
      inputPorts: [],
      outputPorts: [
        NodePort(id: 'output', name: 'Joined Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'form_ids': [], 'join_key': 'id'},
      icon: '🔗',
      color: Colors.purple,
    ),
    NodeDefinition(
      type: 'external_api_fetch',
      category: 'Data Sources',
      name: 'External API',
      description: 'Fetch data from external API',
      inputPorts: [],
      outputPorts: [
        NodePort(id: 'output', name: 'API Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'url': '', 'method': 'GET'},
      icon: '🌐',
      color: Colors.teal,
    ),
    
    // Transforms
    NodeDefinition(
      type: 'filter',
      category: 'Transforms',
      name: 'Filter',
      description: 'Filter rows based on conditions',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Filtered Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'conditions': []},
      icon: '🔍',
      color: Colors.indigo,
    ),
    NodeDefinition(
      type: 'sort',
      category: 'Transforms',
      name: 'Sort',
      description: 'Sort rows by column values',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Sorted Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'sort_fields': []},
      icon: '📊',
      color: Colors.brown,
    ),
    NodeDefinition(
      type: 'group_by',
      category: 'Transforms',
      name: 'Group By',
      description: 'Group rows and apply aggregations',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Grouped Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'group_fields': [], 'aggregations': []},
      icon: '📈',
      color: Colors.pink,
    ),
    NodeDefinition(
      type: 'join',
      category: 'Transforms',
      name: 'Join',
      description: 'Join two datasets',
      inputPorts: [
        NodePort(id: 'left', name: 'Left Table', dataType: 'table', isRequired: true),
        NodePort(id: 'right', name: 'Right Table', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Joined Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'join_type': 'inner', 'left_key': '', 'right_key': ''},
      icon: '🔗',
      color: Colors.deepPurple,
    ),
    NodeDefinition(
      type: 'calculate_column',
      category: 'Transforms',
      name: 'Calculate Column',
      description: 'Add calculated column',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Data with Calculations', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'calculations': []},
      icon: '🧮',
      color: Colors.amber,
    ),
    NodeDefinition(
      type: 'pivot',
      category: 'Transforms',
      name: 'Pivot',
      description: 'Pivot table transformation',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Pivoted Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'index_field': '', 'columns_field': '', 'values_field': ''},
      icon: '🔄',
      color: Colors.cyan,
    ),
    NodeDefinition(
      type: 'unpivot',
      category: 'Transforms',
      name: 'Unpivot',
      description: 'Unpivot table transformation',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Unpivoted Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'index_fields': [], 'value_fields': []},
      icon: '📤',
      color: Colors.lime,
    ),
    NodeDefinition(
      type: 'rename_columns',
      category: 'Transforms',
      name: 'Rename Columns',
      description: 'Rename table columns',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Data with Renamed Columns', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'column_mappings': {}},
      icon: '✏️',
      color: Colors.orange,
    ),
    NodeDefinition(
      type: 'select_columns',
      category: 'Transforms',
      name: 'Select Columns',
      description: 'Select specific columns',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Selected Columns', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'selected_columns': []},
      icon: '📋',
      color: Colors.blueGrey,
    ),
    NodeDefinition(
      type: 'deduplicate',
      category: 'Transforms',
      name: 'Deduplicate',
      description: 'Remove duplicate rows',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Deduplicated Data', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'deduplicate_fields': []},
      icon: '🔄',
      color: Colors.red,
    ),
    NodeDefinition(
      type: 'fill_missing',
      category: 'Transforms',
      name: 'Fill Missing',
      description: 'Fill missing values',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Data with Filled Values', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'fill_rules': []},
      icon: '🔧',
      color: Colors.green,
    ),
    
    // Aggregations
    NodeDefinition(
      type: 'count',
      category: 'Aggregations',
      name: 'Count',
      description: 'Count rows or values',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Count', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '🔢',
      color: Colors.blue,
    ),
    NodeDefinition(
      type: 'sum',
      category: 'Aggregations',
      name: 'Sum',
      description: 'Sum numeric values',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Sum', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '➕',
      color: Colors.green,
    ),
    NodeDefinition(
      type: 'average',
      category: 'Aggregations',
      name: 'Average',
      description: 'Calculate average',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Average', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '📊',
      color: Colors.orange,
    ),
    NodeDefinition(
      type: 'min_max',
      category: 'Aggregations',
      name: 'Min/Max',
      description: 'Find minimum and maximum',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Min/Max', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '📏',
      color: Colors.purple,
    ),
    NodeDefinition(
      type: 'median',
      category: 'Aggregations',
      name: 'Median',
      description: 'Calculate median',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Median', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '📐',
      color: Colors.teal,
    ),
    NodeDefinition(
      type: 'percentile',
      category: 'Aggregations',
      name: 'Percentile',
      description: 'Calculate percentile',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Percentile', dataType: 'value', isRequired: false),
      ],
      defaultConfig: {'field': '', 'percentile': 50},
      icon: '📈',
      color: Colors.indigo,
    ),
    NodeDefinition(
      type: 'frequency',
      category: 'Aggregations',
      name: 'Frequency',
      description: 'Calculate frequency distribution',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Frequency', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'field': ''},
      icon: '📊',
      color: Colors.pink,
    ),
    NodeDefinition(
      type: 'cross_tabulation',
      category: 'Aggregations',
      name: 'Cross Tabulation',
      description: 'Create cross-tabulation table',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Cross Tab', dataType: 'table', isRequired: false),
      ],
      defaultConfig: {'row_field': '', 'column_field': '', 'value_field': ''},
      icon: '📋',
      color: Colors.brown,
    ),
    
    // Outputs
    NodeDefinition(
      type: 'table_output',
      category: 'Outputs',
      name: 'Table Output',
      description: 'Display data as table',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {},
      icon: '📋',
      color: Colors.blue,
    ),
    NodeDefinition(
      type: 'kpi_value',
      category: 'Outputs',
      name: 'KPI Value',
      description: 'Display key performance indicator',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Value', dataType: 'value', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {'format': {}},
      icon: '📊',
      color: Colors.green,
    ),
    NodeDefinition(
      type: 'bar_chart_data',
      category: 'Outputs',
      name: 'Bar Chart',
      description: 'Generate bar chart data',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {'label_field': '', 'value_field': ''},
      icon: '📊',
      color: Colors.orange,
    ),
    NodeDefinition(
      type: 'line_chart_data',
      category: 'Outputs',
      name: 'Line Chart',
      description: 'Generate line chart data',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {'x_field': '', 'y_field': ''},
      icon: '📈',
      color: Colors.purple,
    ),
    NodeDefinition(
      type: 'pie_chart_data',
      category: 'Outputs',
      name: 'Pie Chart',
      description: 'Generate pie chart data',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {'label_field': '', 'value_field': ''},
      icon: '🥧',
      color: Colors.teal,
    ),
    NodeDefinition(
      type: 'export_node',
      category: 'Outputs',
      name: 'Export',
      description: 'Export data to file',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [],
      defaultConfig: {'format': 'csv', 'filename': ''},
      icon: '💾',
      color: Colors.indigo,
    ),
    
    // LLM Analysis
    NodeDefinition(
      type: 'llm_analysis',
      category: 'LLM Analysis',
      name: 'LLM Analysis',
      description: 'Analyze data using AI/LLM',
      inputPorts: [
        NodePort(id: 'input', name: 'Input Data', dataType: 'table', isRequired: true),
      ],
      outputPorts: [
        NodePort(id: 'output', name: 'Analysis Result', dataType: 'json', isRequired: false),
      ],
      defaultConfig: {
        'provider': 'openai',
        'model_id': 'gpt-4',
        'prompt': 'Analyze the following data and provide insights:',
        'temperature': 0.7,
        'max_tokens': 1000,
        'output_format': 'json'
      },
      icon: '🤖',
      color: Colors.purple,
    ),
  ];
  
  static List<NodeDefinition> getByCategory(String category) {
    return nodes.where((node) => node.category == category).toList();
  }
  
  static NodeDefinition? getByType(String type) {
    try {
      return nodes.firstWhere((node) => node.type == type);
    } catch (e) {
      return null;
    }
  }
  
  static List<String> get categories {
    return nodes.map((node) => node.category).toSet().toList();
  }
}