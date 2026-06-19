class AnalysisHelpers {
  static String generateNodeId() => 'node_${DateTime.now().microsecondsSinceEpoch}';
  static String generateEdgeId() => 'edge_${DateTime.now().microsecondsSinceEpoch}';
}
