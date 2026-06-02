import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/error_handler.dart';

/// Base mixin for all controllers providing common error handling and state management.
///
/// This mixin provides standardized error handling, loading states, and common
/// CRUD operations that are repeated across multiple controllers.
mixin BaseControllerMixin {
  void _logError(String context, Object error, StackTrace st) {
    final message = ErrorHandler.handle(error);
    debugPrint('$context: $message');
    if (kDebugMode) {
      debugPrint(st.toString());
    }
  }

  /// Wrapper for async operations with standardized error handling.
  ///
  /// Usage:
  /// ```dart
  /// await executeOperation(
  ///   operation: () => repository.someMethod(),
  ///   onError: (error) {
  ///     // Handle specific error
  ///   }
  /// );
  /// ```
  Future<R?> executeOperation<R>({
    required Future<R> Function() operation,
    void Function(Object error)? onError,
    bool showLoading = true,
  }) async {
    try {
      return await operation();
    } catch (e, st) {
      if (onError != null) {
        onError(e);
      } else {
        _logError('Operation failed', e, st);
      }
      return null;
    }
  }

  /// Execute an operation that refreshes data.
  ///
  /// Common pattern for refresh operations.
  Future<void> executeRefresh({
    required Future<void> Function() refreshOperation,
    String? loadingStateKey,
  }) async {
    try {
      await refreshOperation();
    } catch (e, st) {
      _logError('Refresh failed', e, st);
    }
  }

  /// Generic CRUD delete operation.
  ///
  /// Standardizes delete operations across controllers.
  Future<bool> executeDelete<R>({
    required String id,
    required Future<void> Function(String id) deleteOperation,
    required Future<void> Function() refreshAfterDelete,
    String? entityName,
  }) async {
    try {
      await deleteOperation(id);
      await refreshAfterDelete();
      return true;
    } catch (e, st) {
      _logError('Failed to delete ${entityName ?? 'entity'}', e, st);
      return false;
    }
  }

  /// Generic CRUD update operation.
  ///
  /// Standardizes update operations across controllers.
  Future<bool> executeUpdate<R>({
    required R item,
    required Future<R> Function(R item) updateOperation,
    String? entityName,
  }) async {
    try {
      await updateOperation(item);
      return true;
    } catch (e, st) {
      _logError('Failed to update ${entityName ?? 'entity'}', e, st);
      return false;
    }
  }

  /// Generic CRUD create operation.
  ///
  /// Standardizes create operations across controllers.
  Future<R?> executeCreate<R>({
    required Future<R> Function() createOperation,
    String? entityName,
  }) async {
    try {
      return await createOperation();
    } catch (e, st) {
      _logError('Failed to create ${entityName ?? 'entity'}', e, st);
      return null;
    }
  }

  /// Safely get the current value from an AsyncValue.
  ///
  /// Returns null if loading, has error, or value is null.
  T? safeValue<T>(AsyncValue<T> asyncValue) {
    if (asyncValue.isLoading || asyncValue.hasError) {
      return null;
    }
    return asyncValue.value;
  }

  /// Check if a state is in loading state.
  bool isLoading(AsyncValue? state) {
    return state?.isLoading == true;
  }

  /// Check if a state has an error.
  bool hasError(AsyncValue? state) {
    return state?.hasError == true;
  }
}
