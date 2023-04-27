import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../../objectbox.g.dart';
import '../../models/talk.dart';

class LocalTalkRepositoryImpl implements RepositoryInterface<Talk> {
  final Box<Talk> _box;

  LocalTalkRepositoryImpl(this._box);

  @override
  Future<Talk?> get(int id) async {
    return await _box.getAsync(id);
  }

  @override
  Future<Talk> add(Talk talk) async {
    return await _box.putAndGetAsync(talk);
  }

  @override
  Future<void> addMany(List<Talk> talks) async {
    await _box.putManyAsync(talks);
  }

  @override
  Future<void> update(Talk dstTalk) async {
    await _box.putAsync(dstTalk, mode: PutMode.update);
  }

  @override
  Future<List<Talk?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  @override
  Future<List<Talk>> getAll() async {
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
