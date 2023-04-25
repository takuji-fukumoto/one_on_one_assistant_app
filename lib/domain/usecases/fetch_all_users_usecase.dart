import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/user_repository.dart';

import '../models/user.dart';

final fetchAllUsersProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  var repository = ref.watch(userRepositoryProvider);

  return await repository.getAll();
});
