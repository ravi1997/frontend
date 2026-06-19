// lib/modules/analysis_coder/models/analysis_models.dart
// Lightweight analysis coder models used by the screen and providers.

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
}

class AnalysisGraph {
  final List<AnalysisNode> nodes;
  final List<AnalysisEdge> edges;

  AnalysisGraph({required this.nodes, required this.edges});
}

class AnalysisNode {
  final String id;
  final String nodeType;
  final String name;
  final String description;
  final Map<String, dynamic> config;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;
  final Map<String, dynamic> position;

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
}

class NodeProperty {
  final String key;
  final String label;
  final String type;
  final String? description;
  final bool required;
  final dynamic defaultValue;
  final List<dynamic>? options;
  final String? group;

  NodeProperty({
    required this.key,
    required this.label,
    required this.type,
    this.description,
    this.required = false,
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
}

class AnalysisRun {
  final String id;
  final String analysisId;
  final String status;
  final DateTime? startedAt;
  final DateTime? finishedAt;

  AnalysisRun({
    required this.id,
    required this.analysisId,
    required this.status,
    this.startedAt,
    this.finishedAt,
  });
}

class AnalysisResult {
  final String id;
  final String title;
  final String? description;

  AnalysisResult({
    required this.id,
    required this.title,
    this.description,
  });
}

class AnalysisExport {
  final String id;
  final String format;
  final String? downloadUrl;

  AnalysisExport({
    required this.id,
    required this.format,
    this.downloadUrl,
  });
}

class NodeDefinition {
  final String type;
  final String name;
  final String description;
  final Map<String, dynamic> defaultConfig;
  final List<NodePort> inputPorts;
  final List<NodePort> outputPorts;

  NodeDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.defaultConfig,
    required this.inputPorts,
    required this.outputPorts,
  });
}

class NodeLibrary {
  static List<NodeDefinition> getNodes() => [];
}
