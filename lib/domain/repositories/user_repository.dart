import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/store.dart';

import '../../objectbox.g.dart';
import '../models/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  var dataStore = ref.watch(storeProvider);
  return UserRepository(dataStore!.box<User>());
});

class UserRepository {
  final Box<User> _box;

  UserRepository(this._box);

  Future<User?> get(int id) async {
    return await _box.getAsync(id);
  }

  Future<User> add(User user) async {
    return await _box.putAndGetAsync(user);
  }

  Future<void> update(User dstUser) async {
    await _box.putAsync(dstUser, mode: PutMode.update);
  }

  Future<List<User?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  Future<List<User>> getAll() async {
    return await _box.getAllAsync();
  }

  Future<bool> remove(int id) async {
    return await _box.removeAsync(id);
  }

  Future<void> removeAll() async {
    await _box.removeAllAsync();
  }
}
