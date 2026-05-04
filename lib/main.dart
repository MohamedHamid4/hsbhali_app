import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/providers/preferences_provider.dart';
import 'core/services/ads_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/preferences_service.dart';
import 'features/bills/data/models/bill_item_model.dart';
import 'features/bills/data/models/bill_model.dart';
import 'features/bills/data/models/person_model.dart';
import 'features/bills/presentation/providers/bills_providers.dart';
import 'features/people/data/models/shilla_model.dart';
import 'features/people/presentation/providers/people_providers.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    debugPrint('═══ App starting ═══');

    bool firebaseAvailable = false;
    try {
      await Hive.initFlutter();
      _registerHiveAdapters();
      debugPrint(
        'Hive: ready (bill=${Hive.isAdapterRegistered(0)}, item=${Hive.isAdapterRegistered(1)}, person=${Hive.isAdapterRegistered(2)}, shilla=${Hive.isAdapterRegistered(3)})',
      );

      final billsBox = await _openBoxSafely<BillModel>('bills');
      debugPrint('Box opened: bills (${billsBox.length} items)');

      final shillasBox = await _openBoxSafely<ShillaModel>('shillas');
      debugPrint('Box opened: shillas (${shillasBox.length} items)');

      await initializeDateFormatting('ar_EG', null);

      final prefsService = await PreferencesService.init();
      debugPrint('Preferences: ready');

      firebaseAvailable = await _initializeFirebaseSafely();
      debugPrint('Firebase: ${firebaseAvailable ? "initialized" : "skipped"}');

      final analyticsService = AnalyticsService();
      final adsService = AdsService(prefsService, analytics: analyticsService);

      runApp(
        ProviderScope(
          overrides: [
            preferencesServiceProvider.overrideWithValue(prefsService),
            billsBoxProvider.overrideWithValue(billsBox),
            shillasBoxProvider.overrideWithValue(shillasBox),
            adsServiceProvider.overrideWithValue(adsService),
            analyticsServiceProvider.overrideWithValue(analyticsService),
          ],
          child: const HsbhaliApp(),
        ),
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();
        debugPrint('═══ App started successfully ═══');
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await AdsService.initialize();
        } catch (e, st) {
          debugPrint('AdMob init failed: $e');
          if (firebaseAvailable && !kDebugMode) {
            try {
              await FirebaseCrashlytics.instance.recordError(
                e,
                st,
                reason: 'AdMob init',
                fatal: false,
              );
            } catch (_) {}
          }
        }
      });
    } catch (error, stack) {
      debugPrint('FATAL ERROR during initialization: $error');
      debugPrint('Stack: $stack');

      FlutterNativeSplash.remove();

      if (firebaseAvailable && !kDebugMode) {
        try {
          await FirebaseCrashlytics.instance
              .recordError(error, stack, fatal: true);
        } catch (_) {}
      }

      runApp(_ErrorApp(error: error.toString()));
    }
  }, (error, stack) {
    debugPrint('Zone error: $error');
    debugPrint(stack.toString());
    if (!kDebugMode) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (_) {}
    }
  });
}

void _registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(BillModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(BillItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PersonModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(ShillaModelAdapter());
  }
}

Future<Box<T>> _openBoxSafely<T>(String name) async {
  try {
    return await Hive.openBox<T>(name);
  } catch (e) {
    debugPrint('Failed to open box $name: $e');
    debugPrint('Attempting to delete corrupted box and recreate...');
    try {
      await Hive.deleteBoxFromDisk(name);
      return await Hive.openBox<T>(name);
    } catch (e2) {
      debugPrint('Failed to recreate box $name: $e2');
      rethrow;
    }
  }
}

Future<bool> _initializeFirebaseSafely() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = (errorDetails) {
      if (kDebugMode) {
        FlutterError.presentError(errorDetails);
      } else {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (!kDebugMode) {
        try {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        } catch (_) {}
      }
      return true;
    };
    return true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    return false;
  }
}

class _ErrorApp extends StatelessWidget {
  final String error;
  const _ErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0F6E56),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.white, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'في مشكلة في فتح التطبيق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'حاول تعيد فتح التطبيق. لو المشكلة استمرت، احذف التطبيق وثبته من جديد.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (kDebugMode)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
