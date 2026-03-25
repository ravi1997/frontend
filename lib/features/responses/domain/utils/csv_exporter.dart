import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:frontend/features/form_builder/domain/entities/builder_form.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';

class CsvExporter {
  /// Generates a CSV string from a list of [FormResponse] objects and the corresponding [BuilderForm].
  static String generateCsv(List<FormResponse> responses, BuilderForm form) {
    // 1. Build Header Map (Question ID -> Label)
    // We iterate through all sections and questions to map IDs to Labels.
    // This ensures we have the correct column headers.
    final Map<String, String> questionHeaders = {};
    for (var section in form.sections) {
      for (var question in section.questions) {
        questionHeaders[question.id] = question.label?.toString() ?? '';
      }
    }

    // 2. Create CSV Data List
    final List<List<dynamic>> rows = [];

    // Add Headers: 'Submission Date' followed by all Question Labels
    final headers = ['Submission Date', ...questionHeaders.values];
    rows.add(headers);

    // 3. Add Rows: Map each response to the columns
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    for (var response in responses) {
      final row = <dynamic>[
        response.submittedAt != null
            ? dateFormat.format(response.submittedAt!)
            : 'Unknown',
      ];

      // For each question header, find the corresponding answer in the response.
      // If no answer exists, use an empty string.
      for (var qId in questionHeaders.keys) {
        row.add(response.answers[qId] ?? '');
      }
      rows.add(row);
    }

    // 4. Convert to CSV String using the csv package
    return const ListToCsvConverter().convert(rows);
  }
}
