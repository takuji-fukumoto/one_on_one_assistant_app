import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/talk_repository_provider.dart';
import '../models/talk.dart';

final fetchTalkUseCaseProvider =
    FutureProvider.autoDispose.family<Talk?, int>((ref, talkId) async {
  var repository = ref.watch(talkRepositoryProvider);

  return await repository.get(talkId);
});
