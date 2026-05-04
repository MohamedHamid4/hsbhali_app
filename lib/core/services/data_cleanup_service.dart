import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/bills/data/models/bill_model.dart';
import '../../features/bills/presentation/providers/bills_providers.dart';
import '../../features/people/data/models/shilla_model.dart';
import '../../features/people/presentation/providers/people_providers.dart';

class DataCleanupService {
  final Box<BillModel> billsBox;
  final Box<ShillaModel> shillasBox;

  const DataCleanupService({
    required this.billsBox,
    required this.shillasBox,
  });

  Future<void> clearAllData() async {
    debugPrint('🗑️ DataCleanup: starting clearAllData');

    await _clearHiveBoxes();
    await _deleteReceiptImages();
    await _clearSharedPreferences();

    debugPrint('🗑️ DataCleanup: completed');
  }

  Future<void> _clearHiveBoxes() async {
    try {
      final billsCount = billsBox.length;
      await billsBox.clear();
      debugPrint('🗑️ DataCleanup: cleared $billsCount bills');

      final shillasCount = shillasBox.length;
      await shillasBox.clear();
      debugPrint('🗑️ DataCleanup: cleared $shillasCount shillas');
    } catch (e) {
      debugPrint('🗑️ DataCleanup: failed to clear Hive boxes: $e');
    }
  }

  Future<void> _deleteReceiptImages() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final billsDir = Directory('${docsDir.path}/bills');
      if (await billsDir.exists()) {
        await billsDir.delete(recursive: true);
        debugPrint('🗑️ DataCleanup: deleted bills directory');
      }

      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list()) {
          final name = entity.path.split(Platform.pathSeparator).last;
          if (name.startsWith('share_') && name.endsWith('.png')) {
            try {
              await entity.delete();
            } catch (_) {}
          }
        }
        debugPrint('🗑️ DataCleanup: cleared temporary share images');
      }
    } catch (e) {
      debugPrint('🗑️ DataCleanup: failed to delete images: $e');
    }
  }

  Future<void> _clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      debugPrint('🗑️ DataCleanup: cleared SharedPreferences');
    } catch (e) {
      debugPrint('🗑️ DataCleanup: failed to clear SharedPreferences: $e');
    }
  }
}

final dataCleanupServiceProvider = Provider<DataCleanupService>((ref) {
  return DataCleanupService(
    billsBox: ref.watch(billsBoxProvider),
    shillasBox: ref.watch(shillasBoxProvider),
  );
});
