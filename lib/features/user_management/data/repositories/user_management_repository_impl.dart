import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/api_client_wrapper.dart';
import '../../../../core/network/api_endpoints.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

part 'user_management_repository_impl.g.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class UserActivityEvent {
  final String type;
  final String label;
  final String? timestamp;
  final String icon;
  final String color;
  final String? detail;

  UserActivityEvent({
    required this.type,
    required this.label,
    this.timestamp,
    required this.icon,
    required this.color,
    this.detail,
  });

  factory UserActivityEvent.fromJson(Map<String, dynamic> json) {
    return UserActivityEvent(
      type: json['type'] ?? '',
      label: json['label'] ?? '',
      timestamp: json['timestamp'],
      icon: json['icon'] ?? 'info',
      color: json['color'] ?? 'gray',
      detail: json['detail'],
    );
  }
}

class UserActivity {
  final String userId;
  final String username;
  final int failedLoginAttempts;
  final int otpResendCount;
  final bool isLocked;
  final bool isPasswordExpired;
  final List<UserActivityEvent> events;

  UserActivity({
    required this.userId,
    required this.username,
    required this.failedLoginAttempts,
    required this.otpResendCount,
    required this.isLocked,
    required this.isPasswordExpired,
    required this.events,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    final eventsJson = json['events'] as List? ?? [];
    return UserActivity(
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      otpResendCount: json['otp_resend_count'] ?? 0,
      isLocked: json['is_locked'] ?? false,
      isPasswordExpired: json['is_password_expired'] ?? false,
      events: eventsJson
          .map((e) => UserActivityEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─── Repository Abstract ──────────────────────────────────────────────────────

abstract class UserManagementRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(String userId);
  Future<List<String>> getDepartments();
  Future<void> updateUserDepartment(String userId, String department);
  Future<void> updateUserStatus(String userId, bool isActive);
  Future<void> updateUserRoles(String userId, List<String> roles);
  Future<void> resetUserPassword(String userId, String newPassword);
  Future<void> lockUser(String userId);
  Future<void> unlockUser(String userId);
  Future<void> deleteUser(String userId);
  Future<UserActivity> getUserActivity(String userId);
}

// ─── Provider ─────────────────────────────────────────────────────────────────

@riverpod
UserManagementRepository userManagementRepositoryImpl(Ref ref) {
  return UserManagementRepositoryImpl(ref.watch(apiClientProvider));
}

// ─── Implementation ───────────────────────────────────────────────────────────

class UserManagementRepositoryImpl implements UserManagementRepository {
  final ApiClient _client;

  UserManagementRepositoryImpl(this._client);

  @override
  Future<List<User>> getUsers() async {
    final response = await _client.get(ApiEndpoints.adminListUsers);
    return (response.data as List).map((e) => User.fromJson(e)).toList();
  }

  @override
  Future<User> getUserById(String userId) async {
    final response = await _client.get(ApiEndpoints.adminGetUser(userId));
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<String>> getDepartments() async {
    final response = await _client.get(ApiEndpoints.adminListDepartments);
    final data = response.data;
    if (data == null) return [];
    return (data as List).cast<String>();
  }

  @override
  Future<void> updateUserDepartment(String userId, String department) async {
    await _client.patch(
      ApiEndpoints.adminUpdateUserDepartment(userId),
      data: {'department': department},
    );
  }

  @override
  Future<void> updateUserStatus(String userId, bool isActive) async {
    await _client.patch(
      ApiEndpoints.adminSetUserStatus(userId),
      data: {'is_active': isActive},
    );
  }

  @override
  Future<void> updateUserRoles(String userId, List<String> roles) async {
    await _client.patch(
      ApiEndpoints.adminUpdateUserRoles(userId),
      data: {'roles': roles},
    );
  }

  @override
  Future<void> resetUserPassword(String userId, String newPassword) async {
    await _client.post(
      ApiEndpoints.adminResetUserPassword(userId),
      data: {'new_password': newPassword},
    );
  }

  @override
  Future<void> lockUser(String userId) async {
    await _client.post(ApiEndpoints.adminLockUser(userId));
  }

  @override
  Future<void> unlockUser(String userId) async {
    await _client.post(ApiEndpoints.adminUnlockUser(userId));
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _client.delete(ApiEndpoints.adminDeleteUser(userId));
  }

  @override
  Future<UserActivity> getUserActivity(String userId) async {
    // Backend only provides lock-status endpoint, not full activity
    // Map the lock-status response to UserActivity
    final response = await _client.get(ApiEndpoints.getLockStatus(userId));
    final data = response.data as Map<String, dynamic>;

    // Backend returns: { is_locked, lock_until, failed_login_attempts }
    // Map to our UserActivity format with empty events (backend doesn't provide events)
    return UserActivity(
      userId: userId,
      username: '',
      failedLoginAttempts:
          (data['failed_login_attempts'] as num?)?.toInt() ?? 0,
      otpResendCount: 0,
      isLocked: data['is_locked'] as bool? ?? false,
      isPasswordExpired: false,
      events: [],
    );
  }
}
