import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../../objectbox.g.dart';
import '../../models/user.dart';

class LocalUserRepositoryImpl implements RepositoryInterface<User> {
  final Box<User> _box;

  LocalUserRepositoryImpl(this._box);

  @override
  Future<User?> get(int id) async {
    return await _box.getAsync(id);
  }

  @override
  Future<User> add(User user) async {
    return await _box.putAndGetAsync(user);
  }

  @override
  Future<void> update(User dstUser) async {
    await _box.putAsync(dstUser, mode: PutMode.update);
  }

  @override
  Future<List<User?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  @override
  Future<void> addMany(List<User> users) async {
    await _box.putManyAsync(users);
  }

  @override
  Future<List<User>> getAll() async {
    return await _box.getAllAsync();
  }

  @override
  Future<bool> remove(int id) async {
    return await _box.removeAsync(id);
  }

  @override
  Future<void> removeMany(List<int> ids) async {
    await _box.removeManyAsync(ids);
  }

  @override
  Future<void> removeAll() async {
    await _box.removeAllAsync();
  }
}
