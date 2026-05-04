import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/shilla.dart';
import '../../domain/repositories/shilla_repository.dart';
import '../datasources/shilla_local_datasource.dart';
import '../models/shilla_model.dart';

class ShillaRepositoryImpl implements ShillaRepository {
  final ShillaLocalDataSource localDataSource;

  const ShillaRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Shilla>>> getAllShillas() async {
    try {
      final models = await localDataSource.getAllShillas();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Shilla>> getShillaById(String id) async {
    try {
      final model = await localDataSource.getShillaById(id);
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Shilla>> createShilla(Shilla shilla) async {
    try {
      final saved =
          await localDataSource.createShilla(ShillaModel.fromEntity(shilla));
      return Right(saved.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Shilla>> updateShilla(Shilla shilla) async {
    try {
      final updated =
          await localDataSource.updateShilla(ShillaModel.fromEntity(shilla));
      return Right(updated.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteShilla(String id) async {
    try {
      await localDataSource.deleteShilla(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Shilla>> incrementUseCount(String id) async {
    try {
      final current = await localDataSource.getShillaById(id);
      final updated = ShillaModel.fromEntity(
        current.toEntity().copyWith(
              useCount: current.useCount + 1,
              lastUsedAt: DateTime.now(),
            ),
      );
      final saved = await localDataSource.updateShilla(updated);
      return Right(saved.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
