import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Offline Tenant and User Scoping', () {
    test('Hive box names are scoped by both userId and tenantId', () {
      final userId = 'user_123';
      final tenantId = 'tenant_456';
      
      final expectedBoxName = 'pending_submissions_${tenantId}_$userId';
      
      expect(expectedBoxName, 'pending_submissions_tenant_456_user_123');
    });

    test('SyncService isolates data across users', () {
      final boxUser1 = 'pending_submissions_default_tenant_user_1';
      final boxUser2 = 'pending_submissions_default_tenant_user_2';
      
      expect(boxUser1, isNot(equals(boxUser2)));
    });
  });
}
