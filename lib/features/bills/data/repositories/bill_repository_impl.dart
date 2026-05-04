import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_stats.dart';
import '../../domain/repositories/bill_repository.dart';
import '../datasources/bill_local_datasource.dart';
import '../models/bill_model.dart';

class BillRepositoryImpl implements BillRepository {
  final BillLocalDataSource localDataSource;

  const BillRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Bill>>> getAllBills() async {
    try {
      final models = await localDataSource.getAllBills();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Bill>> getBillById(String id) async {
    try {
      final model = await localDataSource.getBillById(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Bill>> createBill(Bill bill) async {
    try {
      final model = await localDataSource.createBill(BillModel.fromEntity(bill));
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Bill>> updateBill(Bill bill) async {
    try {
      final model = await localDataSource.updateBill(BillModel.fromEntity(bill));
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBill(String id) async {
    try {
      final bill = await localDataSource.getBillById(id);
      await _deleteImageIfExists(bill.receiptImagePath);
      await localDataSource.deleteBill(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  Future<void> _deleteImageIfExists(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllBills() async {
    try {
      await localDataSource.deleteAllBills();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Bill>>> getRecentBills({int limit = 5}) async {
    try {
      final models = await localDataSource.getRecentBills(limit);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BillStats>> getStats() async {
    try {
      final models = await localDataSource.getAllBills();
      if (models.isEmpty) return const Right(BillStats.empty);

      final totalCount = models.length;

      final now = DateTime.now();
      final monthBills = models.where((b) {
        return b.createdAt.year == now.year && b.createdAt.month == now.month;
      });
      final monthTotal = monthBills.fold<double>(0, (s, b) => s + b.total);

      final placeCounts = <String, int>{};
      for (final b in models) {
        final p = b.placeName;
        if (p == null || p.trim().isEmpty) continue;
        placeCounts[p] = (placeCounts[p] ?? 0) + 1;
      }
      String? topPlace;
      if (placeCounts.isNotEmpty) {
        topPlace = placeCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;
      }

      final totalAll = models.fold<double>(0, (s, b) => s + b.total);
      final average = totalAll / totalCount;

      return Right(BillStats(
        totalBillsCount: totalCount,
        monthTotal: monthTotal,
        topPlace: topPlace,
        averageBillAmount: average,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
