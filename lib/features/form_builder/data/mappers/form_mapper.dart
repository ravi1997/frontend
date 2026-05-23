import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_section.dart';
import '../../../../core/exceptions/app_exception.dart';
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

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': dto.id,
      'title': dto.title,
      'status': dto.status,
      'isPublished': dto.status == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': sections,
      'layout': dto.uiType ?? 'flex',
      'updatedAt': dto.updatedAt?.toIso8601String(),
      'workflows': dto.workflows,
      'accessPolicy': dto.accessPolicy,
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
    List<dynamic> sections = versionData?['sections'] ?? mapData['sections'] ?? [];

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': mapData['id'] ?? mapData['_id'],
      'title': mapData['title'] ?? 'Untitled Form',
      'status': mapData['status'] ?? 'draft',
      'isPublished': mapData['status'] == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': _normalizeSections(sections),
      'layout': mapData['uiType'] ?? mapData['ui_type'] ?? 'flex',
      'updatedAt': mapData['updated_at'],
      'workflows': mapData['workflows'] ?? <String, dynamic>{},
      'accessPolicy': mapData['access_policy'] ?? mapData['accessPolicy'],
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
      'title': form.title is Map
          ? (form.title as Map)['en'] ?? 'Untitled Form'
          : form.title?.toString() ?? 'Untitled Form',
      'status': form.status,
      'description': '',
      'default_language': 'en',
      'supported_languages': ['en'],
    };
  }

  // ── Update payload (PUT /forms/<id>) ─────────────────────────────────────
  // For metadata-only updates. Sections are NOT included here.
  static Map<String, dynamic> toUpdatePayload(BuilderForm form) {
    return {
      'title': form.title is Map
          ? (form.title as Map)['en'] ?? 'Untitled Form'
          : form.title?.toString() ?? 'Untitled Form',
      'status': form.status,
    };
  }

  // ── Legacy full payload (used for backwards compat) ──────────────────────
  static Map<String, dynamic> toBackendJson(BuilderForm form) {
    final sectionJson = form.sections.map((s) => s.toJson()).toList();
    final workflowJson = _normalizeWorkflowMap(form.workflows);
    return {
      'title': form.title is Map
          ? (form.title as Map)['en'] ?? 'Untitled Form'
          : form.title?.toString() ?? 'Untitled Form',
      'status': form.status,
      'slug': form.id,
      'sections': sectionJson,
      'versions': [
        {
          'version': form.version,
          'sections': sectionJson,
          'created_at': DateTime.now().toIso8601String(),
        },
      ],
      'active_version': form.version,
      'workflows': workflowJson,
      'metadata': {...form.metadata, 'workflowSettings': workflowJson},
      'access_policy': form.accessPolicy.toJson(),
      'accessPolicy': form.accessPolicy.toJson(),
      'style': form.style.toJson(),
      'ui_type': _formLayoutToApi(form.layout),
    };
  }

  static Map<String, dynamic> toFormMetadataJson(BuilderForm form) {
    final workflowJson = _normalizeWorkflowMap(form.workflows);
    return {
      'title': form.title is Map
          ? (form.title as Map)['en'] ?? 'Untitled Form'
          : form.title?.toString() ?? 'Untitled Form',
      'status': form.status,
      'slug': form.id,
      'active_version': form.version,
      'workflows': workflowJson,
      'metadata': {...form.metadata, 'workflowSettings': workflowJson},
      'access_policy': form.accessPolicy.toJson(),
      'accessPolicy': form.accessPolicy.toJson(),
      'style': form.style.toJson(),
      'ui_type': _formLayoutToApi(form.layout),
      // 'is_template': form.isTemplate, // If applicable
      // versions are EXCLUDED to prevent overwrite
    };
  }

  static Map<String, dynamic> toVersionJson(BuilderForm form) {
    return {
      'version': form.version,
      'sections': form.sections.map((s) => s.toJson()).toList(),
      'created_at': DateTime.now().toIso8601String(),
    };
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
      normalized['layout'] = ui['layout_type'] ?? ui['layoutType'] ?? 'standard';
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
