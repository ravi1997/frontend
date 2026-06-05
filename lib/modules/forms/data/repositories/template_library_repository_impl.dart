import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:frontend/modules/forms/models/form_template.dart';
import 'package:frontend/shared/models/form_models.dart';
import 'package:frontend/modules/forms/services/template_library_repository.dart';

/// Implementation of TemplateLibraryRepository.
///
/// Provides pre-built form templates and manages template operations.
class TemplateLibraryRepositoryImpl implements TemplateLibraryRepository {
  final Dio _apiClient;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  List<Map<String, dynamic>> _createOptions(List<String> labels) {
    return labels.asMap().entries.map((entry) {
      return {
        'id': _uuid.v4(),
        'label': entry.value,
        'value': entry.value,
        'order': entry.key,
      };
    }).toList();
  }

  TemplateLibraryRepositoryImpl(this._apiClient);

  // Cache for templates
  List<FormTemplate>? _cachedTemplates;

  @override
  Future<List<FormTemplate>> getAllTemplates() async {
    if (_cachedTemplates != null) {
      return _cachedTemplates!;
    }

    try {
      final response = await _apiClient.get('/templates');
      final List<dynamic> data = response.data['templates'] ?? [];
      _cachedTemplates = data
          .map((json) => FormTemplate.fromJson(json))
          .toList();
      return _cachedTemplates!;
    } catch (e, s) {
      _logger.w(
        'Failed to fetch templates from API, using defaults',
        error: e,
        stackTrace: s,
      );
      // Return default templates if API fails
      _cachedTemplates = _getDefaultTemplates();
      return _cachedTemplates!;
    }
  }

  @override
  Future<List<FormTemplate>> getTemplatesByCategory(
    FormTemplateCategory category,
  ) async {
    final allTemplates = await getAllTemplates();
    return allTemplates.where((t) => t.category == category).toList();
  }

  @override
  Future<List<FormTemplate>> getTemplatesByTag(String tag) async {
    final allTemplates = await getAllTemplates();
    return allTemplates.where((t) => t.tags.contains(tag)).toList();
  }

  @override
  Future<FormTemplate> getTemplateById(String templateId) async {
    try {
      final response = await _apiClient.get('/templates/$templateId');
      return FormTemplate.fromJson(response.data);
    } catch (e, s) {
      _logger.w(
        'Failed to fetch template by ID from API, using defaults',
        error: e,
        stackTrace: s,
      );
      final allTemplates = await getAllTemplates();
      final template = allTemplates.firstWhere(
        (t) => t.id == templateId,
        orElse: () => throw Exception('Template not found'),
      );
      return template;
    }
  }

  @override
  Future<String> createFormFromTemplate(
    String templateId,
    String formName,
  ) async {
    try {
      final response = await _apiClient.post(
        '/templates/$templateId/create-form',
        data: {'name': formName},
      );
      await incrementUsageCount(templateId);
      return response.data['formId'];
    } catch (e, s) {
      _logger.w(
        'API create form failed, creating locally',
        error: e,
        stackTrace: s,
      );
      // Fallback: create form locally from template
      final template = await getTemplateById(templateId);
      final newForm = BuilderForm(
        id: _uuid.v4(),
        title: formName,
        slug: formName.toLowerCase().replaceAll(' ', '-'),
        organizationId: 'default',
        createdBy: 'system',
        status: 'draft',
        activeVersion: '1.0.0',
        versions: [
          FormVersion(
            id: _uuid.v4(),
            version: '1.0.0',
            sections: template.form.sections,
          ),
        ],
        uiType: template.form.uiType,
        style: template.form.style,
      );
      // Save the form (this would normally call the form repository)
      await _apiClient.post('/forms', data: newForm.toJson());
      await incrementUsageCount(templateId);
      return newForm.id;
    }
  }

  @override
  Future<void> incrementUsageCount(String templateId) async {
    try {
      await _apiClient.post('/templates/$templateId/increment-usage');
    } catch (e, s) {
      // Silently fail for offline mode
      _logger.d('Failed to increment usage count', error: e, stackTrace: s);
    }
  }

  @override
  Future<FormTemplate> createCustomTemplate(
    String formId,
    String templateName,
    String description,
    FormTemplateCategory category,
    List<String> tags,
  ) async {
    try {
      final response = await _apiClient.post(
        '/templates',
        data: {
          'formId': formId,
          'name': templateName,
          'description': description,
          'category': category.name,
          'tags': tags,
        },
      );
      return FormTemplate.fromJson(response.data);
    } catch (e, s) {
      _logger.w(
        'API create template failed, creating locally',
        error: e,
        stackTrace: s,
      );
      // Fallback: create template locally
      final templateId = _uuid.v4();
      return FormTemplate(
        id: templateId,
        name: templateName,
        description: description,
        category: category,
        form: BuilderForm(
          id: formId,
          title: templateName,
          slug: templateName.toLowerCase().replaceAll(' ', '-'),
          organizationId: 'default',
          createdBy: 'system',
          versions: const [],
        ),
        tags: tags,
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    try {
      await _apiClient.delete('/templates/$templateId');
    } catch (e, s) {
      _logger.e('Failed to delete template', error: e, stackTrace: s);
      throw Exception('Failed to delete template');
    }
  }

  @override
  Future<List<FormTemplate>> searchTemplates(String query) async {
    final allTemplates = await getAllTemplates();
    final lowerQuery = query.toLowerCase();
    return allTemplates
        .where(
          (t) =>
              t.name.toLowerCase().contains(lowerQuery) ||
              t.description.toLowerCase().contains(lowerQuery) ||
              t.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  /// Returns the default pre-built templates.
  List<FormTemplate> _getDefaultTemplates() {
    return [
      _createContactFormTemplate(),
      _createSurveyFormTemplate(),
      _createRegistrationFormTemplate(),
      _createEventRegistrationTemplate(),
      _createFeedbackFormTemplate(),
      _createOrderFormTemplate(),
    ];
  }

  FormTemplate _createContactFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'shortText',
        label: 'Full Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'email',
        label: 'Email Address',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'mobile',
        label: 'Phone Number',
        validation: const {'is_required': false},
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'paragraph',
        label: 'Message',
        validation: const {'is_required': true},
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Contact Information',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'contact-template',
      title: 'Contact Form',
      slug: 'contact-form',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'contact-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-contact',
      name: 'Contact Form',
      description:
          'A simple contact form for collecting inquiries and messages.',
      category: FormTemplateCategory.contact,
      form: form,
      tags: const ['contact', 'simple', 'inquiry'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createSurveyFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'shortText',
        label: 'Your Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'rating',
        label: 'How satisfied are you with our service?',
        validation: const {'is_required': true},
        metadata: const {'min': 1, 'max': 5},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'multipleChoice',
        label: 'How did you hear about us?',
        validation: const {'is_required': true},
        options: _createOptions([
          'Social Media',
          'Friend/Family',
          'Search Engine',
          'Advertisement',
          'Other',
        ]),
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'paragraph',
        label: 'Any additional comments or feedback?',
        validation: const {'is_required': false},
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Survey Questions',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'survey-template',
      title: 'Customer Satisfaction Survey',
      slug: 'customer-satisfaction-survey',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'survey-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-survey',
      name: 'Customer Satisfaction Survey',
      description: 'Collect feedback and measure customer satisfaction.',
      category: FormTemplateCategory.survey,
      form: form,
      tags: const ['survey', 'feedback', 'satisfaction'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createRegistrationFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'shortText',
        label: 'First Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'shortText',
        label: 'Last Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'email',
        label: 'Email Address',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'mobile',
        label: 'Phone Number',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q5',
        fieldType: 'dropdown',
        label: 'Country',
        validation: const {'is_required': true},
        options: _createOptions([
          'United States',
          'United Kingdom',
          'Canada',
          'Australia',
          'Other',
        ]),
      ),
      FormQuestion(
        id: 'q6',
        fieldType: 'checkboxes',
        label: 'I agree to the terms and conditions',
        validation: const {'is_required': true},
        options: _createOptions(['I agree']),
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Personal Information',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'registration-template',
      title: 'Event Registration',
      slug: 'event-registration',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'registration-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-registration',
      name: 'Event Registration',
      description:
          'Register attendees for your event with this comprehensive form.',
      category: FormTemplateCategory.registration,
      form: form,
      tags: const ['registration', 'event', 'attendee'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createEventRegistrationTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'shortText',
        label: 'Event Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'date',
        label: 'Event Date',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'time',
        label: 'Event Time',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'shortText',
        label: 'Venue/Location',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q5',
        fieldType: 'number',
        label: 'Number of Attendees',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q6',
        fieldType: 'multipleChoice',
        label: 'Event Type',
        validation: const {'is_required': true},
        options: _createOptions([
          'Conference',
          'Workshop',
          'Webinar',
          'Meetup',
          'Other',
        ]),
      ),
      FormQuestion(
        id: 'q7',
        fieldType: 'paragraph',
        label: 'Event Description',
        validation: const {'is_required': false},
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Event Details',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'event-template',
      title: 'Event Planning Form',
      slug: 'event-planning-form',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'event-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-event',
      name: 'Event Planning Form',
      description:
          'Plan and organize your events with this comprehensive form.',
      category: FormTemplateCategory.event,
      form: form,
      tags: const ['event', 'planning', 'organization'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createFeedbackFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'rating',
        label: 'Overall Experience',
        validation: const {'is_required': true},
        metadata: const {'min': 1, 'max': 10},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'rating',
        label: 'Quality of Service',
        validation: const {'is_required': true},
        metadata: const {'min': 1, 'max': 5},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'multipleChoice',
        label: 'Would you recommend us?',
        validation: const {'is_required': true},
        options: _createOptions([
          'Definitely',
          'Probably',
          'Maybe',
          'Probably Not',
          'Definitely Not',
        ]),
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'checkboxes',
        label: 'What did you like?',
        validation: const {'is_required': false},
        options: _createOptions([
          'Customer Service',
          'Product Quality',
          'Pricing',
          'User Experience',
          'Speed of Delivery',
        ]),
      ),
      FormQuestion(
        id: 'q5',
        fieldType: 'paragraph',
        label: 'How can we improve?',
        validation: const {'is_required': false},
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Feedback Questions',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'feedback-template',
      title: 'Product Feedback Form',
      slug: 'product-feedback-form',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'feedback-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-feedback',
      name: 'Product Feedback Form',
      description: 'Collect detailed feedback about your products or services.',
      category: FormTemplateCategory.feedback,
      form: form,
      tags: const ['feedback', 'product', 'improvement'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createOrderFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        fieldType: 'shortText',
        label: 'Customer Name',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q2',
        fieldType: 'email',
        label: 'Email Address',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q3',
        fieldType: 'mobile',
        label: 'Phone Number',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q4',
        fieldType: 'shortText',
        label: 'Shipping Address',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q5',
        fieldType: 'shortText',
        label: 'City',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q6',
        fieldType: 'shortText',
        label: 'State/Province',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q7',
        fieldType: 'shortText',
        label: 'ZIP/Postal Code',
        validation: const {'is_required': true},
      ),
      FormQuestion(
        id: 'q8',
        fieldType: 'paragraph',
        label: 'Order Notes',
        validation: const {'is_required': false},
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: 'Shipping Information',
      questions: questions,
    );

    final form = BuilderForm(
      id: 'order-template',
      title: 'Order Form',
      slug: 'order-form',
      organizationId: 'default',
      createdBy: 'system',
      status: 'template',
      activeVersion: '1.0.0',
      versions: [
        FormVersion(
          id: 'order-v1',
          version: '1.0.0',
          sections: [section],
        ),
      ],
    );

    return FormTemplate(
      id: 'tpl-order',
      name: 'Order Form',
      description: 'Collect shipping and order information from customers.',
      category: FormTemplateCategory.order,
      form: form,
      tags: const ['order', 'shipping', 'ecommerce'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }
}
