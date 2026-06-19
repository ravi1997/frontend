// lib/modules/analysis_coder/models/node_types.dart
// Node type definitions and enums for the analysis coder.

enum NodeCategory {
  dataSource,
  transform,
  aggregation,
  output,
  llm,
}

enum NodePortType {
  dataframe,
  number,
  string,
  boolean,
  array,
  object,
}

enum NodePropertyType {
  string,
  number,
  boolean,
  enum_,
  color,
  object,
  array,
}
