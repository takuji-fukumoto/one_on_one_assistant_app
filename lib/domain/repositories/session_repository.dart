import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/store.dart';

import '../../objectbox.g.dart';
import '../models/session.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  var dataStore = ref.watch(storeProvider);
  return SessionRepository(dataStore!.box<Session>());
});

class SessionRepository {
  final Box<Session> _box;

  SessionRepository(this._box);

  Session? get(int id) {
    return _box.get(id);
  }

  void add(Session session) {
    _box.put(session);
  }

  void update(Session session) {
    _box.put(session, mode: PutMode.update);
  }

  List<Session?> getMany(List<int> ids) {
    return _box.getMany(ids);
  }

  List<Session> getAll() {
    return _box.getAll();
  }

  bool remove(int id) {
    return _box.remove(id);
  }
}
