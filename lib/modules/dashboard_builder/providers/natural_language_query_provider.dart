import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/natural_language_query_models.dart';

final naturalLanguageQueryProvider =
    Provider.family<NaturalLanguageQueryState, String>((ref, dashboardId) {
  return NaturalLanguageQueryState(queries: const [], isProcessing: false);
});
