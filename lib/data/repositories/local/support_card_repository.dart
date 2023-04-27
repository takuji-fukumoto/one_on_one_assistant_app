import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';

import '../../../objectbox.g.dart';

class LocalSupportCardRepositoryImpl
    implements RepositoryInterface<SupportCard> {
  final Box<SupportCard> _box;

  LocalSupportCardRepositoryImpl(this._box);

  @override
  Future<SupportCard?> get(int id) async {
    return await _box.getAsync(id);
  }

  @override
  Future<SupportCard> add(SupportCard card) async {
    return await _box.putAndGetAsync(card);
  }

  @override
  Future<void> addMany(List<SupportCard> cards) async {
    await _box.putManyAsync(cards);
  }

  @override
  Future<void> update(SupportCard dstCard) async {
    await _box.putAsync(dstCard, mode: PutMode.update);
  }

  @override
  Future<List<SupportCard?>> getMany(List<int> ids) async {
    return await _box.getManyAsync(ids);
  }

  @override
  Future<List<SupportCard>> getAll() async {
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
    _box.removeAllAsync();
  }
}
