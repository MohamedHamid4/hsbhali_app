import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/shilla_local_datasource.dart';
import '../../data/models/shilla_model.dart';
import '../../data/repositories/shilla_repository_impl.dart';
import '../../domain/repositories/shilla_repository.dart';
import '../../domain/usecases/create_shilla.dart';
import '../../domain/usecases/delete_shilla.dart';
import '../../domain/usecases/get_all_shillas.dart';
import '../../domain/usecases/increment_shilla_use.dart';
import '../../domain/usecases/update_shilla.dart';

final shillasBoxProvider = Provider<Box<ShillaModel>>((ref) {
  throw UnimplementedError(
    'يجب تجاوز shillasBoxProvider في main() بعد فتح صندوق Hive.',
  );
});

final shillaLocalDataSourceProvider = Provider<ShillaLocalDataSource>((ref) {
  return ShillaLocalDataSourceImpl(shillasBox: ref.watch(shillasBoxProvider));
});

final shillaRepositoryProvider = Provider<ShillaRepository>((ref) {
  return ShillaRepositoryImpl(
    localDataSource: ref.watch(shillaLocalDataSourceProvider),
  );
});

final getAllShillasUseCaseProvider = Provider<GetAllShillas>((ref) {
  return GetAllShillas(ref.watch(shillaRepositoryProvider));
});

final createShillaUseCaseProvider = Provider<CreateShilla>((ref) {
  return CreateShilla(ref.watch(shillaRepositoryProvider));
});

final updateShillaUseCaseProvider = Provider<UpdateShilla>((ref) {
  return UpdateShilla(ref.watch(shillaRepositoryProvider));
});

final deleteShillaUseCaseProvider = Provider<DeleteShilla>((ref) {
  return DeleteShilla(ref.watch(shillaRepositoryProvider));
});

final incrementShillaUseUseCaseProvider = Provider<IncrementShillaUse>((ref) {
  return IncrementShillaUse(ref.watch(shillaRepositoryProvider));
});
