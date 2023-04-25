import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/users_provider.dart';

final fetchTalkUsersProvider = StateProvider.autoDispose<List<User>>((ref) {
  var users = ref.watch(usersProvider);
  var orderedUsers = users.map((e) => e.copyWith()).toList();
  orderedUsers.sort((a, b) {
    var dateA = a.talks.isNotEmpty
        ? a.talks.last.createdAt ?? DateTime.parse("2022-01-01 00:00:00")
        : DateTime.parse("2022-01-01 00:00:00");
    var dateB = b.talks.isNotEmpty
        ? b.talks.last.createdAt ?? DateTime.parse("2022-01-01 00:00:00")
        : DateTime.parse("2022-01-01 00:00:00");

    return dateB.compareTo(dateA);
  });
  return orderedUsers;
});
