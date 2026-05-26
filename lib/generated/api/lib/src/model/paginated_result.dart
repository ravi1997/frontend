//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'paginated_result.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PaginatedResult {
  /// Returns a new [PaginatedResult] instance.
  PaginatedResult({

    required  this.hasNext,

    required  this.items,

    required  this.page,

    required  this.pageSize,

    required  this.total,
  });

  @JsonKey(
    
    name: r'has_next',
    required: true,
    includeIfNull: false
  )


  final bool hasNext;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false
  )


  final List<Object> items;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false
  )


  final int page;



  @JsonKey(
    
    name: r'page_size',
    required: true,
    includeIfNull: false
  )


  final int pageSize;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false
  )


  final int total;



  @override
  bool operator ==(Object other) => identical(this, other) || other is PaginatedResult &&
     other.hasNext == hasNext &&
     other.items == items &&
     other.page == page &&
     other.pageSize == pageSize &&
     other.total == total;

  @override
  int get hashCode =>
    hasNext.hashCode +
    items.hashCode +
    page.hashCode +
    pageSize.hashCode +
    total.hashCode;

  factory PaginatedResult.fromJson(Map<String, dynamic> json) => _$PaginatedResultFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

