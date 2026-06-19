"""
lib/modules/analysis_coder/analysis_coder_module.dart
Analysis Coder module for visual data analysis pipelines.
"""

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/analysis_models.dart';
import 'screens/analysis_coder_screen.dart';
import 'services/analysis_service.dart';
import 'theme/analysis_theme.dart';

class AnalysisCoderModule {
  static const String routeName = '/analysis-coder';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      routeName: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        final projectId = args?['projectId'] ?? '';
        final analysisId = args?['analysisId'];
        return AnalysisCoderScreen(
          projectId: projectId,
          analysisId: analysisId,
        );
      },
    };
  }

  static void navigateTo(BuildContext context, String projectId, {String? analysisId}) {
    if (analysisId != null) {
      Navigator.of(context).pushNamed(
        routeName,
        arguments: {
          'projectId': projectId,
          'analysisId': analysisId,
        },
      );
    } else {
      Navigator.of(context).pushNamed(
        routeName,
        arguments: {
          'projectId': projectId,
        },
      );
    }
  }
}