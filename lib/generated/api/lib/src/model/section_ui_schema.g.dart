// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_ui_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionUISchema _$SectionUISchemaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SectionUISchema',
      json,
      ($checkedConvert) {
        final val = SectionUISchema(
          id: $checkedConvert('_id', (v) => v),
          createdAt: $checkedConvert('created_at', (v) => v),
          layoutType: $checkedConvert(
            'layout_type',
            (v) =>
                $enumDecodeNullable(
                  _$SectionUISchemaLayoutTypeEnumEnumMap,
                  v,
                ) ??
                'flex',
          ),
          style: $checkedConvert('style', (v) => v),
          updatedAt: $checkedConvert('updated_at', (v) => v),
          visibleHeader: $checkedConvert(
            'visible_header',
            (v) => v as bool? ?? true,
          ),
          visibleName: $checkedConvert('visible_name', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'id': '_id',
        'createdAt': 'created_at',
        'layoutType': 'layout_type',
        'updatedAt': 'updated_at',
        'visibleHeader': 'visible_header',
        'visibleName': 'visible_name',
      },
    );

Map<String, dynamic> _$SectionUISchemaToJson(
  SectionUISchema instance,
) => <String, dynamic>{
  '_id': ?instance.id,
  'created_at': ?instance.createdAt,
  'layout_type': ?_$SectionUISchemaLayoutTypeEnumEnumMap[instance.layoutType],
  'style': ?instance.style,
  'updated_at': ?instance.updatedAt,
  'visible_header': ?instance.visibleHeader,
  'visible_name': ?instance.visibleName,
};

const _$SectionUISchemaLayoutTypeEnumEnumMap = {
  SectionUISchemaLayoutTypeEnum.flex: 'flex',
  SectionUISchemaLayoutTypeEnum.gridCols2: 'grid-cols-2',
  SectionUISchemaLayoutTypeEnum.tabbed: 'tabbed',
  SectionUISchemaLayoutTypeEnum.custom: 'custom',
  SectionUISchemaLayoutTypeEnum.gridCols3: 'grid-cols-3',
  SectionUISchemaLayoutTypeEnum.fullWidth: 'full-width',
  SectionUISchemaLayoutTypeEnum.cards: 'cards',
  SectionUISchemaLayoutTypeEnum.card: 'card',
};
