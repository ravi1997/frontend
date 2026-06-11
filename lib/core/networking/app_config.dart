/// Environment-driven configuration for the frontend application.
///
/// Values are injected at build time via `--dart-define`:
///
///   flutter run -d chrome \
///     --dart-define=API_BASE_URL=http://localhost:8051 \
///     --dart-define=FRONTEND_ORIGIN=http://localhost:9600
///
/// Defaults point to the standard local development stack so plain
/// `flutter run` still works without extra flags.
class AppConfig {
  // ── Backend origin ──────────────────────────────────────────────────────────
  static const String _apiServerOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Full base URL of the Flask backend (no trailing slash).
  /// Defaults to the standard local backend port for development.  The
  /// explicit `API_BASE_URL` dart-define still wins for deployed builds.
  static String get apiServerUrl =>
      _apiServerOverride.isNotEmpty
          ? _apiServerOverride
          : 'http://localhost:8000';

  /// Versioned API prefix — combined with [apiServerUrl] by [ApiEndpoints].
  /// Note the trailing slash: backend routes are rooted at `/api/v1/`.
  static const String apiPath = '/api/v1/';

  /// Full base URL used as the Dio `baseUrl`.
  static String get apiBaseUrl => '$apiServerUrl$apiPath';

  // ── Frontend origin ─────────────────────────────────────────────────────────
  /// Origin the web app is served from.  Only used for diagnostics / logging;
  /// actual CORS enforcement happens on the backend.
  static const String frontendOrigin = String.fromEnvironment(
    'FRONTEND_ORIGIN',
    defaultValue: 'http://localhost:9600',
  );

  // ── Auth strategy ───────────────────────────────────────────────────────────
  /// When true the Dio client will send cookies with cross-origin requests
  /// (`withCredentials`).  Set to false if the backend only accepts bearer
  /// tokens and does not rely on HttpOnly cookie sessions.
  ///
  /// Current default: false — bearer-token auth is the primary mechanism.
  static const bool useCookieCredentials = bool.fromEnvironment(
    'USE_COOKIE_CREDENTIALS',
    defaultValue: false,
  );
}
