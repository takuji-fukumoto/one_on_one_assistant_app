import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';

import '../../../domain/models/objectbox.g.dart';

class LocalThemeCardRepositoryImpl implements RepositoryInterface<ThemeCard> {
  final Box<ThemeCard> _box;

  LocalThemeCardRepositoryImpl(this._box);

  @override
  Future<ThemeCard?> get(int id) async {
    return await _box.getAsync(id);
  }

  @override
  Future<List<ThemeCard>> getAll() async {
    return await _box.getAllAsync();
  }

  @override
  Future<ThemeCard> add(ThemeCard card) async {
    return await _box.putAndGetAsync(card);
  }

  @override
  Future<void> addMany(List<ThemeCard> cards) async {
    await _box.putManyAsync(cards);
  }

  @override
  Future<void> update(ThemeCard dstCard) async {
    await _box.putAsync(dstCard, mode: PutMode.update);
  }

  @override
  Future<List<ThemeCard?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
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
    _box.removeAllAsync();
  }
}
