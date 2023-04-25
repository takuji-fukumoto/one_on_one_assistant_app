import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/talk.dart';
import '../repositories/talk_repository_provider.dart';

final fetchAllTalkUseCaseProvider =
    FutureProvider.autoDispose<List<Talk>>((ref) async {
  var repository = ref.watch(talkRepositoryProvider);

  return await repository.getAll();
});
