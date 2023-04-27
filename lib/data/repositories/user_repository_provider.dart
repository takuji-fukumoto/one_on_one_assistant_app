import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/local/user_repository.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';

import '../../domain/models/user.dart';
import 'local_store_provider.dart';

final userRepositoryProvider = Provider<RepositoryInterface<User>>((ref) {
  // MEMO: 今後リモートから取得する場合はここで切り替え
  var dataStore = ref.watch(storeProvider);
  return LocalUserRepositoryImpl(dataStore!.box<User>());
});
