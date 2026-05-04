import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/bill_model.dart';

abstract class BillLocalDataSource {
  Future<List<BillModel>> getAllBills();
  Future<BillModel> getBillById(String id);
  Future<BillModel> createBill(BillModel bill);
  Future<BillModel> updateBill(BillModel bill);
  Future<void> deleteBill(String id);
  Future<void> deleteAllBills();
  Future<List<BillModel>> getRecentBills(int limit);
}

class BillLocalDataSourceImpl implements BillLocalDataSource {
  final Box<BillModel> billsBox;

  const BillLocalDataSourceImpl({required this.billsBox});

  List<BillModel> _sortedDescending(Iterable<BillModel> bills) {
    final list = bills.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<List<BillModel>> getAllBills() async {
    try {
      return _sortedDescending(billsBox.values);
    } catch (e) {
      throw CacheException('فشل قراءة الفواتير: $e');
    }
  }

  @override
  Future<BillModel> getBillById(String id) async {
    try {
      final bill = billsBox.get(id);
      if (bill == null) {
        throw const CacheException('الفاتورة غير موجودة');
      }
      return bill;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('فشل قراءة الفاتورة: $e');
    }
  }

  @override
  Future<BillModel> createBill(BillModel bill) async {
    try {
      await billsBox.put(bill.id, bill);
      return bill;
    } catch (e) {
      throw CacheException('فشل حفظ الفاتورة: $e');
    }
  }

  @override
  Future<BillModel> updateBill(BillModel bill) async {
    try {
      if (!billsBox.containsKey(bill.id)) {
        throw const CacheException('الفاتورة غير موجودة للتحديث');
      }
      await billsBox.put(bill.id, bill);
      return bill;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('فشل تحديث الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteBill(String id) async {
    try {
      await billsBox.delete(id);
    } catch (e) {
      throw CacheException('فشل حذف الفاتورة: $e');
    }
  }

  @override
  Future<void> deleteAllBills() async {
    try {
      await billsBox.clear();
    } catch (e) {
      throw CacheException('فشل حذف كل الفواتير: $e');
    }
  }

  @override
  Future<List<BillModel>> getRecentBills(int limit) async {
    try {
      final sorted = _sortedDescending(billsBox.values);
      return sorted.take(limit).toList();
    } catch (e) {
      throw CacheException('فشل قراءة آخر الفواتير: $e');
    }
  }
}
