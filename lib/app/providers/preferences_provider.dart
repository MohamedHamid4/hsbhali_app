import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError(
    'يجب تجاوز preferencesServiceProvider في main() بعد تهيئة PreferencesService.',
  );
});
