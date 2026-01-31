import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_form.freezed.dart';
part 'recent_form.g.dart';

@freezed
abstract class RecentForm with _$RecentForm {
  const RecentForm._();
  const factory RecentForm({
    required String id,
    required String title,
    required String status,
    required DateTime updatedAt,
    DateTime? createdAt,
  }) = _RecentForm;

  factory RecentForm.fromJson(Map<String, dynamic> json) =>
      _$RecentFormFromJson(json);
}
