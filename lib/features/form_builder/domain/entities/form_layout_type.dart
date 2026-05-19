import 'package:freezed_annotation/freezed_annotation.dart';

enum FormLayoutType {
  @JsonValue('flex')
  singleColumn,
  @JsonValue('grid-cols-2')
  twoColumns,
  @JsonValue('grid-cols-3')
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
