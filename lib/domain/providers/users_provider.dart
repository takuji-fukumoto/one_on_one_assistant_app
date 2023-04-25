import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../models/talk.dart';
import '../models/user.dart';
import '../repositories/user_repository_provider.dart';
import '../usecases/fetch_all_users_usecase.dart';

final usersProvider =
    StateNotifierProvider.autoDispose<UsersStateNotifier, List<User>>((ref) {
  var repository = ref.watch(userRepositoryProvider);
  var users = ref.watch(fetchAllUsersProvider);
  if (users.isLoading || users.isRefreshing || users.isReloading) {
    return UsersStateNotifier(ref, repository, []);
  }

  return UsersStateNotifier(ref, repository, users.value);
});

class UsersStateNotifier extends StateNotifier<List<User>> {
  UsersStateNotifier(this.ref, this.repository, List<User>? initialList)
      : super(initialList ?? []);

  final Ref ref;
  final RepositoryInterface<User> repository;

  /// TODO: 他のproviderにもgetあった方がいいかも
  Future<User?> getUser(int userId) async {
    return await repository.get(userId);
  }

  Future<void> addUser(User user) async {
    var newUser = await repository.add(user);
    state = [...state, newUser];
  }

  Future<void> updateUser(User dstUser) async {
    await repository.update(dstUser);
    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }

  Future<void> removeUser(int id) async {
    // TODO: ユーザーに紐づくTalk, Sessionを全て削除する
    var user = await repository.get(id);
    if (user == null) {
      return;
    }

    await repository.remove(id);
    state = [
      for (final user in state)
        if (user.id != id) user,
    ];
  }

  Future<void> addUserTalk(int userId, Talk talk) async {
    var dstUser = await repository.get(userId);
    dstUser!.talks.add(talk);
    await repository.add(dstUser);

    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }

  Future<void> updateUserTalk(int userId, Talk talk) async {
    var dstUser = await repository.get(userId);
    var targetIndex =
        dstUser!.talks.indexWhere((element) => element.id == talk.id);
    dstUser.talks.replaceRange(targetIndex, targetIndex, [talk]);
    await repository.update(dstUser);

    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }
}
