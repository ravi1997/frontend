// lib/modules/analysis_coder/analysis_coder_module.dart
// Analysis Coder module for visual data analysis pipelines.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalysisCoderModule {
  static void navigateTo(BuildContext context, String projectId, {String? analysisId}) {
    final uri = Uri(
      path: '/projects/$projectId/analysis-coder',
      queryParameters: analysisId == null ? null : {'analysisId': analysisId},
    );
    context.go(uri.toString());
  }
}
