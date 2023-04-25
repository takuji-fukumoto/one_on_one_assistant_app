import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/local/user_repository.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../store.dart';
import '../models/user.dart';

final userRepositoryProvider = Provider<RepositoryInterface<User>>((ref) {
  var dataStore = ref.watch(storeProvider);
  return LocalUserRepositoryImpl(dataStore!.box<User>());
});
