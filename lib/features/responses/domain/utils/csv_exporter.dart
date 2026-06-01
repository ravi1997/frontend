import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/form_models.dart';
import 'package:frontend/features/responses/domain/entities/form_response.dart';

class CsvExporter {
  /// Generates a CSV string from a list of [FormResponse] objects and the corresponding [BuilderForm].
  static String generateCsv(List<FormResponse> responses, BuilderForm form) {
    // 1. Build Map of Questions recursively (Question ID -> Question object)
    // We iterate through all sections and nested sub-sections to find all questions.
    final Map<String, Question> questionsMap = {};

    void collectQuestions(List<Section> sections) {
      for (var section in sections) {
        for (var question in section.questions) {
          questionsMap[question.id] = question;
        }
        if (section.sections.isNotEmpty) {
          collectQuestions(section.sections);
        }
      }
    }

    collectQuestions(form.sections);

    // 2. Create CSV Data List
    final List<List<dynamic>> rows = [];

    // Add Headers: 'Submission Date' followed by all Question Labels
    final headers = [
      'Submission Date',
      ...questionsMap.values.map((q) => q.label.toString())
    ];
    rows.add(headers);

    // 3. Add Rows: Map each response to the columns
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    for (var response in responses) {
      final row = <dynamic>[
        response.submittedAt != null
            ? dateFormat.format(response.submittedAt!)
            : 'Unknown',
      ];

      // For each question, find the corresponding answer in the response.
      // We check both the question ID and the variableName for maximum compatibility.
      for (var entry in questionsMap.entries) {
        final qId = entry.key;
        final question = entry.value;
        var answer = response.answers[qId];
        if (answer == null && question.variableName != null) {
          answer = response.answers[question.variableName!];
        }

        if (answer == null) {
          row.add('');
        } else if (answer is List) {
          row.add(answer.join(', '));
        } else if (answer is Map) {
          row.add(
            answer.entries.map((e) => '${e.key}: ${e.value}').join('; '),
          );
        } else {
          row.add(answer);
        }
      }
      rows.add(row);
    }

    // 4. Convert to CSV String using the csv package
    return const ListToCsvConverter().convert(rows);
  }
}
