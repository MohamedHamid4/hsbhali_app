import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/shilla_model.dart';

abstract class ShillaLocalDataSource {
  Future<List<ShillaModel>> getAllShillas();
  Future<ShillaModel> getShillaById(String id);
  Future<ShillaModel> createShilla(ShillaModel shilla);
  Future<ShillaModel> updateShilla(ShillaModel shilla);
  Future<void> deleteShilla(String id);
}

class ShillaLocalDataSourceImpl implements ShillaLocalDataSource {
  final Box<ShillaModel> shillasBox;

  const ShillaLocalDataSourceImpl({required this.shillasBox});

  List<ShillaModel> _sortedDescending(Iterable<ShillaModel> items) {
    final list = items.toList()
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return list;
  }

  @override
  Future<List<ShillaModel>> getAllShillas() async {
    try {
      return _sortedDescending(shillasBox.values);
    } catch (e) {
      throw CacheException('فشل قراءة الشلل: $e');
    }
  }

  @override
  Future<ShillaModel> getShillaById(String id) async {
    try {
      final s = shillasBox.get(id);
      if (s == null) throw const CacheException('الشلة غير موجودة');
      return s;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('فشل قراءة الشلة: $e');
    }
  }

  @override
  Future<ShillaModel> createShilla(ShillaModel shilla) async {
    try {
      await shillasBox.put(shilla.id, shilla);
      return shilla;
    } catch (e) {
      throw CacheException('فشل حفظ الشلة: $e');
    }
  }

  @override
  Future<ShillaModel> updateShilla(ShillaModel shilla) async {
    try {
      if (!shillasBox.containsKey(shilla.id)) {
        throw const CacheException('الشلة غير موجودة للتحديث');
      }
      await shillasBox.put(shilla.id, shilla);
      return shilla;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('فشل تحديث الشلة: $e');
    }
  }

  @override
  Future<void> deleteShilla(String id) async {
    try {
      await shillasBox.delete(id);
    } catch (e) {
      throw CacheException('فشل حذف الشلة: $e');
    }
  }
}
