// lib/modules/analysis_coder/models/analysis_models.dart
// Lightweight analysis coder models used by the screen and providers.

import 'node_types.dart';

class Analysis {
  final String id;
  final String orgId;
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
  final String createdBy;

  Analysis({
    required this.id,
    required this.orgId,
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
    required this.createdBy,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      id: json['id'] ?? '',
      orgId: json['org_id'] ?? '',
      projectId: json['project_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      linkedFormIds: List<String>.from(json['linked_form_ids'] ?? const []),
      executionModes: List<String>.from(json['execution_modes'] ?? const []),
      schedule: json['schedule'],
      reactiveDebounceMs: json['reactive_debounce_ms'] ?? 1000,
      graph: AnalysisGraph.fromJson(json['graph'] ?? {'nodes': [], 'edges': []}),
      lastRunId: json['last_run_id'],
      status: json['status'] ?? 'idle',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      createdBy: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'name': name,
      'description': description,
      'linked_form_ids': linkedFormIds,
      'execution_modes': executionModes,
      'schedule': schedule,
      'reactive_debounce_ms': reactiveDebounceMs,
      'graph': graph.toJson(),
    };
  }
}

class AnalysisGraph {
  final List<AnalysisNode> nodes;
  final List<AnalysisEdge> edges;

  AnalysisGraph({required this.nodes, required this.edges});

  factory AnalysisGraph.fromJson(Map<String, dynamic> json) {
    var nodesList = json['nodes'] as List? ?? [];
    var edgesList = json['edges'] as List? ?? [];
    return AnalysisGraph(
      nodes: nodesList.map((e) => AnalysisNode.fromJson(Map<String, dynamic>.from(e))).toList(),
      edges: edgesList.map((e) => AnalysisEdge.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((e) => e.toJson()).toList(),
      'edges': edges.map((e) => e.toJson()).toList(),
    };
  }
}

class AnalysisNode {
  final String id;
  final String nodeType;
  final String name;
  final String description;
  final Map<String, dynamic> config;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;
  final Map<String, double> position;

  AnalysisNode({
    required this.id,
    required this.nodeType,
    required this.name,
    required this.description,
    required this.config,
    required this.inputPorts,
    required this.outputPorts,
    required this.position,
  });

  factory AnalysisNode.fromJson(Map<String, dynamic> json) {
    var inputList = json['input_ports'] as List? ?? [];
    var outputList = json['output_ports'] as List? ?? [];
    
    Map<String, double> posMap = {};
    if (json['position'] is Map) {
      json['position'].forEach((k, v) {
        if (v is num) posMap[k.toString()] = v.toDouble();
      });
    }

    return AnalysisNode(
      id: json['id'] ?? '',
      nodeType: json['node_type'] ?? json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      config: Map<String, dynamic>.from(json['config'] ?? const {}),
      inputPorts: inputList.map((e) => NodePort.fromJson(Map<String, dynamic>.from(e))).toList(),
      outputPorts: outputList.map((e) => NodePort.fromJson(Map<String, dynamic>.from(e))).toList(),
      position: posMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'node_type': nodeType,
      'name': name,
      'description': description,
      'config': config,
      'input_ports': inputPorts.map((e) => e.toJson()).toList(),
      'output_ports': outputPorts.map((e) => e.toJson()).toList(),
      'position': position,
    };
  }
}

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

  factory NodePort.fromJson(Map<String, dynamic> json) {
    return NodePort(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      dataType: json['data_type'] ?? '',
      description: json['description'],
      isRequired: json['is_required'] ?? true,
      defaultValue: json['default_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data_type': dataType,
      'description': description,
      'is_required': isRequired,
      'default_value': defaultValue,
    };
  }
}

class NodeProperty {
  final String key;
  final String label;
  final String type;
  final String? description;
  final bool isRequired;
  final dynamic defaultValue;
  final List<dynamic>? options;
  final String? group;

  NodeProperty({
    required this.key,
    required this.label,
    required this.type,
    this.description,
    this.isRequired = false,
    this.defaultValue,
    this.options,
    this.group,
  });
}

class AnalysisEdge {
  final String id;
  final String source;
  final String target;
  final String sourcePort;
  final String targetPort;

  AnalysisEdge({
    required this.id,
    required this.source,
    required this.target,
    required this.sourcePort,
    required this.targetPort,
  });

  factory AnalysisEdge.fromJson(Map<String, dynamic> json) {
    return AnalysisEdge(
      id: json['id'] ?? '',
      source: json['source'] ?? '',
      target: json['target'] ?? '',
      sourcePort: json['source_port'] ?? 'output',
      targetPort: json['target_port'] ?? 'input',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'target': target,
      'source_port': sourcePort,
      'target_port': targetPort,
    };
  }
}

class AnalysisRun {
  final String id;
  final String analysisId;
  final String status;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final Map<String, dynamic> nodeStatuses;
  final String? errorSummary;

  AnalysisRun({
    required this.id,
    required this.analysisId,
    required this.status,
    this.startedAt,
    this.finishedAt,
    required this.nodeStatuses,
    this.errorSummary,
  });

  factory AnalysisRun.fromJson(Map<String, dynamic> json) {
    return AnalysisRun(
      id: json['id'] ?? '',
      analysisId: json['analysis_id'] ?? '',
      status: json['status'] ?? 'pending',
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      finishedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      nodeStatuses: json['node_statuses'] ?? {},
      errorSummary: json['error_summary'],
    );
  }
}

class AnalysisResult {
  final String id;
  final String analysisId;
  final String runId;
  final String nodeId;
  final String outputType;
  final Map<String, dynamic> data;
  final int? rowCount;
  final List<dynamic> columnDefinitions;

  AnalysisResult({
    required this.id,
    required this.analysisId,
    required this.runId,
    required this.nodeId,
    required this.outputType,
    required this.data,
    this.rowCount,
    required this.columnDefinitions,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      id: json['id'] ?? '',
      analysisId: json['analysis_id'] ?? '',
      runId: json['run_id'] ?? '',
      nodeId: json['node_id'] ?? '',
      outputType: json['output_type'] ?? '',
      data: json['data'] ?? {},
      rowCount: json['row_count'],
      columnDefinitions: json['column_definitions'] ?? [],
    );
  }
}

class NodeDefinition {
  final String type;
  final String name;
  final String description;
  final NodeCategory category;
  final Map<String, dynamic> defaultConfig;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;
  final List<NodeProperty> properties;

  NodeDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.category,
    required this.defaultConfig,
    required this.inputPorts,
    required this.outputPorts,
    required this.properties,
  });
}

class NodeLibrary {
  static List<NodeDefinition> getNodes() {
    return [
      // Data Sources
      NodeDefinition(
        type: 'form_responses',
        name: 'Form Responses',
        description: 'Read responses from a specific form',
        category: NodeCategory.dataSource,
        defaultConfig: {'form_id': ''},
        inputPorts: [],
        outputPorts: [NodePort(id: 'output', name: 'Responses', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'form_id', label: 'Form ID', type: 'string', isRequired: true, description: 'Select the source form'),
        ],
      ),
      NodeDefinition(
        type: 'csv_upload',
        name: 'CSV Upload',
        description: 'Upload local CSV data file',
        category: NodeCategory.dataSource,
        defaultConfig: {'file_id': ''},
        inputPorts: [],
        outputPorts: [NodePort(id: 'output', name: 'CSV Data', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'file_id', label: 'File ID', type: 'string', isRequired: true),
        ],
      ),

      // Transforms
      NodeDefinition(
        type: 'filter',
        name: 'Filter',
        description: 'Filter rows based on simple condition',
        category: NodeCategory.transform,
        defaultConfig: {'column': '', 'operator': '==', 'value': ''},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [NodePort(id: 'output', name: 'Filtered Data', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'column', label: 'Column Name', type: 'string', isRequired: true),
          NodeProperty(
            key: 'operator',
            label: 'Operator',
            type: 'enum_',
            isRequired: true,
            defaultValue: '==',
            options: ['==', '!=', '>', '<', '>=', '<=', 'contains', 'startswith'],
          ),
          NodeProperty(key: 'value', label: 'Comparison Value', type: 'string', isRequired: true),
        ],
      ),
      NodeDefinition(
        type: 'group_by',
        name: 'Group By',
        description: 'Group data by keys and apply aggregations',
        category: NodeCategory.transform,
        defaultConfig: {'keys': '', 'aggregations': {}},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [NodePort(id: 'output', name: 'Grouped Data', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'keys', label: 'Group Keys (comma separated)', type: 'string', isRequired: true),
        ],
      ),

      // Aggregations
      NodeDefinition(
        type: 'sum',
        name: 'Sum',
        description: 'Calculate the sum of a numeric column',
        category: NodeCategory.aggregation,
        defaultConfig: {'column': ''},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [NodePort(id: 'output', name: 'Sum Value', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'column', label: 'Numeric Column', type: 'string', isRequired: true),
        ],
      ),
      NodeDefinition(
        type: 'count',
        name: 'Count',
        description: 'Count rows or values',
        category: NodeCategory.aggregation,
        defaultConfig: {'column': ''},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [NodePort(id: 'output', name: 'Count Value', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'column', label: 'Column (Optional)', type: 'string'),
        ],
      ),

      // Outputs
      NodeDefinition(
        type: 'table_output',
        name: 'Table Output',
        description: 'Render the resulting data as a structured table',
        category: NodeCategory.output,
        defaultConfig: {'title': 'Results Table', 'page_size': 10},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [],
        properties: [
          NodeProperty(key: 'title', label: 'Table Title', type: 'string', isRequired: true),
        ],
      ),
      NodeDefinition(
        type: 'kpi_value',
        name: 'KPI Card',
        description: 'Render a single key metric value card',
        category: NodeCategory.output,
        defaultConfig: {'title': 'Metric Card', 'column': '', 'operation': 'sum'},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [],
        properties: [
          NodeProperty(key: 'title', label: 'Card Title', type: 'string', isRequired: true),
          NodeProperty(key: 'column', label: 'Value Column', type: 'string', isRequired: true),
        ],
      ),

      // LLM Analysis
      NodeDefinition(
        type: 'llm_analysis',
        name: 'LLM Analysis',
        description: 'Generate AI summaries or insights using an LLM',
        category: NodeCategory.llm,
        defaultConfig: {'prompt': 'Summarize the key trends in this data', 'column': ''},
        inputPorts: [NodePort(id: 'input', name: 'Data', dataType: 'dataframe', isRequired: true)],
        outputPorts: [NodePort(id: 'output', name: 'AI Insights', dataType: 'dataframe', isRequired: true)],
        properties: [
          NodeProperty(key: 'prompt', label: 'AI Prompt / Instructions', type: 'string', isRequired: true),
        ],
      ),
    ];
  }
}
