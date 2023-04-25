import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/store.dart';

import '../../objectbox.g.dart';
import '../models/talk.dart';

final talkRepositoryProvider = Provider<TalkRepository>((ref) {
  var dataStore = ref.watch(storeProvider);
  return TalkRepository(dataStore!.box<Talk>());
});

class TalkRepository {
  final Box<Talk> _box;

  TalkRepository(this._box);

  Future<Talk?> get(int id) async {
    return await _box.getAsync(id);
  }

  Future<Talk> add(Talk talk) async {
    return await _box.putAndGetAsync(talk);
  }

  Future<void> update(Talk dstTalk) async {
    await _box.putAsync(dstTalk, mode: PutMode.update);
  }

  Future<List<Talk?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  Future<List<Talk>> getAll() async {
    return await _box.getAllAsync();
  }

  Future<bool> remove(int id) async {
    return await _box.removeAsync(id);
  }
}
