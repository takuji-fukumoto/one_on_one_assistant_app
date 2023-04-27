import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';

import '../../../domain/models/objectbox.g.dart';
import '../../../domain/models/session.dart';

class LocalSessionRepositoryImpl implements RepositoryInterface<Session> {
  final Box<Session> _box;

  LocalSessionRepositoryImpl(this._box);

  @override
  Future<Session?> get(int id) async {
    return await _box.getAsync(id);
  }

  @override
  Future<Session> add(Session session) async {
    return await _box.putAndGetAsync(session);
  }

  @override
  Future<void> addMany(List<Session> sessions) async {
    await _box.putManyAsync(sessions);
  }

  @override
  Future<void> update(Session session) async {
    await _box.putAsync(session, mode: PutMode.update);
  }

  @override
  Future<List<Session?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  @override
  Future<List<Session>> getAll() async {
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
