import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    test('should create User from JSON', () {
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'username': 'testuser',
        'user_type': 'Admin',
      };

      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.username, 'testuser');
      expect(user.userType, 'Admin');
    });

    test('should convert User to JSON', () {
      const user = User(
        id: '1',
        email: 'test@example.com',
        username: 'testuser',
        userType: 'Admin',
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['email'], 'test@example.com');
      expect(json['username'], 'testuser');
      expect(json['user_type'], 'Admin');
    });
  });
}
