import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/local/session_repository.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';

import '../../domain/models/session.dart';
import '../../store.dart';

final sessionRepositoryProvider = Provider<RepositoryInterface<Session>>((ref) {
  // MEMO: 今後リモートから取得する場合はここで切り替え
  var dataStore = ref.watch(storeProvider);
  return LocalSessionRepositoryImpl(dataStore!.box<Session>());
});
