import 'package:freezed_annotation/freezed_annotation.dart';

enum FormLayoutType {
  @JsonValue('single_column')
  singleColumn,
  @JsonValue('two_columns')
  twoColumns,
  @JsonValue('three_columns')
  threeColumns,
}

extension FormLayoutTypeExtension on FormLayoutType {
  String get label {
    switch (this) {
      case FormLayoutType.singleColumn:
        return 'One Column';
      case FormLayoutType.twoColumns:
        return 'Two Columns';
      case FormLayoutType.threeColumns:
        return 'Three Columns';
    }
  }
}
