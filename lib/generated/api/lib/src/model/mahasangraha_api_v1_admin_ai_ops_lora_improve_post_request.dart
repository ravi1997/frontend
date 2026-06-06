//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_admin_ai_ops_lora_improve_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest {
  /// Returns a new [MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest] instance.
  MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest({

     this.cycles,

     this.fast = true,

     this.targetDatasetSize,
  });

  @JsonKey(
    
    name: r'cycles',
    required: false,
    includeIfNull: false,
  )


  final int? cycles;



  @JsonKey(
    defaultValue: true,
    name: r'fast',
    required: false,
    includeIfNull: false,
  )


  final bool? fast;



  @JsonKey(
    
    name: r'target_dataset_size',
    required: false,
    includeIfNull: false,
  )


  final int? targetDatasetSize;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest &&
      other.cycles == cycles &&
      other.fast == fast &&
      other.targetDatasetSize == targetDatasetSize;

    @override
    int get hashCode =>
        cycles.hashCode +
        fast.hashCode +
        targetDatasetSize.hashCode;

  factory MahasangrahaApiV1AdminAiOpsLoraImprovePostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1AdminAiOpsLoraImprovePostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1AdminAiOpsLoraImprovePostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

