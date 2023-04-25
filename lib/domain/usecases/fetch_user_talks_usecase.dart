import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';

import '../models/talk.dart';

final fetchUserTalksProvider =
    FutureProvider.family.autoDispose<List<Talk>, int>((ref, userId) async {
  var provider = ref.watch(usersProvider.notifier);
  var user = await provider.getUser(userId);
  var orderedTalks = user!.talks.map((e) => e.copyWith()).toList();
  orderedTalks.sort((a, b) {
    var dateA = a.createdAt ?? DateTime.parse("2022-01-01 00:00:00");
    var dateB = b.createdAt ?? DateTime.parse("2022-01-01 00:00:00");

    return dateA.compareTo(dateB);
  });
  return orderedTalks;
});
