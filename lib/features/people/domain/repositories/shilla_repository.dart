import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/shilla.dart';

abstract class ShillaRepository {
  Future<Either<Failure, List<Shilla>>> getAllShillas();
  Future<Either<Failure, Shilla>> getShillaById(String id);
  Future<Either<Failure, Shilla>> createShilla(Shilla shilla);
  Future<Either<Failure, Shilla>> updateShilla(Shilla shilla);
  Future<Either<Failure, void>> deleteShilla(String id);
  Future<Either<Failure, Shilla>> incrementUseCount(String id);
}
