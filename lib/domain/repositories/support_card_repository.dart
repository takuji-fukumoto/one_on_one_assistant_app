import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:one_on_one_assistant_app/store.dart';

import '../../objectbox.g.dart';

final supportCardRepositoryProvider = Provider<SupportCardRepository>((ref) {
  var dataStore = ref.watch(storeProvider);
  // FIXME: ここで初期値入れてもいいかも
  return SupportCardRepository(dataStore!.box<SupportCard>());
});

class SupportCardRepository {
  final Box<SupportCard> _box;

  SupportCardRepository(this._box);

  Future<SupportCard?> get(int id) async {
    return await _box.getAsync(id);
  }

  Future<SupportCard> add(SupportCard card) async {
    return await _box.putAndGetAsync(card);
  }

  Future<void> addMany(List<SupportCard> cards) async {
    await _box.putManyAsync(cards);
  }

  Future<void> update(SupportCard dstCard) async {
    await _box.putAsync(dstCard, mode: PutMode.update);
  }

  Future<List<SupportCard?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  Future<List<SupportCard>> getAll() async {
    return await _box.getAllAsync();
  }

  Future<bool> remove(int id) async {
    return await _box.removeAsync(id);
  }

  Future<void> removeAll() async {
    _box.removeAllAsync();
  }
}
