import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';
import 'package:one_on_one_assistant_app/store.dart';

import '../../objectbox.g.dart';

final themeCardRepositoryProvider = Provider<ThemeCardRepository>((ref) {
  var dataStore = ref.watch(storeProvider);
  // FIXME: ここで初期値入れてもいいかも
  return ThemeCardRepository(dataStore!.box<ThemeCard>());
});

class ThemeCardRepository {
  final Box<ThemeCard> _box;

  ThemeCardRepository(this._box);

  Future<ThemeCard?> get(int id) async {
    return await _box.getAsync(id);
  }

  Future<ThemeCard> add(ThemeCard card) async {
    return await _box.putAndGetAsync(card);
  }

  Future<void> addMany(List<ThemeCard> cards) async {
    await _box.putManyAsync(cards);
  }

  Future<void> update(ThemeCard dstCard) async {
    await _box.putAsync(dstCard, mode: PutMode.update);
  }

  Future<List<ThemeCard?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  Future<List<ThemeCard>> getAll() async {
    return await _box.getAllAsync();
  }

  Future<bool> remove(int id) async {
    return await _box.removeAsync(id);
  }

  Future<void> removeAll() async {
    _box.removeAllAsync();
  }
}
