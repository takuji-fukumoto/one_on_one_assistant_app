import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/local/session_repository.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../store.dart';
import '../models/session.dart';

final sessionRepositoryProvider = Provider<RepositoryInterface<Session>>((ref) {
  var dataStore = ref.watch(storeProvider);
  return LocalSessionRepositoryImpl(dataStore!.box<Session>());
});
