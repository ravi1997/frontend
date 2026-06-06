//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ridp_api/src/model/mahasangraha_api_v1_projects_project_id_forms_form_id_responses_filter_post_request_filters_inner.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mahasangraha_api_v1_projects_project_id_forms_form_id_responses_filter_post_request.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest {
  /// Returns a new [MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest] instance.
  MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest({

     this.filters,

     this.page,

     this.pageSize,
  });

      /// Array of filter rule objects
  @JsonKey(
    
    name: r'filters',
    required: false,
    includeIfNull: false,
  )


  final List<MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFiltersInner>? filters;



  @JsonKey(
    
    name: r'page',
    required: false,
    includeIfNull: false,
  )


  final int? page;



  @JsonKey(
    
    name: r'page_size',
    required: false,
    includeIfNull: false,
  )


  final int? pageSize;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest &&
      other.filters == filters &&
      other.page == page &&
      other.pageSize == pageSize;

    @override
    int get hashCode =>
        filters.hashCode +
        page.hashCode +
        pageSize.hashCode;

  factory MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequest.fromJson(Map<String, dynamic> json) => _$MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MahasangrahaApiV1ProjectsProjectIdFormsFormIdResponsesFilterPostRequestToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

