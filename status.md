# lib review status

| file | status | findings | fix_applied | consolidation_opportunities | follow_up |
| --- | --- | --- | --- | --- | --- |
| lib/core/controllers/base_controller_mixin.dart | fixed | Exceptions could be swallowed silently; stack traces were dropped. | yes | Consider consolidating try/catch patterns and cleaning unused params/generics later. | Callers still receive `null`/`false` on failures by design. |
| lib/core/design_system/design_system.dart | pending |  | no |  |  |
| lib/core/design_system/tokens.dart | pending |  | no |  |  |
| lib/core/exceptions/app_exception.dart | pending |  | no |  |  |
| lib/core/layout/app_shell.dart | fixed | Sidebar/mobile navigation was wired to `/` for every destination and route matching used the full URI string. | yes | Route resolution helpers could be centralized further if more destinations are added. | No top-level `/projects` landing route exists yet. |
| lib/core/layout/responsive.dart | reviewed | No fix applied; breakpoints and helpers were internally consistent. | no | Helpers are already centralized. | None. |
| lib/core/localization/locale_controller.dart | reviewed | Basic locale state + helpers; no changes in this pass. | no | Consider persisting locale to Hive to avoid resets on restart. | None. |
| lib/core/localization/locale_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/network/USAGE_EXAMPLES.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/network/api_client.dart | fixed | Removed unused `data` body param from `get()` to avoid nonstandard GET requests. | yes | Thin passthrough wrappers could be consolidated later. | `validateStatus` and logging behavior remain unchanged. |
| lib/core/network/api_client.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/network/api_client_wrapper.dart | reviewed | Re-export file only; no changes needed. | no | Consider removing wrapper file if it stays a single export. | None. |
| lib/core/network/api_endpoints.dart | fixed | Fixed endpoint mismatches (`triggerProjectHooks`, `healthCheck`) vs backend mounting paths. | yes | Deduplicate identical constants and standardize trailing-slash conventions. | `healthCheck` is now absolute; avoid passing it through baseUrl builders. |
| lib/core/network/api_service.dart | fixed | List responses were parsed unsafely and could throw on envelope-shaped payloads. | yes | Shared list-envelope extraction should be centralized. | Non-list item typing is still assumed in downstream mapping. |
| lib/core/network/api_service.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/network/app_config.dart | fixed | API base path missed trailing slash vs backend prefix contract. | yes | Centralize URL join behavior and enforce consistent trailing-slash policy. | Watch for string equality assumptions on baseUrl. |
| lib/core/network/auth_interceptor.dart | fixed | CSRF header injection was skipped on auth endpoints, breaking cookie-auth CSRF flows. | yes | Consider proper single-flight refresh + retry policy. | Still clears tokens + navigates on non-auth 401 without refresh attempts. |
| lib/core/network/token_service.dart | fixed | Expired access tokens were deleting refresh tokens too, breaking persisted sessions. | yes | Expired-token cleanup logic could be centralized. | Malformed JWTs still count as expired. |
| lib/core/network/token_service.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/network/unified_network_interceptor.dart | fixed | Structured API error envelopes were not parsed on the Dio error path (4xx/5xx stayed generic). | yes | Envelope parsing could be shared between success and error paths. | Non-canonical server errors still fall back to generic handling. |
| lib/core/network/web_cookie_store.dart | reviewed | No fix applied in this pass. | no | Alias mapping belongs in a shared auth constant/helper. | None. |
| lib/core/network/web_cookie_store_stub.dart | reviewed | No fix applied in this pass. | no | Stub is minimal and correct. | None. |
| lib/core/network/web_cookie_store_web.dart | fixed | CSRF cookie lookup failed when callers passed header aliases instead of cookie names. | yes | Alias mapping should be centralized with auth/network constants. | Backend cookie names still assumed to be the documented defaults. |
| lib/core/router/app_router.dart | fixed | Public submit-route guard missed nested `/projects/:projectId/f/:formId` path. | yes | Route paths and auth checks should be centralized. | Consider shared route constants or named routes. |
| lib/core/router/app_router.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/services/connectivity_service.dart | fixed | Async connectivity updates could write after disposal. | yes | Async mounted-guard helper could be shared. | Startup still optimistically reports online until first check completes. |
| lib/core/services/connectivity_service.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/core/theme/app_colors.dart | reviewed | Static color palette; no change in this pass (tokens overlap with `DesignTokens`). | no | Consider consolidating into `DesignTokens` to avoid drift. | None. |
| lib/core/theme/app_theme.dart | fixed | Button and scheme foreground colors used white on brand surfaces, weakening contrast. | yes | Light/dark button theme blocks are duplicated. | Consider a shared private helper for button themes. |
| lib/core/theme/theme_controller.dart | fixed | Theme hydration could race startup and persist state before Hive writes completed. | yes | Hive restore/persist pattern could be shared. | Some startup flicker remains on first open. |
| lib/core/utils/date_utils.dart | pending |  | no |  |  |
| lib/core/utils/error_handler.dart | fixed | Backend message extraction missed `Map<dynamic,dynamic>` payloads; blank messages could leak to UI. | yes | Locale matching and backend-message sanitization could be centralized. | Backend messages are still returned verbatim (may be too technical). |
| lib/core/utils/id_reader.dart | pending |  | no |  |  |
| lib/core/widgets/app_dialog.dart | fixed | Dialog header/footer could overflow and body had no useful height cap. | yes | Shared dialog shell could reduce duplication. | Dense content may still need tuning on very small screens. |
| lib/core/widgets/app_glass_card.dart | fixed | Glass card used `GestureDetector` instead of Material tap semantics. | yes | Glass card styling/tap behavior could be centralized. | Ripple clipping may vary in nested clip contexts. |
| lib/core/widgets/app_shimmer.dart | fixed | Fallback shimmer placeholder exposed unlabeled semantics. | yes | Placeholder shape helpers could be consolidated later. | Custom-child callers still need their own semantics labels. |
| lib/core/widgets/app_states.dart | pending |  | no |  |  |
| lib/core/widgets/error_state_widget.dart | fixed | Error state could overflow on narrow screens and showed empty error panels for blank strings. | yes | Shared error-state patterns could be extracted later. | No widget test was added. |
| lib/core/widgets/snackbar_service.dart | fixed | Snackbars could stack and relied on implicit text contrast. | yes | Styling could be factored into a shared helper if variants grow. | Message length and visual density still depend on callers. |
| lib/core/widgets/snackbar_service.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/data/repositories/analysis_dashboard_repository.dart | pending |  | no |  |  |
| lib/features/analytics/data/repositories/analytics_repository_impl.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analysis_dashboard.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analysis_dashboard.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analysis_dashboard.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_distribution.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analytics_distribution.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_distribution.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_export.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analytics_export.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_export.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_filter.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analytics_filter.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_filter.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_summary.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analytics_summary.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_summary.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_timeline.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/analytics_timeline.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/analytics_timeline.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/comparative_analytics.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/comparative_analytics.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/comparative_analytics.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/form_analytics.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/form_analytics.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/form_analytics.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/global_filter.dart | pending |  | no |  |  |
| lib/features/analytics/domain/entities/global_filter.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/entities/global_filter.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/domain/repositories/analytics_repository.dart | pending |  | no |  |  |
| lib/features/analytics/domain/repositories/analytics_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/presentation/controllers/analytics_controller.dart | fixed | Error state was unintentionally cleared on partial updates and async loaders could write after disposal. | yes | Loader methods could share a helper later. | Only this file was analyzed. |
| lib/features/analytics/presentation/controllers/analytics_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/presentation/pages/analysis_boards_list_page.dart | pending |  | no |  |  |
| lib/features/analytics/presentation/pages/analytics_page.dart | reviewed | No fix applied in this pass. | no | Could use the shared responsive patterns from other dashboard pages. | None. |
| lib/features/analytics/presentation/pages/report_builder_page.dart | pending |  | no |  |  |
| lib/features/analytics/presentation/providers/analytics_providers.dart | pending |  | no |  |  |
| lib/features/analytics/presentation/providers/analytics_providers.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/analytics/presentation/widgets/analysis_board_canvas.dart | pending |  | no |  |  |
| lib/features/auth/data/datasources/auth_remote_source.dart | fixed | Auth responses were assumed to already be normalized maps, making parsing brittle. | yes | Response normalization should be shared with similar auth data sources. | Non-JSON auth payloads now fail loudly. |
| lib/features/auth/data/datasources/auth_remote_source.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/data/repositories/auth_repository_impl.dart | fixed | Successful login could leave tokens stored even when user rehydration failed. | yes | Login and OTP login post-processing could be shared. | Retrieval failure still raises a generic exception. |
| lib/features/auth/data/repositories/auth_repository_impl.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/domain/entities/user.dart | pending |  | no |  |  |
| lib/features/auth/domain/entities/user.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/domain/entities/user.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/domain/repositories/auth_repository.dart | pending |  | no |  |  |
| lib/features/auth/domain/repositories/auth_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/presentation/controllers/auth_controller.dart | fixed | Auth state was one-shot and auth mutations could remain stuck in loading on failure. | yes | Repeated async guard/state-write handling could be centralized. | `build()` still collapses user fetch failures to unauthenticated. |
| lib/features/auth/presentation/controllers/auth_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/presentation/controllers/otp_controller.dart | pending |  | no |  |  |
| lib/features/auth/presentation/controllers/otp_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/auth/presentation/screens/forgot_password_screen.dart | reviewed | No fix applied in this pass. | no | Shared auth-form structure could be consolidated with other auth screens. | None. |
| lib/features/auth/presentation/screens/login_screen.dart | fixed | Refactored custom fields to utilize shared AuthTextFormField widget, eliminating hundreds of lines of code. | yes | Redundant input field structures eliminated. | No widget/integration coverage was added. |
| lib/features/auth/presentation/screens/otp_verification_screen.dart | fixed | Resend cooldown was restarted from build and the resend affordance was not a proper button. | yes | Resend UI/timer handling could be shared with other auth flows. | No widget/integration coverage was added. |
| lib/features/auth/presentation/screens/register_screen.dart | fixed | Refactored custom fields to utilize shared AuthTextFormField widget, eliminating redundant field code. | yes | Shared UI components fully adopted. | No widget/integration coverage was added. |
| lib/features/auth/presentation/widgets/auth_background.dart | pending |  | no |  |  |
| lib/features/dashboard/data/repositories/dashboard_repository_impl.dart | fixed | Response parsing was brittle and recent-form timestamps were derived from the wrong field. | yes | Shared response-normalization helpers would reduce duplication. | `ProjectSummary` still lacks `created_at`. |
| lib/features/dashboard/data/repositories/dashboard_repository_impl.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/dashboard_data.dart | reviewed | No fix applied in this pass. | no | Structure is already concise. | None. |
| lib/features/dashboard/domain/entities/dashboard_data.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/dashboard_data.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/dashboard_stats.dart | pending |  | no |  |  |
| lib/features/dashboard/domain/entities/dashboard_stats.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/dashboard_stats.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/project_summary.dart | reviewed | No fix applied in this pass. | no | Could model `created_at` directly if needed. | None. |
| lib/features/dashboard/domain/entities/recent_form.dart | reviewed | No fix applied in this pass. | no | Timestamp modeling could be expanded if dashboard needs it. | None. |
| lib/features/dashboard/domain/entities/recent_form.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/entities/recent_form.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/domain/repositories/dashboard_repository.dart | pending |  | no |  |  |
| lib/features/dashboard/presentation/controllers/dashboard_controller.dart | fixed | Duplicate action called a repository method that always threw `UnsupportedError`. | yes | Mutations could be consolidated behind one repository/service. | Refresh after clone may race the backend. |
| lib/features/dashboard/presentation/controllers/dashboard_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/dashboard/presentation/pages/dashboard_page.dart | fixed | Toolbar and stats skeleton could overflow on narrow widths; refreshes lacked mounted checks. | yes | Repeated responsive branching could be shared. | Search rebuilds still happen on each keystroke. |
| lib/features/dashboard/presentation/pages/form_dashboard_page.dart | pending |  | no |  |  |
| lib/features/dashboard/presentation/pages/project_dashboard_page.dart | pending |  | no |  |  |
| lib/features/dashboard/presentation/widgets/dashboard_stats_card.dart | fixed | Stats card text could overflow on smaller cards. | yes | Card shell styling could be shared later. | None. |
| lib/features/dashboard/presentation/widgets/form_card_skeleton.dart | fixed | Fixed-width placeholders could overflow on narrow cards. | yes | Could share a responsive dashboard skeleton helper. | None. |
| lib/features/dashboard/presentation/widgets/recent_forms_list.dart | fixed | Recent form item layout was brittle on narrow widths. | yes | Action button styling could be shared later. | No backend/navigation fixes were applied beyond awaiting duplicate. |
| lib/features/dashboard/presentation/widgets/stats_card_skeleton.dart | fixed | Fixed-width placeholders could overflow on narrow cards. | yes | Could share a responsive dashboard skeleton helper. | None. |
| lib/features/form_builder/data/dto/form_dto.dart | pending |  | no |  |  |
| lib/features/form_builder/data/dto/form_dto.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/data/dto/form_dto.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/data/mappers/form_mapper.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/ai_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/ai_repository_impl.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/data/repositories/condition_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/field_library_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/form_builder_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/signature_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/template_library_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/translation_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/data/repositories/workflow_repository_impl.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/access_policy.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/access_policy.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/access_policy.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/condition_enums.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/condition_rule.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/custom_field_template.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/custom_field_template.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/custom_field_template.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_builder_state.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_builder_state.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_layout_type.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_question_option.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_question_option.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_question_option.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_style.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_style.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_style.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_template.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_template.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_template.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_version_history.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/form_version_history.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/form_version_history.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/entities/question_type.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/section_layout_type.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/signature_request.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/translation_job.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/translation_language.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/workflow.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/workflow_enums.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/workflow_step.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/entities/workflow_transition.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/ai_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/condition_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/condition_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/repositories/field_library_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/form_builder_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/form_builder_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/repositories/signature_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/signature_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/domain/repositories/template_library_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/translation_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/repositories/workflow_repository.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/services/field_registry.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/services/form_logic_evaluator.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/services/workflow_executor.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/services/workflow_executor_provider.dart | pending |  | no |  |  |
| lib/features/form_builder/domain/services/workflow_executor_provider.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/condition_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/condition_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/custom_fields_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/custom_fields_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/form_builder_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/form_builder_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/git_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/signature_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/signature_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/template_library_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/template_library_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/translation_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/translation_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/version_history_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/version_history_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/controllers/workflow_controller.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/controllers/workflow_controller.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/pages/condition_builder_page.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/pages/form_builder_page.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/pages/form_preview_page.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/pages/form_submit_page.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/providers/template_library_providers.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/providers/template_library_providers.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/form_builder/presentation/utils/form_logic_engine.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/utils/layout_engine.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/utils/preview_utils.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/ai_assistant_dialog.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/builder_field_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/bulk_question_properties_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/camera_capture_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/field_library_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/field_properties_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/form_builder_top_bar.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/form_canvas_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/form_drag_data.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/form_properties_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/form_render_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/git_merge_dialog.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/logic_rule_dialog.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/dynamic_properties_panel.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/field_general_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/field_layout_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/field_logic_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/field_specific_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/field_style_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/form_access_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/form_layout_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/form_logic_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/form_style_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/general_settings_panels.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/property_builder_utils.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/section_layout_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/section_logic_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/properties/section_style_settings.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/publish_success_dialog.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/section_layout_widgets.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/section_properties_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/section_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/signature_pad_widget.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/template_card.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/template_preview_dialog.dart | pending |  | no |  |  |
| lib/features/form_builder/presentation/widgets/workflow_configuration_dialog.dart | pending |  | no |  |  |
| lib/features/platform/data/platform_repository.dart | fixed | Unsafe force-casts on Dio response data (as Map, as List) and outdated legacy Riverpod Provider format. | yes | Upgraded provider using standard `@riverpod` annotations. | None. |
| lib/features/platform/data/platform_repository.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/responses/data/mappers/response_mapper.dart | fixed | Severe collection pruning crash on list values where calling isNotEmpty on primitives (int, double, bool) threw NoSuchMethodError. | yes | Added type-guards (is Map, is List, is String) to safely filter empty sub-collections while preserving array indexing. | None. |
| lib/features/responses/data/repositories/response_repository_impl.dart | fixed | Direct unsafe response envelope type casting (as Map<String, dynamic>) causing crashes on wrapped or generic api structures. | yes | Implemented _map helper to safely extract data from wrapped envelopes, and standardized list endpoints on safe _items helper. | None. |
| lib/features/responses/data/repositories/response_repository_impl.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/responses/data/services/sync_service.dart | fixed | Scoped projectId was lost when going offline causing syncing mismatches, and logout cleared device local offline queue. | yes | Wrapped persisted objects in a map containing the projectId scope, and closed the database box on logout to preserve queues. | None. |
| lib/features/responses/data/services/sync_service.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/responses/domain/entities/form_response.dart | fixed | Schema alignment missing projectId, formVersion, version, and reviewStatus fields leading to data loss on parsing/serialization. | yes | Integrated the new schema fields and aligned manual fromJson/toJson mappings while preserving compatibility. | None. |
| lib/features/responses/domain/entities/response_history.dart | fixed | camelCase properties lacked casing translation annotations causing parsing crashes when backend returned snake_case attributes. | yes | Modernized abstract freezed class, integrated @JsonSerializable snake_case rename, added missing version field, and ran codegen. | None. |
| lib/features/responses/domain/entities/response_history.freezed.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/responses/domain/entities/response_history.g.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/features/responses/domain/repositories/response_repository.dart | fixed | Interface specification lacked proper documentation regarding tenant scopes, project boundaries, or AI search criteria. | yes | Added full dartdoc specifications for all contract methods. | None. |
| lib/features/responses/domain/utils/csv_exporter.dart | fixed | Traversal omitted nested sections, looked up values using only id instead of variableName, and maps/lists formatted badly in cells. | yes | Refactored with recursive sub-section traversal, added variableName key lookup fallback, and clean cell serialization rules. | None. |
| lib/features/responses/presentation/controllers/ai_controller.dart | fixed | Unsafe post-await state updates on auto-disposable controller throwing state error. | yes | Added ref.mounted checks before updating async states. | None. |
| lib/features/responses/presentation/controllers/ai_controller.g.dart | skipped | Auto-generated build_runner file, excluded from manual remediation to prevent overwriting. | no | Auto-generated. | None. |
| lib/features/responses/presentation/controllers/form_submission_controller.dart | fixed | Offline queueing fallback set state to AsyncValue.error even when offline fallback succeeded, causing confusing error prompts. | yes | Updated catch block to set AsyncValue.data(null) on successful offline queuing. | None. |
| lib/features/responses/presentation/controllers/form_submission_controller.g.dart | skipped | Auto-generated build_runner file, excluded from manual remediation to prevent overwriting. | no | Auto-generated. | None. |
| lib/features/responses/presentation/controllers/responses_controller.dart | fixed | Standard annotations and auto-dispose checked for leaks and correctness. | yes | Leveraged standard `@riverpod` annotations and verified all. | None. |
| lib/features/responses/presentation/controllers/responses_controller.g.dart | skipped | Auto-generated build_runner file, excluded from manual remediation to prevent overwriting. | no | Auto-generated. | None. |
| lib/features/responses/presentation/pages/response_detail_page.dart | fixed | Unhandled async exceptions, missing context.mounted guards before showing SnackBars, and hardcoded desktop-only paddings causing mobile screen overflows. | yes | Implemented mounted guards, try-catch, AI loading spinner state feedback, and responsive layout styling based on screen width. | None. |
| lib/features/responses/presentation/pages/response_list_page.dart | fixed | Stale global filter/query providers leaking across forms, non-lazy lists loading all items immediately, and hardcoded desktop paddings. | yes | Added auto-dispose to providers, refactored scroll views to ListView.builder for recycling, and added mobile layout breakpoints. | None. |
| lib/features/responses/presentation/widgets/export_options_dialog.dart | fixed | Hardcoded desktop widths causing screen overflows on mobile viewports, and unbounded height widget exceptions in columns. | yes | Added responsive width calculations and max-height constraints to allow inner scroll views to work perfectly. | None. |
| lib/features/responses/presentation/widgets/filter_builder_dialog.dart | fixed | Bottom action buttons causing horizontal layout overflows, dynamic keys lost on dropdown rebuilds, and rule text unsynced. | yes | Implemented responsive wrapping columns, converted initialValue to correct property binding, and synced controllers. | None. |
| lib/generated/api/README.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/analysis_options.yaml | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/build.yaml | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AccessEntrySchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AdminTasksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AdvancedResponsesApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AiApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AnalysisBoardApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AnalyticsApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AnalyticsStateSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AnomalyApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ApprovalLogSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ApprovalStepSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ApprovalWorkflowSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/AuthApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/BaseEmbeddedSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/BaseSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ConditionalValidationSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/DashboardApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/DashboardSettingsApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/DynamicViewDefinitionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/EnvConfigApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ExternalApiApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1AuthLoginPost200Response.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1AuthLoginPost200ResponseData.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1AuthRefreshPost200Response.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1AuthRequestOtpPostRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1FormsExternalHooksHookIdApprovePostRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1FormsExternalHooksRegisterPostRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1ProjectsProjectIdFormsExternalHooksHookIdApprovePostRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1ProjectsProjectIdFormsExternalHooksRegisterPostRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormApiV1UserSecurityLockStatusUserIdGet200Response.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormBlueprintSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormHooksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormResponseSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/FormVersionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/LibraryApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/LogicComponentSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/LoginRequest.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/NlpSearchApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/OptionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/PaginatedResult.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/PermissionsApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ProjectApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ProjectBlueprintSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ProjectHooksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ProjectSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ProjectVersionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/QuestionLogicSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/QuestionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/QuestionUISchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ResourceAccessControlSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ResponseTemplateSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SectionApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SectionHooksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SectionLogicSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SectionSchemaStruct.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SectionUISchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SmsApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SoftDeleteBaseSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SystemApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SystemSettingsApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/SystemSettingsSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/TasksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ThemesApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/TokenPayload.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/TokenResponse.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/TranslationApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/TriggerSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UIComponentSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserCreateSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserGroupSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserOut.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/UserUpdateSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ValidationSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/VersionSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/ViewApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/WebhooksApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/WorkflowApi.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/doc/WorkflowInstanceSchema.md | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/ridp_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/admin_tasks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/advanced_responses_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/ai_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/analysis_board_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/analytics_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/anomaly_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/auth_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/dashboard_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/dashboard_settings_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/env_config_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/external_api_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/form_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/form_hooks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/library_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/nlp_search_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/permissions_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/project_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/project_hooks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/section_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/section_hooks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/sms_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/system_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/system_settings_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/tasks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/themes_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/translation_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/user_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/view_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/webhooks_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/api/workflow_api.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/auth/api_key_auth.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/auth/auth.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/auth/basic_auth.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/auth/bearer_auth.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/auth/oauth.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/deserialize.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/access_entry_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/analytics_state_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/approval_log_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/approval_step_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/approval_workflow_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/base_embedded_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/base_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/conditional_validation_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/dynamic_view_definition_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_auth_login_post200_response.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_auth_login_post200_response_data.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_auth_refresh_post200_response.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_auth_request_otp_post_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_forms_external_hooks_hook_id_approve_post_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_forms_external_hooks_register_post_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_projects_project_id_forms_external_hooks_hook_id_approve_post_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_projects_project_id_forms_external_hooks_register_post_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_api_v1_user_security_lock_status_user_id_get200_response.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_blueprint_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_response_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/form_version_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/logic_component_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/login_request.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/option_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/paginated_result.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/project_blueprint_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/project_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/project_version_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/question_logic_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/question_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/question_ui_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/resource_access_control_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/response_template_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/section_logic_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/section_schema_struct.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/section_ui_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/soft_delete_base_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/system_settings_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/token_payload.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/token_response.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/trigger_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/ui_component_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/user_create_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/user_group_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/user_out.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/user_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/user_update_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/validation_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/version_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/lib/src/model/workflow_instance_schema.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/pubspec.yaml | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/access_entry_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/admin_tasks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/advanced_responses_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/ai_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/analysis_board_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/analytics_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/analytics_state_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/anomaly_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/approval_log_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/approval_step_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/approval_workflow_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/auth_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/base_embedded_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/base_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/conditional_validation_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/dashboard_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/dashboard_settings_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/dynamic_view_definition_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/env_config_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/external_api_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_auth_login_post200_response_data_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_auth_login_post200_response_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_auth_refresh_post200_response_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_auth_request_otp_post_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_forms_external_hooks_hook_id_approve_post_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_forms_external_hooks_register_post_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_projects_project_id_forms_external_hooks_hook_id_approve_post_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_projects_project_id_forms_external_hooks_register_post_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_api_v1_user_security_lock_status_user_id_get200_response_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_blueprint_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_hooks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_response_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/form_version_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/library_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/logic_component_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/login_request_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/nlp_search_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/option_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/paginated_result_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/permissions_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/project_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/project_blueprint_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/project_hooks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/project_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/project_version_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/question_logic_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/question_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/question_ui_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/resource_access_control_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/response_template_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/section_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/section_hooks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/section_logic_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/section_schema_struct_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/section_ui_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/sms_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/soft_delete_base_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/system_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/system_settings_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/system_settings_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/tasks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/themes_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/token_payload_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/token_response_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/translation_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/trigger_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/ui_component_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_create_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_group_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_out_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/user_update_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/validation_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/version_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/view_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/webhooks_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/workflow_api_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/generated/api/test/workflow_instance_schema_test.dart | skipped | Auto-generated or documentation artifact; excluded from manual remediation. | no | Auto-generated. | None. |
| lib/main.dart | fixed | Made async entrypoint explicit with `Future<void> main()`. | yes | Startup bootstrap/error handling could be centralized later. | None. |
| lib/models/form_models.dart | fixed | Serialization/deserialization bugs, typecast exceptions (as int?/as num?), unsafe date parsing, and unsafe dynamic style parsing in question, section, and form models. | yes | Dynamic option shims/extensions allowed older UI widgets to remain compatible without broad refactoring. | None. |
| lib/models/form_models.freezed.dart | skipped | Auto-generated build_runner file, excluded from manual remediation to prevent overwriting during generation. | no | Auto-generated. | None. |
| lib/models/form_models.g.dart | skipped | Auto-generated build_runner file, excluded from manual remediation to prevent overwriting during generation. | no | Auto-generated. | None. |
| lib/utils/form_utils.dart | fixed | Version-scoped add helpers defaulted to literal `1.0.0` instead of the current active version. | yes | Resolve-target-version logic could be centralized. | Other mutators still operate across all versions. |
