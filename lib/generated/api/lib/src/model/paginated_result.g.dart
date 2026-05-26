// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResult _$PaginatedResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PaginatedResult',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const [
            'has_next',
            'items',
            'page',
            'page_size',
            'total',
          ],
        );
        final val = PaginatedResult(
          hasNext: $checkedConvert('has_next', (v) => v as bool),
          items: $checkedConvert(
            'items',
            (v) => (v as List<dynamic>).map((e) => e as Object).toList(),
          ),
          page: $checkedConvert('page', (v) => (v as num).toInt()),
          pageSize: $checkedConvert('page_size', (v) => (v as num).toInt()),
          total: $checkedConvert('total', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {'hasNext': 'has_next', 'pageSize': 'page_size'},
    );

Map<String, dynamic> _$PaginatedResultToJson(PaginatedResult instance) =>
    <String, dynamic>{
      'has_next': instance.hasNext,
      'items': instance.items,
      'page': instance.page,
      'page_size': instance.pageSize,
      'total': instance.total,
    };
