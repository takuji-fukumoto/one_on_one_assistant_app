import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository_provider.dart';
import '../models/user.dart';

final fetchAllUsersProvider =
    FutureProvider.autoDispose<List<User>>((ref) async {
  var repository = ref.watch(userRepositoryProvider);

  return await repository.getAll();
});
