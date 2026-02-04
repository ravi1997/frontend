import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/form_template.dart';
import '../../domain/entities/form_question.dart';
import '../../domain/entities/form_section.dart';
import '../../domain/entities/builder_form.dart';
import '../../domain/entities/question_type.dart';
import '../../domain/repositories/template_library_repository.dart';

/// Implementation of TemplateLibraryRepository.
///
/// Provides pre-built form templates and manages template operations.
class TemplateLibraryRepositoryImpl implements TemplateLibraryRepository {
  final Dio _apiClient;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

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
    } catch (e) {
      _logger.w('Failed to fetch templates from API, using defaults: $e');
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
    } catch (e) {
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
    } catch (e) {
      _logger.w('API create form failed, creating locally: $e');
      // Fallback: create form locally from template
      final template = await getTemplateById(templateId);
      final newForm = BuilderForm(
        id: _uuid.v4(),
        title: formName,
        sections: template.form.sections,
        status: 'draft',
        isPublished: false,
        version: '1.0.0',
        isLatest: true,
        layout: template.form.layout,
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
    } catch (e) {
      // Silently fail for offline mode
      _logger.d('Failed to increment usage count: $e');
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
    } catch (e) {
      _logger.w('API create template failed, creating locally: $e');
      // Fallback: create template locally
      final templateId = _uuid.v4();
      return FormTemplate(
        id: templateId,
        name: templateName,
        description: description,
        category: category,
        form: BuilderForm(id: formId, title: templateName, sections: []),
        tags: tags,
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    try {
      await _apiClient.delete('/templates/$templateId');
    } catch (e) {
      _logger.e('Failed to delete template: $e');
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
        type: QuestionType.shortText,
        label: {'en': 'Full Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.email,
        label: {'en': 'Email Address'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.mobile,
        label: {'en': 'Phone Number'},
        isRequired: false,
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.paragraph,
        label: {'en': 'Message'},
        isRequired: true,
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Contact Information'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'contact-template',
      title: {'en': 'Contact Form'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-contact',
      name: 'Contact Form',
      description:
          'A simple contact form for collecting inquiries and messages.',
      category: FormTemplateCategory.contact,
      form: form,
      tags: ['contact', 'simple', 'inquiry'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createSurveyFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        type: QuestionType.shortText,
        label: {'en': 'Your Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.rating,
        label: {'en': 'How satisfied are you with our service?'},
        isRequired: true,
        metadata: {'min': 1, 'max': 5},
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.multipleChoice,
        label: {'en': 'How did you hear about us?'},
        isRequired: true,
        options: [
          'Social Media',
          'Friend/Family',
          'Search Engine',
          'Advertisement',
          'Other',
        ],
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.paragraph,
        label: {'en': 'Any additional comments or feedback?'},
        isRequired: false,
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Survey Questions'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'survey-template',
      title: {'en': 'Customer Satisfaction Survey'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-survey',
      name: 'Customer Satisfaction Survey',
      description: 'Collect feedback and measure customer satisfaction.',
      category: FormTemplateCategory.survey,
      form: form,
      tags: ['survey', 'feedback', 'satisfaction'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createRegistrationFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        type: QuestionType.shortText,
        label: {'en': 'First Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.shortText,
        label: {'en': 'Last Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.email,
        label: {'en': 'Email Address'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.mobile,
        label: {'en': 'Phone Number'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q5',
        type: QuestionType.dropdown,
        label: {'en': 'Country'},
        isRequired: true,
        options: [
          'United States',
          'United Kingdom',
          'Canada',
          'Australia',
          'Other',
        ],
      ),
      FormQuestion(
        id: 'q6',
        type: QuestionType.checkboxes,
        label: {'en': 'I agree to the terms and conditions'},
        isRequired: true,
        options: ['I agree'],
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Personal Information'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'registration-template',
      title: {'en': 'Event Registration'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-registration',
      name: 'Event Registration',
      description:
          'Register attendees for your event with this comprehensive form.',
      category: FormTemplateCategory.registration,
      form: form,
      tags: ['registration', 'event', 'attendee'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createEventRegistrationTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        type: QuestionType.shortText,
        label: {'en': 'Event Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.date,
        label: {'en': 'Event Date'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.time,
        label: {'en': 'Event Time'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.shortText,
        label: {'en': 'Venue/Location'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q5',
        type: QuestionType.number,
        label: {'en': 'Number of Attendees'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q6',
        type: QuestionType.multipleChoice,
        label: {'en': 'Event Type'},
        isRequired: true,
        options: ['Conference', 'Workshop', 'Webinar', 'Meetup', 'Other'],
      ),
      FormQuestion(
        id: 'q7',
        type: QuestionType.paragraph,
        label: {'en': 'Event Description'},
        isRequired: false,
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Event Details'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'event-template',
      title: {'en': 'Event Planning Form'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-event',
      name: 'Event Planning Form',
      description:
          'Plan and organize your events with this comprehensive form.',
      category: FormTemplateCategory.event,
      form: form,
      tags: ['event', 'planning', 'organization'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createFeedbackFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        type: QuestionType.rating,
        label: {'en': 'Overall Experience'},
        isRequired: true,
        metadata: {'min': 1, 'max': 10},
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.rating,
        label: {'en': 'Quality of Service'},
        isRequired: true,
        metadata: {'min': 1, 'max': 5},
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.multipleChoice,
        label: {'en': 'Would you recommend us?'},
        isRequired: true,
        options: [
          'Definitely',
          'Probably',
          'Maybe',
          'Probably Not',
          'Definitely Not',
        ],
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.checkboxes,
        label: {'en': 'What did you like?'},
        isRequired: false,
        options: [
          'Customer Service',
          'Product Quality',
          'Pricing',
          'User Experience',
          'Speed of Delivery',
        ],
      ),
      FormQuestion(
        id: 'q5',
        type: QuestionType.paragraph,
        label: {'en': 'How can we improve?'},
        isRequired: false,
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Feedback Questions'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'feedback-template',
      title: {'en': 'Product Feedback Form'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-feedback',
      name: 'Product Feedback Form',
      description: 'Collect detailed feedback about your products or services.',
      category: FormTemplateCategory.feedback,
      form: form,
      tags: ['feedback', 'product', 'improvement'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }

  FormTemplate _createOrderFormTemplate() {
    final questions = [
      FormQuestion(
        id: 'q1',
        type: QuestionType.shortText,
        label: {'en': 'Customer Name'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q2',
        type: QuestionType.email,
        label: {'en': 'Email Address'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q3',
        type: QuestionType.mobile,
        label: {'en': 'Phone Number'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q4',
        type: QuestionType.shortText,
        label: {'en': 'Shipping Address'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q5',
        type: QuestionType.shortText,
        label: {'en': 'City'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q6',
        type: QuestionType.shortText,
        label: {'en': 'State/Province'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q7',
        type: QuestionType.shortText,
        label: {'en': 'ZIP/Postal Code'},
        isRequired: true,
      ),
      FormQuestion(
        id: 'q8',
        type: QuestionType.paragraph,
        label: {'en': 'Order Notes'},
        isRequired: false,
      ),
    ];

    final section = FormSection(
      id: 's1',
      title: {'en': 'Shipping Information'},
      questions: questions,
    );

    final form = BuilderForm(
      id: 'order-template',
      title: {'en': 'Order Form'},
      sections: [section],
      status: 'template',
      isPublished: true,
    );

    return FormTemplate(
      id: 'tpl-order',
      name: 'Order Form',
      description: 'Collect shipping and order information from customers.',
      category: FormTemplateCategory.order,
      form: form,
      tags: ['order', 'shipping', 'ecommerce'],
      usageCount: 0,
      createdAt: DateTime.now(),
    );
  }
}
