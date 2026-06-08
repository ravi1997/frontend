import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/modules/dashboard/models/project_summary.dart';

void main() {
  group('ProjectSummary.fromJson Member Parsing', () {
    test('should parse collaborators from members field', () {
      final json = {
        'id': '1',
        'title': 'Project 1',
        'members': ['alice@test.com', 'bob@test.com'],
      };

      final project = ProjectSummary.fromJson(json);

      expect(project.collaborators, containsAll(['alice@test.com', 'bob@test.com']));
      expect(project.members, 2);
    });

    test('should parse collaborators from role-based fields', () {
      final json = {
        'id': '1',
        'title': 'Project 1',
        'editors': ['alice@test.com'],
        'viewers': ['bob@test.com'],
        'submitters': ['charlie@test.com'],
      };

      final project = ProjectSummary.fromJson(json);

      expect(
        project.collaborators,
        containsAll(['alice@test.com', 'bob@test.com', 'charlie@test.com']),
      );
      expect(project.members, 3);
    });

    test('should deduplicate collaborators across fields', () {
      final json = {
        'id': '1',
        'title': 'Project 1',
        'members': ['alice@test.com'],
        'editors': ['alice@test.com', 'bob@test.com'],
      };

      final project = ProjectSummary.fromJson(json);

      expect(project.collaborators, hasLength(2));
      expect(project.collaborators, containsAll(['alice@test.com', 'bob@test.com']));
    });

    test('should handle empty members list', () {
      final json = {
        'id': '1',
        'members': [],
      };

      final project = ProjectSummary.fromJson(json);

      expect(project.collaborators, isEmpty);
      expect(project.members, 0);
    });

    test('should handle missing member fields gracefully', () {
      final json = {
        'id': '1',
      };

      final project = ProjectSummary.fromJson(json);

      expect(project.collaborators, isEmpty);
      expect(project.members, 0);
    });

    test('should handle malformed member data (String instead of List)', () {
      final json = {
        'id': '1',
        'members': 'some string data',
      };

      final project = ProjectSummary.fromJson(json);

      expect(project.collaborators, isEmpty);
      expect(project.members, 0);
    });
  });
}
