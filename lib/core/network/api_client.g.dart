// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dio HTTP client provider with authentication, error handling, and retry logic.
///
/// This provider creates and configures a Dio instance with:
/// - JWT authentication with automatic token refresh
/// - Request/response logging for debugging
/// - Centralized error handling and user notifications
/// - Connection and timeout configurations

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Dio HTTP client provider with authentication, error handling, and retry logic.
///
/// This provider creates and configures a Dio instance with:
/// - JWT authentication with automatic token refresh
/// - Request/response logging for debugging
/// - Centralized error handling and user notifications
/// - Connection and timeout configurations

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Dio HTTP client provider with authentication, error handling, and retry logic.
  ///
  /// This provider creates and configures a Dio instance with:
  /// - JWT authentication with automatic token refresh
  /// - Request/response logging for debugging
  /// - Centralized error handling and user notifications
  /// - Connection and timeout configurations
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'9dca44a9ac1d356dde45e1f6431c012f6142f7b2';
