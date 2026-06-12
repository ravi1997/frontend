import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/models/question_type.dart';
import '../../../../core/app_exception.dart';
import '../dto/form_dto.dart';

class FormMapper {
  /// Build the canonical save payload for the form builder.
  ///
  /// Important: this keeps both forms of section persistence that the current
  /// backend understands:
  /// - top-level `sections` for direct canvas sync
  /// - `versions[0].sections` for the version snapshot contract
  ///
  /// The goal is compatibility, not two separate sources of truth.
  static BuilderForm fromDto(FormDto dto) {
    String activeVersion = dto.activeVersion ?? '1.0';

    // Find the active version or use the last one
    FormVersionDto? versionData;
    if (dto.versions.isNotEmpty) {
      versionData = dto.versions.firstWhere(
        (v) => v.version == activeVersion,
        orElse: () => dto.versions.last,
      );
    }

    // Extract sections from the version
    final sections = _normalizeSections(versionData?.sections ?? const []);
    final quickResponses = _normalizeQuickResponses(dto.quickResponses);

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': dto.id,
      'title': dto.title,
      'slug': dto.slug,
      'description': dto.description,
      'status': dto.status,
      'isPublished': dto.status == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': sections,
      'quickResponses': quickResponses,
      'layout': dto.uiType ?? 'flex',
      'updatedAt': dto.updatedAt?.toIso8601String(),
      'workflows': dto.workflows,
      'accessPolicy': dto.accessPolicy,
      'submissionSettings': Map<String, dynamic>.from(dto.submissionSettings),
      'dataExportSettings': _normalizeDataExportSettings(
        dto.dataExportSettings,
      ),
      'advancedSettings': Map<String, dynamic>.from(dto.advancedSettings),
      'style': Map<String, dynamic>.from(dto.style),
      'versionHistory': dto.versions.map((v) {
        return {
          'version': v.version,
          'createdAt': v.createdAt?.toIso8601String(),
          'changeLog': 'Version ${v.version}',
        };
      }).toList(),
    };

    return BuilderForm.fromJson(transformedData);
  }

  static BuilderForm fromBackendJson(dynamic data) {
    if (data == null) {
      throw const FormLoadException(
        'unknown',
        originalError: 'Response data is null',
      );
    }

    // Ensure data is deeply sanitized to Map<String, dynamic>
    final Map<String, dynamic> mapData =
        _sanitizeData(data) as Map<String, dynamic>;

    // Backend returns form with versions array
    // We need to extract the active/latest version's sections
    List<dynamic> versions = mapData['versions'] ?? [];
    String activeVersion = mapData['active_version'] ?? '1.0';

    // Find the active version or use the last one
    Map<String, dynamic>? versionData;
    if (versions.isNotEmpty) {
      final foundVersion = versions.firstWhere(
        (v) => v['version'] == activeVersion,
        orElse: () => versions.last,
      );
      versionData = foundVersion as Map<String, dynamic>;
    }

    // Extract sections from the version
    List<dynamic> sections =
        versionData?['sections'] ?? mapData['sections'] ?? [];
    final advancedSettings = Map<String, dynamic>.from(
      versionData?['advanced_settings'] ??
          versionData?['advancedSettings'] ??
          mapData['advanced_settings'] ??
          mapData['advancedSettings'] ??
          const <String, dynamic>{},
    );
    final dataExportSettings = _normalizeDataExportSettings(
      versionData?['data_export_settings'] ??
          versionData?['dataExportSettings'] ??
          mapData['data_export_settings'] ??
          mapData['dataExportSettings'] ??
          const <String, dynamic>{},
    );
    final quickResponses = _normalizeQuickResponses(
      versionData?['quick_responses'] ??
          versionData?['quickResponses'] ??
          mapData['quick_responses'] ??
          mapData['quickResponses'] ??
          const [],
    );

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': mapData['id'] ?? mapData['_id'],
      'title': mapData['title'] ?? 'Untitled Form',
      'slug': mapData['slug'] ?? versionData?['slug'],
      'description': mapData['description'] ?? versionData?['description'],
      'status': mapData['status'] ?? 'draft',
      'isPublished': mapData['status'] == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': _normalizeSections(sections),
      'quickResponses': quickResponses,
      'layout': mapData['uiType'] ?? mapData['ui_type'] ?? 'flex',
      'updatedAt': mapData['updated_at'],
      'workflows': mapData['workflows'] ?? <String, dynamic>{},
      'accessPolicy': mapData['access_policy'] ?? mapData['accessPolicy'],
      'submissionSettings':
          versionData?['submission_settings'] ??
          versionData?['submissionSettings'] ??
          mapData['submission_settings'] ??
          mapData['submissionSettings'] ??
          <String, dynamic>{},
      'dataExportSettings': dataExportSettings,
      'advancedSettings': advancedSettings,
      'style': Map<String, dynamic>.from(
        mapData['style'] ?? versionData?['style'] ?? const <String, dynamic>{},
      ),
      'versionHistory': versions.map((v) {
        return {
          'version': v['version'],
          'createdAt': v['created_at'],
          'changeLog': 'Version ${v['version']}',
        };
      }).toList(),
    };

    return BuilderForm.fromJson(transformedData);
  }

  // ── Create payload (POST /forms/) ────────────────────────────────────────
  // Backend expects minimal fields for creation. Sections are optional on
  // create — the backend initializes an empty version automatically.
  static Map<String, dynamic> toCreatePayload(BuilderForm form) {
    return {
      'title': form.title,
      'status': form.status,
      'description': '',
      'default_language': 'en',
      'supported_languages': ['en'],
    };
  }

  // ── Update payload (PUT /forms/<id>) ─────────────────────────────────────
  // For metadata-only updates. Sections are NOT included here.
  static Map<String, dynamic> toUpdatePayload(BuilderForm form) {
    return {'title': form.title, 'status': form.status};
  }

  // ── Legacy full payload (used for backwards compat) ──────────────────────
  static Map<String, dynamic> toBackendJson(BuilderForm form) {
    final sectionJson = form.sections.map(_sectionToBackendJson).toList();
    final workflowJson = _normalizeWorkflowMap(form.workflows);
    final slug = form.slug.isNotEmpty ? form.slug : form.id;
    final dataExportJson = _dataExportSettingsToBackendJson(
      form.dataExportSettings,
    );
    final quickResponses = _normalizeQuickResponses(form.quickResponses);
    return {
      'title': form.title,
      'description': form.description,
      'status': form.status,
      'slug': slug,
      'sections': sectionJson,
      'versions': [
        {
          'version': form.version,
          'sections': sectionJson,
          'quickResponses': quickResponses,
          'created_at': DateTime.now().toIso8601String(),
        },
      ],
      'active_version': form.version,
      'workflows': workflowJson,
      'metadata': {...form.metadata, 'workflowSettings': workflowJson},
      'access_policy': form.accessPolicy,
      'accessPolicy': form.accessPolicy,
      'submission_settings': form.submissionSettings,
      'submissionSettings': form.submissionSettings,
      'quick_responses': quickResponses,
      'quickResponses': quickResponses,
      'data_export_settings': dataExportJson,
      'dataExportSettings': dataExportJson,
      'advanced_settings': form.advancedSettings,
      'advancedSettings': form.advancedSettings,
      'style': form.style,
      'ui_type': _formLayoutToApi(form.layout),
    };
  }

  static Map<String, dynamic> toFormMetadataJson(BuilderForm form) {
    final workflowJson = _normalizeWorkflowMap(form.workflows);
    final slug = form.slug.isNotEmpty ? form.slug : form.id;
    final dataExportJson = _dataExportSettingsToBackendJson(
      form.dataExportSettings,
    );
    final quickResponses = _normalizeQuickResponses(form.quickResponses);
    return {
      'title': form.title,
      'description': form.description,
      'status': form.status,
      'slug': slug,
      'active_version': form.version,
      'workflows': workflowJson,
      'metadata': {...form.metadata, 'workflowSettings': workflowJson},
      'access_policy': form.accessPolicy,
      'accessPolicy': form.accessPolicy,
      'submission_settings': form.submissionSettings,
      'submissionSettings': form.submissionSettings,
      'quick_responses': quickResponses,
      'quickResponses': quickResponses,
      'data_export_settings': dataExportJson,
      'dataExportSettings': dataExportJson,
      'advanced_settings': form.advancedSettings,
      'advancedSettings': form.advancedSettings,
      'style': form.style,
      'ui_type': _formLayoutToApi(form.layout),
      // 'is_template': form.isTemplate, // If applicable
      // versions are EXCLUDED to prevent overwrite
    };
  }

  static Map<String, dynamic> toVersionJson(BuilderForm form) {
    return {
      'version': form.version,
      'sections': form.sections.map(_sectionToBackendJson).toList(),
      'quickResponses': _normalizeQuickResponses(form.quickResponses),
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> _sectionToBackendJson(FormSection section) {
    return {
      'id': section.id,
      'title': section.title,
      'description': section.description,
      'help_text': section.helpText,
      'order': section.order,
      'layout': section.layout,
      'grid_columns': section.gridColumns,
      'is_hidden': section.isHidden,
      'is_repeatable': section.isRepeatable,
      'repeat_min': section.repeatMin,
      'repeat_max': section.repeatMax,
      'conditional_logic': section.conditionalLogic,
      'logic': section.logic,
      'sections': section.sections.map(_sectionToBackendJson).toList(),
      'response_templates': section.responseTemplates,
      'tags': section.tags,
      'style': section.style,
      'ui': section.ui,
      'meta_data': section.metadata,
      'questions': section.questions.map(_questionToBackendJson).toList(),
    };
  }

  static Map<String, dynamic> _questionToBackendJson(FormQuestion question) {
    final ui = Map<String, dynamic>.from(question.ui);
    final metadata = Map<String, dynamic>.from(question.metadata);

    if (question.placeholder != null && question.placeholder!.isNotEmpty) {
      ui['placeholder'] = question.placeholder;
    }
    if (question.style.isNotEmpty) {
      ui['style'] = question.style;
    }
    if (question.value != null) {
      metadata['value'] = question.value;
    }

    return {
      'id': question.id,
      'label': question.label,
      'field_type': _questionFieldType(question),
      'help_text': question.helpText,
      'default_value': question.defaultValue,
      'order': question.order,
      'variable_name': question.variableName,
      'is_repeatable': question.isRepeatable,
      'repeat_min': question.repeatMin,
      'repeat_max': question.repeatMax,
      'keep_last_value': question.keepLastValue,
      'is_hidden': question.isHidden,
      'is_read_only': question.isReadOnly,
      'is_sensitive': metadata['is_sensitive'] ?? false,
      'validation': question.validation,
      'logic': question.logic,
      'ui': ui,
      'response_templates': const [],
      'options': question.options,
      'tags': const [],
      'meta_data': metadata,
    };
  }

  static String _questionFieldType(FormQuestion question) {
    final raw = question.fieldType.trim();
    if (raw.isNotEmpty && _isBackendFieldType(raw)) {
      return raw;
    }

    switch (question.type) {
      case QuestionType.shortText:
        return 'input';
      case QuestionType.paragraph:
        return 'textarea';
      case QuestionType.multipleChoice:
        return 'radio';
      case QuestionType.checkboxes:
        return 'checkboxes';
      case QuestionType.dropdown:
        return 'select';
      case QuestionType.fileUpload:
        return 'file_upload';
      case QuestionType.multiFileUpload:
        return 'multi-file_upload';
      case QuestionType.filePicker:
        return 'file_picker';
      case QuestionType.fileList:
        return 'file_list';
      case QuestionType.signaturePad:
        return 'signature_pad';
      case QuestionType.imageGallery:
        return 'image_gallery';
      case QuestionType.divider:
        return 'note';
      case QuestionType.spacer:
        return 'hidden';
      case QuestionType.matrixChoice:
        return 'matrix_choice';
      case QuestionType.mapLocation:
        return 'map_location';
      case QuestionType.addressLookup:
        return 'address_lookup';
      case QuestionType.address:
        return 'address';
      case QuestionType.richText:
        return 'rich_text';
      case QuestionType.markdownEditor:
        return 'markdown_editor';
      case QuestionType.booleanValue:
        return 'boolean';
      case QuestionType.multiSelect:
        return 'multi_select';
      case QuestionType.customField:
        return 'custom_field';
      case QuestionType.colorPicker:
        return 'color_picker';
      case QuestionType.dateRange:
        return 'date_range';
      case QuestionType.timeRange:
        return 'time_range';
      case QuestionType.countrySelect:
        return 'country_select';
      case QuestionType.stateSelect:
        return 'state_select';
      case QuestionType.citySelect:
        return 'city_select';
      case QuestionType.socialMediaHandle:
        return 'social_media_handle';
      case QuestionType.websiteUrl:
        return 'website_url';
      case QuestionType.phoneNumber:
        return 'phone_number';
      case QuestionType.unitSelect:
        return 'unit_select';
      case QuestionType.multiCheckbox:
        return 'multi_checkbox';
      case QuestionType.emailList:
        return 'email_list';
      case QuestionType.qrCodeScan:
        return 'qr_code_scan';
      case QuestionType.calculate:
      case QuestionType.calculated:
      case QuestionType.number:
      case QuestionType.password:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.tel:
      case QuestionType.email:
      case QuestionType.mobile:
      case QuestionType.url:
      case QuestionType.rating:
      case QuestionType.signature:
      case QuestionType.slider:
      case QuestionType.image:
      case QuestionType.otp:
      case QuestionType.range:
      case QuestionType.stepper:
      case QuestionType.captcha:
      case QuestionType.price:
      case QuestionType.age:
      case QuestionType.toggle:
      case QuestionType.search:
      case QuestionType.file:
        return question.type.name;
    }
  }

  static bool _isBackendFieldType(String value) {
    const allowed = {
      'input',
      'textarea',
      'number',
      'email',
      'mobile',
      'url',
      'password',
      'tel',
      'calculate',
      'note',
      'select',
      'dropdown',
      'radio',
      'checkbox',
      'multi_select',
      'checkboxes',
      'matrix_choice',
      'boolean',
      'rating',
      'date',
      'time',
      'datetime',
      'datetime-local',
      'month',
      'week',
      'file_upload',
      'multi-file_upload',
      'file_picker',
      'file_list',
      'image',
      'video_upload',
      'audio_upload',
      'signature',
      'signature_pad',
      'image_gallery',
      'map_location',
      'address',
      'address_lookup',
      'calculated',
      'api_search',
      'otp',
      'short_text',
      'paragraph',
      'rich_text',
      'textarea_editor',
      'markdown_editor',
      'color_picker',
      'slider',
      'range',
      'date_range',
      'time_range',
      'stepper',
      'country_select',
      'state_select',
      'city_select',
      'social_media_handle',
      'website_url',
      'phone_number',
      'captcha',
      'unit_select',
      'price',
      'age',
      'toggle',
      'hidden',
      'custom_field',
      'multi_checkbox',
      'email_list',
      'qr_code_scan',
      'search',
      'file',
    };
    return allowed.contains(value);
  }

  static List<FormSection> mapAISectionsToFrontend(List<dynamic> sectionsJson) {
    return sectionsJson.map((s) {
      final section = Map<String, dynamic>.from(s);
      final questions = (section['questions'] as List<dynamic>).map((q) {
        final question = Map<String, dynamic>.from(q);

        // Map backend to frontend fields
        if (question.containsKey('question_text')) {
          question['label'] = question['question_text'];
        }
        if (question.containsKey('field_type')) {
          // Normalize field types
          String type = question['field_type'];
          if (type == 'long_text') type = 'paragraph';
          if (type == 'radio' || type == 'boolean') type = 'multiple_choice';
          if (type == 'checkbox') type = 'checkboxes';
          question['type'] = type;
        }

        // Map options from List<Map> to List<String>
        if (question.containsKey('options') && question['options'] is List) {
          question['options'] = (question['options'] as List).map((o) {
            if (o is Map) return o['option_label'] ?? o['label'] ?? '';
            return o.toString();
          }).toList();
        }

        return question;
      }).toList();

      section['questions'] = questions;
      return FormSection.fromJson(section);
    }).toList();
  }

  static dynamic _sanitizeData(dynamic data) {
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      data.forEach((key, value) {
        sanitized[key.toString()] = _sanitizeData(value);
      });
      return sanitized;
    }
    if (data is List) {
      return data.map((item) => _sanitizeData(item)).toList();
    }
    return data;
  }

  static Map<String, dynamic> _normalizeWorkflowMap(
    Map<String, dynamic> workflows,
  ) {
    final normalized = <String, dynamic>{};
    workflows.forEach((key, value) {
      if (value is Map) {
        final map = Map<String, dynamic>.from(value);
        normalized[key.toString()] = {
          ...map,
          if (map.containsKey('email_notification'))
            'email_notification': map['email_notification'],
          if (map.containsKey('webhook')) 'webhook': map['webhook'],
        };
      } else {
        normalized[key.toString()] = value;
      }
    });
    return normalized;
  }

  static Map<String, dynamic> _normalizeDataExportSettings(dynamic raw) {
    if (raw is! Map) {
      return const <String, dynamic>{};
    }

    final source = Map<String, dynamic>.from(raw);
    final csvSource = Map<String, dynamic>.from(
      source['csv_defaults'] ??
          source['csvDefaults'] ??
          source['csv'] ??
          source['csvSettings'] ??
          const <String, dynamic>{},
    );
    final rawFieldMapping =
        source['field_mapping'] ?? source['fieldMapping'] ?? const {};
    final fieldMapping = _normalizeFieldMapping(rawFieldMapping);
    final anonymization = Map<String, dynamic>.from(
      source['anonymization'] ??
          source['anonymisation'] ??
          const <String, dynamic>{},
    );
    final anonymizedFields = <String>{
      ...(anonymization['fields'] as List? ?? const [])
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty),
      if (rawFieldMapping is List)
        ...rawFieldMapping
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .where((item) => item['anonymize'] == true)
            .map(
              (item) =>
                  item['fieldId']?.toString() ??
                  item['field_id']?.toString() ??
                  '',
            )
            .where((e) => e.isNotEmpty),
    }.toList();
    final retentionValue = source['retention_days'] ?? source['retentionDays'];

    return {
      'csv_defaults': {
        'delimiter': csvSource['delimiter']?.toString() ?? ',',
        'header_mode':
            csvSource['header_mode']?.toString() ??
            csvSource['headerMode']?.toString() ??
            'labels',
        'empty_field_value':
            csvSource['empty_field_value']?.toString() ??
            csvSource['emptyFieldValue']?.toString() ??
            '',
        'date_format':
            csvSource['date_format']?.toString() ??
            csvSource['dateFormat']?.toString() ??
            'iso8601',
        'timezone':
            csvSource['timezone']?.toString() ??
            csvSource['timezoneName']?.toString() ??
            'UTC',
        'encoding': csvSource['encoding']?.toString() ?? 'utf-8',
        'include_attachments':
            csvSource['include_attachments'] as bool? ??
            csvSource['includeAttachments'] as bool? ??
            false,
      },
      'retention_days': retentionValue is num
          ? retentionValue.toInt()
          : int.tryParse(retentionValue?.toString() ?? ''),
      'field_mapping': fieldMapping,
      'anonymization': {
        'mode': anonymization['mode']?.toString() ?? 'none',
        'fields': anonymizedFields,
      },
    };
  }

  static Map<String, String> _normalizeFieldMapping(dynamic raw) {
    if (raw is Map) {
      final result = <String, String>{};
      raw.forEach((key, value) {
        final fieldKey = key.toString().trim();
        if (fieldKey.isEmpty) return;
        if (value is Map) {
          final mapValue = Map<String, dynamic>.from(value);
          final label =
              mapValue['label']?.toString() ??
              mapValue['alias']?.toString() ??
              mapValue['header_label']?.toString() ??
              mapValue['exportLabel']?.toString() ??
              mapValue['export_label']?.toString();
          if (label != null && label.trim().isNotEmpty) {
            result[fieldKey] = label.trim();
          }
          return;
        }
        final label = value.toString().trim();
        if (label.isNotEmpty) {
          result[fieldKey] = label;
        }
      });
      return result;
    }

    if (raw is List) {
      final result = <String, String>{};
      for (final item in raw) {
        if (item is! Map) continue;
        final mapping = Map<String, dynamic>.from(item);
        final fieldKey =
            mapping['fieldId']?.toString() ?? mapping['field_id']?.toString();
        final label =
            mapping['exportLabel']?.toString() ??
            mapping['export_label']?.toString() ??
            mapping['label']?.toString() ??
            mapping['alias']?.toString() ??
            mapping['header_label']?.toString();
        if (fieldKey == null ||
            fieldKey.trim().isEmpty ||
            label == null ||
            label.trim().isEmpty) {
          continue;
        }
        result[fieldKey.trim()] = label.trim();
      }
      return result;
    }

    return const <String, String>{};
  }

  static Map<String, dynamic> _dataExportSettingsToBackendJson(dynamic raw) {
    return _normalizeDataExportSettings(raw);
  }

  static List<Map<String, dynamic>> _normalizeQuickResponses(dynamic raw) {
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) {
          final normalized = Map<String, dynamic>.from(item);
          normalized['name'] = normalized['name']?.toString().trim() ?? '';
          normalized['description'] = normalized['description']?.toString().trim();
          normalized['tags'] = (normalized['tags'] as List? ?? const [])
              .map((tag) => tag.toString().trim())
              .where((tag) => tag.isNotEmpty)
              .toSet()
              .toList();
          normalized['visibility'] =
              normalized['visibility']?.toString().trim().toLowerCase() ??
              'personal';
          normalized['owner_id'] =
              normalized['owner_id']?.toString().trim();
          normalized['field_values'] = Map<String, dynamic>.from(
            normalized['field_values'] ??
                normalized['fieldValues'] ??
                const <String, dynamic>{},
          );
          normalized['is_archived'] =
              normalized['is_archived'] ?? normalized['isArchived'] ?? false;
          normalized.remove('fieldValues');
          normalized.remove('isArchived');
          normalized.remove('ownerId');
          if ((normalized['name'] as String).isEmpty) {
            return <String, dynamic>{};
          }
          return normalized;
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static List<Map<String, dynamic>> _normalizeSections(List<dynamic> sections) {
    return sections.map((section) {
      if (section is Map<String, dynamic>) {
        return _normalizeSectionTree(section);
      }
      if (section is Map) {
        return _normalizeSectionTree(Map<String, dynamic>.from(section));
      }
      return _sectionStub(section.toString());
    }).toList();
  }

  static Map<String, dynamic> _normalizeSectionTree(
    Map<String, dynamic> section,
  ) {
    final normalized = Map<String, dynamic>.from(section);
    final ui = normalized['ui'];
    if (!normalized.containsKey('layout') && ui is Map) {
      normalized['layout'] =
          ui['layout_type'] ?? ui['layoutType'] ?? 'standard';
    }
    normalized['layout'] ??= 'standard';
    normalized['ui'] = {
      if (ui is Map) ...Map<String, dynamic>.from(ui),
      'layout_type': normalized['layout'],
    };
    if (normalized.containsKey('gridColumns') &&
        !normalized.containsKey('grid_columns')) {
      normalized['grid_columns'] = normalized['gridColumns'];
    }
    final children = normalized['sections'];
    if (children is List) {
      normalized['sections'] = _normalizeSections(children);
    } else {
      normalized['sections'] = <Map<String, dynamic>>[];
    }

    final questions = normalized['questions'];
    if (questions is List) {
      normalized['questions'] = questions.map((q) {
        final mapped = q is Map<String, dynamic>
            ? Map<String, dynamic>.from(q)
            : q is Map
            ? Map<String, dynamic>.from(q)
            : <String, dynamic>{
                'id': q.toString(),
                'label': 'Untitled Question',
              };
        if (mapped.containsKey('is_repeatable_question') &&
            !mapped.containsKey('is_repeatable')) {
          mapped['is_repeatable'] = mapped['is_repeatable_question'];
        }
        if (mapped.containsKey('keepLastValue') &&
            !mapped.containsKey('keep_last_value')) {
          mapped['keep_last_value'] = mapped['keepLastValue'];
        }
        if (mapped.containsKey('repeatMin') &&
            !mapped.containsKey('repeat_min')) {
          mapped['repeat_min'] = mapped['repeatMin'];
        }
        if (mapped.containsKey('repeatMax') &&
            !mapped.containsKey('repeat_max')) {
          mapped['repeat_max'] = mapped['repeatMax'];
        }
        return mapped;
      }).toList();
    } else {
      normalized['questions'] = <Map<String, dynamic>>[];
    }

    if (normalized.containsKey('is_repeatable_section') &&
        !normalized.containsKey('is_repeatable')) {
      normalized['is_repeatable'] = normalized['is_repeatable_section'];
    }
    if (normalized.containsKey('metaData') &&
        !normalized.containsKey('meta_data')) {
      normalized['meta_data'] = normalized['metaData'];
    }
    if (normalized.containsKey('metadata') &&
        !normalized.containsKey('meta_data')) {
      normalized['meta_data'] = normalized['metadata'];
    }

    normalized.putIfAbsent('title', () => 'Untitled Section');
    normalized.putIfAbsent('description', () => null);
    normalized.putIfAbsent('help_text', () => null);
    normalized.putIfAbsent('style', () => <String, dynamic>{});
    normalized.putIfAbsent('grid_columns', () => 2);
    normalized.putIfAbsent('meta_data', () => <String, dynamic>{});
    normalized.putIfAbsent('tags', () => <String>[]);
    normalized.putIfAbsent(
      'response_templates',
      () => <Map<String, dynamic>>[],
    );
    return normalized;
  }

  static Map<String, dynamic> _sectionStub(String id) {
    return {
      'id': id,
      'title': 'Untitled Section',
      'description': null,
      'help_text': null,
      'order': 0,
      'questions': <Map<String, dynamic>>[],
      'layout': 'flex',
      'grid_columns': 2,
      'is_hidden': false,
      'is_repeatable': false,
      'repeat_min': null,
      'repeat_max': null,
      'conditional_logic': null,
      'logic': null,
      'sections': <Map<String, dynamic>>[],
      'response_templates': <Map<String, dynamic>>[],
      'tags': <String>[],
      'style': <String, dynamic>{},
      'meta_data': <String, dynamic>{},
    };
  }

  static String _formLayoutToApi(dynamic layout) {
    switch (layout.toString()) {
      case 'FormLayoutType.twoColumns':
        return 'grid-cols-2';
      case 'FormLayoutType.threeColumns':
        return 'grid-cols-3';
      case 'FormLayoutType.singleColumn':
      default:
        return 'flex';
    }
  }
}
