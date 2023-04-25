import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/local/talk_repository.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../store.dart';
import '../models/talk.dart';

final talkRepositoryProvider = Provider<RepositoryInterface<Talk>>((ref) {
  var dataStore = ref.watch(storeProvider);
  return LocalTalkRepositoryImpl(dataStore!.box<Talk>());
});
