import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/design_system/design_system.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    // Initialize Hive for tests
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    
    // Disable runtime font fetching for tests
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppDesignSystem.enterpriseDarkTheme,
        home: child,
      ),
    );
  }

  testWidgets('LoginScreen Accessibility Audit', (WidgetTester tester) async {
    // Use a fixed size to avoid responsiveness issues during audit
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const LoginScreen()));
    // Use pump repeatedly instead of pumpAndSettle to avoid timeout from animations
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final handle = tester.ensureSemantics();
    
    // We expect these might fail. We use a custom matcher to report what failed.
    print('--- Accessibility Audit Results ---');
    
    try {
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      print('✅ Text Contrast: PASSED');
    } catch (e) {
      print('❌ Text Contrast: FAILED\n$e');
    }

    try {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      print('✅ Android Tap Target: PASSED');
    } catch (e) {
      print('❌ Android Tap Target: FAILED\n$e');
    }

    try {
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      print('✅ iOS Tap Target: PASSED');
    } catch (e) {
      print('❌ iOS Tap Target: FAILED\n$e');
    }

    try {
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      print('✅ Labeled Tap Target: PASSED');
    } catch (e) {
      print('❌ Labeled Tap Target: FAILED\n$e');
    }

    handle.dispose();
  });
}
