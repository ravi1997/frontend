import '../../domain/entities/builder_form.dart';
import '../../domain/entities/form_section.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../dto/form_dto.dart';

class FormMapper {
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
    List<Map<String, dynamic>> sections = versionData?.sections ?? [];

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': dto.id,
      'title': dto.title,
      'status': dto.status,
      'isPublished': dto.status == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': sections,
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
    List<dynamic> sections = versionData?['sections'] ?? [];

    // Transform to frontend format
    final Map<String, dynamic> transformedData = {
      'id': mapData['id'] ?? mapData['_id'],
      'title': mapData['title'] ?? 'Untitled Form',
      'status': mapData['status'] ?? 'draft',
      'isPublished': mapData['status'] == 'published',
      'version': activeVersion,
      'isLatest': true,
      'sections': sections.cast<Map<String, dynamic>>().toList(),
      'updatedAt': mapData['updated_at'],
      'workflows': mapData['workflows'] ?? <String, dynamic>{},
      'accessPolicy': mapData['access_policy'],
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

  static Map<String, dynamic> toBackendJson(BuilderForm form) {
    // Legacy support or new creation (initial version)
    return {
      'title': form.title,
      'status': form.status,
      'slug': form.id,
      'versions': [
        {
          'version': form.version,
          'sections': form.sections.map((s) => s.toJson()).toList(),
          'created_at': DateTime.now().toIso8601String(),
        },
      ],
      'active_version': form.version,
      'workflows': form.workflows,
      'access_policy': form.accessPolicy.toJson(),
    };
  }

  static Map<String, dynamic> toFormMetadataJson(BuilderForm form) {
    return {
      'title': form.title,
      'status': form.status,
      'slug': form.id,
      'active_version': form.version,
      'workflows': form.workflows,
      'access_policy': form.accessPolicy.toJson(),
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
}
