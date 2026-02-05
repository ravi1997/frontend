import 'dart:async';

/// Rate limiter configuration
class RateLimitConfig {
  final int maxAttempts;
  final Duration windowDuration;
  final Duration? lockoutDuration;
  final bool enableBackoff;

  const RateLimitConfig({
    required this.maxAttempts,
    required this.windowDuration,
    this.lockoutDuration,
    this.enableBackoff = true,
  });

  factory RateLimitConfig.defaultAuth() {
    return RateLimitConfig(
      maxAttempts: 5,
      windowDuration: Duration(minutes: 1),
      lockoutDuration: Duration(minutes: 15),
      enableBackoff: true,
    );
  }

  factory RateLimitConfig.defaultForm() {
    return RateLimitConfig(
      maxAttempts: 10,
      windowDuration: Duration(minutes: 1),
      lockoutDuration: null,
      enableBackoff: false,
    );
  }
}

/// Rate limiter result
class RateLimitResult {
  final bool allowed;
  final int? remainingAttempts;
  final Duration? retryAfter;
  final int? resetInSeconds;

  const RateLimitResult({
    required this.allowed,
    this.remainingAttempts,
    this.retryAfter,
    this.resetInSeconds,
  });

  factory RateLimitResult.allowed({int? remainingAttempts}) {
    return RateLimitResult(allowed: true, remainingAttempts: remainingAttempts);
  }

  factory RateLimitResult.denied({
    required Duration retryAfter,
    int? remainingAttempts,
  }) {
    return RateLimitResult(
      allowed: false,
      remainingAttempts: remainingAttempts,
      retryAfter: retryAfter,
      resetInSeconds: retryAfter.inSeconds,
    );
  }
}

/// Client-side rate limiter for API call protection
class RateLimiter {
  final String _key;
  final RateLimitConfig _config;
  final Map<String, List<DateTime>> _attempts = {};
  Timer? _cleanupTimer;

  RateLimiter(this._key, this._config) {
    _startCleanupTimer();
  }

  /// Attempts to perform an action, returns whether it's allowed
  RateLimitResult tryAcquire() {
    final now = DateTime.now();
    final windowStart = now.subtract(_config.windowDuration);

    // Get or create attempt list
    final attempts = _attempts[_key] ?? [];

    // Filter to only recent attempts
    attempts.removeWhere((time) => time.isBefore(windowStart));

    // Check if under limit
    if (attempts.length < _config.maxAttempts) {
      attempts.add(now);
      _attempts[_key] = attempts;

      return RateLimitResult.allowed(
        remainingAttempts: _config.maxAttempts - attempts.length,
      );
    }

    // Rate limited
    if (_config.lockoutDuration != null) {
      return RateLimitResult.denied(
        retryAfter: _config.lockoutDuration!,
        remainingAttempts: 0,
      );
    }

    // Calculate time until window resets
    final oldestAttempt = attempts.first;
    final resetIn = oldestAttempt.add(_config.windowDuration).difference(now);

    return RateLimitResult.denied(retryAfter: resetIn, remainingAttempts: 0);
  }

  /// Registers an attempt (for tracking purposes)
  void registerAttempt() {
    final now = DateTime.now();
    final windowStart = now.subtract(_config.windowDuration);

    final attempts = _attempts[_key] ?? [];
    attempts.removeWhere((time) => time.isBefore(windowStart));
    attempts.add(now);
    _attempts[_key] = attempts;
  }

  /// Gets the number of remaining attempts
  int getRemainingAttempts() {
    final now = DateTime.now();
    final windowStart = now.subtract(_config.windowDuration);

    final attempts = _attempts[_key] ?? [];
    attempts.removeWhere((time) => time.isBefore(windowStart));

    return (_config.maxAttempts - attempts.length).clamp(
      0,
      _config.maxAttempts,
    );
  }

  /// Resets the rate limiter for a specific key
  void reset() {
    _attempts.remove(_key);
  }

  /// Starts periodic cleanup of old attempts
  void _startCleanupTimer() {
    _cleanupTimer = Timer(const Duration(minutes: 5), () {
      final now = DateTime.now();
      final windowStart = now.subtract(_config.windowDuration);

      for (final key in _attempts.keys) {
        _attempts[key]?.removeWhere((time) => time.isBefore(windowStart));
      }

      _startCleanupTimer();
    });
  }

  /// Cleans up resources
  void dispose() {
    _cleanupTimer?.cancel();
  }
}

/// Exponential backoff calculator
class ExponentialBackoff {
  final int baseDelayMs;
  final int maxDelayMs;
  final double multiplier;
  final int maxRetries;

  ExponentialBackoff({
    this.baseDelayMs = 1000,
    this.maxDelayMs = 30000,
    this.multiplier = 2.0,
    this.maxRetries = 5,
  });

  /// Calculates delay for a given retry attempt
  Duration getDelay(int retryCount) {
    if (retryCount >= maxRetries) return Duration(milliseconds: maxDelayMs);

    final delay = baseDelayMs * _pow(multiplier, retryCount);
    return Duration(milliseconds: delay.clamp(0, maxDelayMs).toInt());
  }

  int _pow(double base, int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result = (result * base).toInt();
    }
    return result;
  }

  /// Gets the total delay including jitter (random variation)
  Duration getDelayWithJitter(int retryCount) {
    final baseDelay = getDelay(retryCount);
    final jitter = (baseDelay.inMilliseconds * 0.2).toInt(); // ±20% jitter
    final randomJitter = (jitter * 2).toInt() - jitter;

    return Duration(
      milliseconds: (baseDelay.inMilliseconds + randomJitter)
          .clamp(0, maxDelayMs)
          .toInt(),
    );
  }
}

/// Wrapper for API calls with rate limiting and backoff
class ProtectedApiCall<T> {
  final RateLimiter _rateLimiter;
  final ExponentialBackoff _backoff;
  final Future<T> Function() _apiCall;

  ProtectedApiCall({
    required String rateLimitKey,
    required RateLimitConfig config,
    required Future<T> Function() apiCall,
    ExponentialBackoff? backoff,
  }) : _rateLimiter = RateLimiter(rateLimitKey, config),
       _backoff = backoff ?? ExponentialBackoff(),
       _apiCall = apiCall;

  /// Executes the API call with rate limiting and exponential backoff
  Future<T> execute() async {
    final result = _rateLimiter.tryAcquire();

    if (!result.allowed) {
      // Wait for rate limit to reset
      if (result.retryAfter != null) {
        await Future.delayed(result.retryAfter!);
        return execute(); // Retry after delay
      }

      throw RateLimitExceededException(
        message: 'Rate limit exceeded. Please try again later.',
        retryAfter: result.retryAfter,
      );
    }

    try {
      return await _apiCall();
    } catch (e) {
      // If we get a rate limit error from the server, implement backoff
      if (_isRateLimitError(e)) {
        final delay = _backoff.getDelayWithJitter(0);
        await Future.delayed(delay);

        for (int i = 1; i < _backoff.maxRetries; i++) {
          try {
            return await _apiCall();
          } catch (e) {
            if (!_isRateLimitError(e)) rethrow;
            final retryDelay = _backoff.getDelayWithJitter(i);
            await Future.delayed(retryDelay);
          }
        }

        throw RateLimitExceededException(
          message: 'Rate limit exceeded. Please try again later.',
        );
      }
      rethrow;
    }
  }

  bool _isRateLimitError(Object e) {
    final message = e.toString().toLowerCase();
    return message.contains('429') ||
        message.contains('rate limit') ||
        message.contains('too many requests');
  }

  /// Gets remaining attempts for display
  int getRemainingAttempts() => _rateLimiter.getRemainingAttempts();

  /// Resets the rate limiter
  void reset() => _rateLimiter.reset();

  /// Cleans up resources
  void dispose() => _rateLimiter.dispose();
}

/// Exception thrown when rate limit is exceeded
class RateLimitExceededException implements Exception {
  final String message;
  final Duration? retryAfter;

  RateLimitExceededException({required this.message, this.retryAfter});

  @override
  String toString() {
    if (retryAfter != null) {
      return '$message Retry after ${retryAfter!.inSeconds} seconds.';
    }
    return message;
  }
}

/// Extension to add power method to double
extension DoublePowExtension on double {
  int pow(int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result = (result * this).toInt();
    }
    return result;
  }
}

/// Rate limit manager for managing multiple rate limiters
class RateLimitManager {
  final Map<String, RateLimiter> _limiters = {};
  final Map<String, RateLimitConfig> _configs = {};

  /// Registers a rate limiter with a specific key
  void register(String key, RateLimitConfig config) {
    _configs[key] = config;
    _limiters[key] = RateLimiter(key, config);
  }

  /// Gets the rate limiter for a specific key
  RateLimiter? get(String key) => _limiters[key];

  /// Checks if an action is allowed
  RateLimitResult tryAcquire(String key) {
    final limiter = _limiters[key];
    if (limiter == null) {
      // Auto-register with default config
      register(key, RateLimitConfig.defaultForm());
      return _limiters[key]!.tryAcquire();
    }
    return limiter.tryAcquire();
  }

  /// Resets the rate limiter for a specific key
  void reset(String key) {
    _limiters[key]?.reset();
  }

  /// Gets remaining attempts for a key
  int getRemainingAttempts(String key) {
    return _limiters[key]?.getRemainingAttempts() ?? 0;
  }

  /// Cleans up all rate limiters
  void dispose() {
    for (final limiter in _limiters.values) {
      limiter.dispose();
    }
    _limiters.clear();
  }
}
