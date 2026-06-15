## PURPOSE
Form Builder Platform Flutter frontend — cross-platform client (Web, Android, iOS, Desktop).
Renders drag-and-drop form builder, analysis coder, dashboard builder, and form viewer.
All dynamic UI is JSON-driven — NO runtime Dart generation ever.

## STACK
- Flutter 3.x (stable) · Dart 3.x
- Riverpod 2.x (state management — all state goes through providers)
- Drift (SQLite offline cache — local schema migrations required when changing tables)
- dio / http (HTTP client)
- flutter_secure_storage (JWT storage)
- socket_io_client (WebSocket presence)
- tus_client (resumable chunked file uploads)
- connectivity_plus (online/offline detection)

## ARCHITECTURE
Directory layout (canonical absolute paths):
  /home/ravi/workspace/frontend/lib/
    modules/
      auth/               ← Login, session management
      forms/
        pages/            ← Top-level route pages
        widgets/          ← Feature-specific widgets
        services/         ← Riverpod notifiers + business logic
        data/repositories/ ← API calls + local cache coordination
      analytics/          ← Analysis coder pages + widgets
      dashboard/          ← Dashboard viewer
      dashboard_builder/  ← Dashboard canvas builder
      platform/           ← Platform/org admin screens
    shared/
      models/             ← Cross-module data models
      widgets/            ← Reusable UI components
      validators/         ← Form field validators
    core/
      networking/         ← API client, endpoints, interceptors
      offline/            ← Drift SQLite tables + DAOs
      services/           ← Core app services
      config/             ← App configuration
      theme/              ← Design system tokens
      security/           ← Auth token management

Offline architecture (dual-mode):
  Online:  REST API via repository → Riverpod provider → widget
  Offline: Drift SQLite cache → SyncManager → tus chunked upload on reconnect

## PATTERNS

### CRITICAL: JSON UI Engine (Never Generate Dynamic Dart)
Flutter compiles to native — runtime Dart execution is IMPOSSIBLE.
All dynamic form components built from static component_schemas JSON.
JSON UI Engine in lib/shared/json_ui_engine/ maps property JSON → compiled Dart widgets.
Adding a new field type = schema upgrade + new widget registration, NOT dynamic code.

### Riverpod 2.x State Rules
- ALL state management through Riverpod providers (never setState in complex layouts)
- Data fetching: FutureProvider or AsyncNotifierProvider
- Local/sync operations: Drift service classes exposed via Riverpod Provider
- Use ConsumerWidget / ConsumerStatefulWidget (never deeply nested StatefulWidget)
- Never call backend API directly from a widget — always go through repository layer

### Repository Pattern
- Repository coordinates: API calls + Drift cache + optimistic updates
- Service (Riverpod Notifier) calls repository, never API directly
- Widget observes provider, never calls repository directly

### Drift (SQLite) Rules
- ALWAYS write a migration when changing a Drift table schema
- Never read Drift tables from widgets directly — use service providers
- Offline drafts, file queues, and schema cache live in Drift

### Key Modules + Critical Files
- lib/modules/forms/services/form_builder_controller.dart — main form builder state
- lib/modules/forms/data/repositories/form_builder_repository_impl.dart — form API + cache
- lib/modules/forms/pages/form_submit_page.dart — form submission flow
- lib/modules/forms/pages/form_preview_page.dart — form preview rendering
- lib/modules/analytics/pages/analytics_page.dart — analysis viewer
- lib/modules/dashboard_builder/pages/dashboard_builder_page.dart — canvas builder
- lib/core/networking/api_endpoints.dart — all API endpoint definitions (114 symbols)
- lib/shared/models/form_models.dart — canonical form data models

## TRADEOFFS
- JSON UI Engine → unlimited dynamic fields without recompile, but new types need schema + widget registration
- Riverpod 2.x → predictable reactive state, but requires provider graph discipline (no setState mixing)
- Drift offline cache → full offline capability, but schema migrations must be written for every table change
- Dual-mode sync → resilient submissions, but SyncManager adds complexity to the submission flow
- ConsumerWidget everywhere → fine-grained rebuilds, but requires careful ref.watch scoping

## PHILOSOPHY
- JSON-first: form structure, component properties, dashboard layouts — all JSON, all the time
- Provider-first: if state needs to be shared across two widgets, it goes into a Riverpod provider
- Offline-first: assume connectivity loss; design flows so Drift cache + SyncManager can recover
- Repository boundary: widgets know nothing about the network or Drift — only providers
- Post-edit: ALWAYS run `dart analyze lib/` and fix all errors/warnings before closing a task