import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../repositories/user_repository_provider.dart';

final fetchAllUsersProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  var repository = ref.watch(userRepositoryProvider);

  return await repository.getAll();
});
