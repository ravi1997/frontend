import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_filter.freezed.dart';
part 'global_filter.g.dart';

@freezed
abstract class GlobalFilter with _$GlobalFilter {
  const factory GlobalFilter({
    required String id,
    required String label,
    required String type, // date_range, category, status
    String? fieldId,
    dynamic value,
    @Default(true) bool isActive,
  }) = _GlobalFilter;

  factory GlobalFilter.fromJson(Map<String, dynamic> json) =>
      _$GlobalFilterFromJson(json);
}
