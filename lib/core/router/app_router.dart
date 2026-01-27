import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';

part 'app_router.g.dart';

@riverpod
Raw<GoRouter> appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // If still loading, don't redirect
      if (authState.isLoading) {
        return null;
      }

      final isAuth = authState.hasValue && authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isForgotPassword = state.matchedLocation == '/forgot-password';
      final isAuthPath = isLoggingIn || isRegistering || isForgotPassword;

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuth && !isAuthPath) {
        return '/login';
      }

      // If authenticated and on auth page, redirect to dashboard
      if (isAuth && isAuthPath) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const DashboardPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );

  // Listen to auth changes and refresh router
  ref.listen<AsyncValue>(authControllerProvider, (_, __) {
    router.refresh();
  });

  ref.onDispose(router.dispose);

  return router;
}
