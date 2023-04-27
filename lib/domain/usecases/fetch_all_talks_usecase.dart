import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/talk_repository_provider.dart';
import '../models/talk.dart';

final fetchAllTalkUseCaseProvider =
    FutureProvider.autoDispose<List<Talk>>((ref) async {
  var repository = ref.watch(talkRepositoryProvider);

  return await repository.getAll();
});
