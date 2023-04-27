import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/talks_provider.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/repositories/session_repository_provider.dart';

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
  UsersStateNotifier(this._ref, this._repository, List<User>? initialList)
      : super(initialList ?? []);

  final Ref _ref;
  final RepositoryInterface<User> _repository;

  Future<User?> getUser(int userId) async {
    return await _repository.get(userId);
  }

  Future<void> addUser(User user) async {
    var newUser = await _repository.add(user);
    state = [...state, newUser];
  }

  Future<void> updateUser(User dstUser) async {
    await _repository.update(dstUser);
    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }

  Future<void> removeUser(int id) async {
    var user = await _repository.get(id);
    if (user == null) {
      return;
    }

    // ユーザーに紐づくTalk, Sessionを全て削除
    await _ref.read(talksProvider.notifier).removeUserAllTalks(user);
    // TODO: session providerに移行する
    var userSessionIds = <int>[];
    for (var talk in user.talks) {
      for (var session in talk.sessions) {
        userSessionIds.add(session.id!);
      }
    }
    await _ref.read(sessionRepositoryProvider).removeMany(userSessionIds);

    await _repository.remove(id);
    state = [
      for (final user in state)
        if (user.id != id) user,
    ];
  }

  Future<void> addUserTalk(int userId, Talk talk) async {
    var dstUser = await _repository.get(userId);
    dstUser!.talks.add(talk);
    await _repository.add(dstUser);

    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }

  Future<void> updateUserTalk(int userId, Talk talk) async {
    var dstUser = await _repository.get(userId);
    var targetIndex =
        dstUser!.talks.indexWhere((element) => element.id == talk.id);
    dstUser.talks.replaceRange(targetIndex, targetIndex, [talk]);
    await _repository.update(dstUser);

    state = [
      for (final user in state)
        if (user.id != dstUser.id) user else dstUser,
    ];
  }
}
