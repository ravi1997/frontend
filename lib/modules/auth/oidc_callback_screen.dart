import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/services/snackbar_service.dart';
import 'auth_controller.dart';

class OidcCallbackScreen extends ConsumerStatefulWidget {
  final String code;
  final String state;

  const OidcCallbackScreen({
    super.key,
    required this.code,
    required this.state,
  });

  @override
  ConsumerState<OidcCallbackScreen> createState() => _OidcCallbackScreenState();
}

class _OidcCallbackScreenState extends ConsumerState<OidcCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyCallback();
    });
  }

  Future<void> _verifyCallback() async {
    try {
      await ref
          .read(authControllerProvider.notifier)
          .handleOidcCallback(widget.code, widget.state);
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ref.read(snackbarServiceProvider).showError('SSO Authentication failed: $e');
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ref.read(snackbarServiceProvider).showError(next.error.toString());
        context.go('/login');
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Completing SSO authentication...',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we verify your credentials.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
