import 'package:flutter/material.dart';
import 'package:frontend/shared/json_ui_engine/json_ui_engine.dart';
import 'package:frontend/shared/models/answer_value.dart';

class JsonUiPreviewPage extends StatefulWidget {
  const JsonUiPreviewPage({super.key});

  @override
  State<JsonUiPreviewPage> createState() => _JsonUiPreviewPageState();
}

class _JsonUiPreviewPageState extends State<JsonUiPreviewPage> {
  final Map<String, AnswerValue> _answers = {};

  final List<Map<String, dynamic>> _componentSchemas = [
    {
      'title': 'Short Text Input',
      'schema': {
        'id': 'short_text_1',
        'type': 'short_text',
        'label': 'First Name',
        'placeholder': 'Enter your first name'
      }
    },
    {
      'title': 'Paragraph Input',
      'schema': {
        'id': 'paragraph_1',
        'type': 'paragraph',
        'label': 'Cover Letter / Bio',
        'placeholder': 'Describe your professional background and motivation...'
      }
    },
    {
      'title': 'Password Input',
      'schema': {
        'id': 'password_1',
        'type': 'password',
        'label': 'Security Keyphrase',
        'placeholder': 'Enter a secure security keyphrase'
      }
    },
    {
      'title': 'Number Input',
      'schema': {
        'id': 'number_1',
        'type': 'number',
        'label': 'Base Value (Used for calculated field below)',
        'placeholder': 'Enter an integer (e.g., 21)'
      }
    },
    {
      'title': 'Email Input',
      'schema': {
        'id': 'email_1',
        'type': 'email',
        'label': 'Official Email Address',
        'placeholder': 'employee@hospital.org'
      }
    },
    {
      'title': 'Phone / Mobile Input',
      'schema': {
        'id': 'phone_1',
        'type': 'phone_number',
        'label': 'Emergency Contact Number',
        'placeholder': '+1 (555) 019-2834'
      }
    },
    {
      'title': 'Website URL Input',
      'schema': {
        'id': 'url_1',
        'type': 'url',
        'label': 'Portfolio or Github Profile',
        'placeholder': 'https://github.com/username'
      }
    },
    {
      'title': 'Dropdown Selection',
      'schema': {
        'id': 'dropdown_1',
        'type': 'dropdown',
        'label': 'Primary Department Assignment',
        'options': ['Cardiology Clinic', 'Neurology Department', 'Emergency Ward', 'Pediatric Unit']
      }
    },
    {
      'title': 'Multiple Choice (Radio Buttons)',
      'schema': {
        'id': 'multiple_choice_1',
        'type': 'multiple_choice',
        'label': 'Shift Preference Selector',
        'options': ['Morning Shift (08:00 - 16:00)', 'Evening Shift (16:00 - 00:00)', 'Night Shift (00:00 - 08:00)']
      }
    },
    {
      'title': 'Checkboxes (Multi-Select)',
      'schema': {
        'id': 'checkboxes_1',
        'type': 'checkboxes',
        'label': 'Specialized Skills / Certifications',
        'options': ['ACLS Certified', 'BLS Certified', 'PALS Certified', 'NICU Specialist']
      }
    },
    {
      'title': 'Number Stepper Field',
      'schema': {
        'id': 'stepper_1',
        'type': 'number_stepper',
        'label': 'Years of Specialized Experience'
      }
    },
    {
      'title': 'Toggle Switch Field',
      'schema': {
        'id': 'switch_1',
        'type': 'switch',
        'label': 'Accept Terms of On-Call Availability'
      }
    },
    {
      'title': 'Slider Input Widget',
      'schema': {
        'id': 'slider_1',
        'type': 'slider',
        'label': 'Weekly On-Call Hour Target Range',
        'min': 0.0,
        'max': 80.0,
        'divisions': 16
      }
    },
    {
      'title': 'Date Picker Field',
      'schema': {
        'id': 'date_1',
        'type': 'date',
        'label': 'Requested Start Date'
      }
    },
    {
      'title': 'Time Picker Field',
      'schema': {
        'id': 'time_1',
        'type': 'time',
        'label': 'Daily Clock-In Notification Target'
      }
    },
    {
      'title': 'Star Rating Input',
      'schema': {
        'id': 'rating_1',
        'type': 'rating',
        'label': 'Self-Evaluation Competency Score'
      }
    },
    {
      'title': 'File Picker Component',
      'schema': {
        'id': 'file_1',
        'type': 'file',
        'label': 'Medical Certificate / Licensing PDF'
      }
    },
    {
      'title': 'Location / Coordinates Picker',
      'schema': {
        'id': 'location_1',
        'type': 'location_picker',
        'label': 'Preferred Field Duty GPS Location'
      }
    },
    {
      'title': 'Barcode / QR Scanner Field',
      'schema': {
        'id': 'barcode_1',
        'type': 'barcode_scanner',
        'label': 'Asset Serial Number / QR Code'
      }
    },
    {
      'title': 'Calculated Field (Formula: Base Value * 2)',
      'schema': {
        'id': 'calculated_1',
        'type': 'calculated_field',
        'label': 'Calculated Training Capacity (2x Base Value)',
        'expression': '{number_1} * 2'
      }
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      appBar: AppBar(
        title: const Text(
          'JsonUiEngine Component Gallery',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E24),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dynamic Schema Verification Playground',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Interactive testing catalog for the JSON-to-UI rendering engine. Fill values to verify responsive validation and formula execution.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _componentSchemas.length,
              itemBuilder: (context, index) {
                final item = _componentSchemas[index];
                final String title = item['title'];
                final Map<String, dynamic> schema = item['schema'];
                final String id = schema['id'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E24),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2E2E38)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E2E38),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF43A047),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Type: ${schema['type']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Renderer space
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Theme(
                          data: ThemeData.dark().copyWith(
                            primaryColor: const Color(0xFF43A047),
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xFF43A047),
                              secondary: Color(0xFF43A047),
                              surface: Color(0xFF1E1E24),
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              filled: true,
                              fillColor: Color(0xFF121214),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          child: JsonUiEngine(
                            schema: schema,
                            answers: _answers,
                            onAnswerChanged: (key, value) {
                              setState(() {
                                _answers[key] = value;
                              });
                            },
                          ),
                        ),
                      ),
                      // Current State Output
                      if (_answers.containsKey(id))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF15151A),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(11),
                              bottomRight: Radius.circular(11),
                            ),
                          ),
                          child: Text(
                            'State value: ${_answers[id]?.value} (Display: ${_answers[id]?.displayValue})',
                            style: const TextStyle(
                              color: Color(0xFF81C784),
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
