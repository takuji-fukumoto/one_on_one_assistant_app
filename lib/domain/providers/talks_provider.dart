import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_all_talks_usecase.dart';

import '../../data/repositories/talk_repository_provider.dart';
import '../models/session.dart';
import '../models/talk.dart';
import '../models/theme_card.dart';
import '../models/user.dart';

final talksProvider =
    StateNotifierProvider.autoDispose<TalksStateNotifier, List<Talk>>((ref) {
  var repository = ref.watch(talkRepositoryProvider);
  var talks = ref.watch(fetchAllTalkUseCaseProvider);
  if (talks.isLoading || talks.isRefreshing || talks.isReloading) {
    return TalksStateNotifier(ref, repository, []);
  }

  return TalksStateNotifier(ref, repository, talks.value);
});

class TalksStateNotifier extends StateNotifier<List<Talk>> {
  TalksStateNotifier(this._ref, this._repository, List<Talk>? initialList)
      : super(initialList ?? []);

  final Ref _ref;
  final RepositoryInterface<Talk> _repository;

  Future<void> addTalk(Talk talk) async {
    var newTalk = await _repository.add(talk);
    state = [...state, newTalk];
  }

  Future<void> updateTalk(Talk dstTalk) async {
    await _repository.update(dstTalk);
    if (mounted) {
      state = [
        for (final talk in state)
          if (talk.id != dstTalk.id) talk else dstTalk,
      ];
    }
  }

  Future<void> removeTalk(int id) async {
    await _repository.remove(id);
    state = [
      for (final talk in state)
        if (talk.id != id) talk,
    ];
  }

  Future<void> removeTalks(List<int> ids) async {
    await _repository.removeMany(ids);

    state = [
      for (final talk in state)
        if (!ids.contains(talk.id)) talk,
    ];
  }

  Future<void> removeUserAllTalks(User user) async {
    var userTalkIds = state
        .where((element) => element.user.target?.id == user.id)
        .map((e) => e.id!)
        .toList();
    await removeTalks(userTalkIds);
    state = [
      for (final talk in state)
        if (!userTalkIds.contains(talk.id)) talk,
    ];
  }

  Future<List<Session>> getTalkSessions(int talkId) async {
    var talk = await _repository.get(talkId);
    return talk!.sessions;
  }

  Future<void> addSession(int talkId, Session session) async {
    var dstTalk = await _repository.get(talkId);
    dstTalk!.addSession(session);
    state = [
      for (final talk in state)
        if (talk.id != dstTalk.id) talk else dstTalk,
    ];
  }

  Future<void> addThemeCardToSession(
      int talkId, int sessionId, ThemeCard card) async {
    var dstTalk = await _repository.get(talkId);
    dstTalk!.sessions
        .firstWhere((element) => element.id == sessionId)
        .addThemeCard(card);
    state = [
      for (final talk in state)
        if (talk.id != dstTalk.id) talk else dstTalk,
    ];
  }

  Future<void> addSupportCardToSession(
      int talkId, int sessionId, SupportCard card) async {
    var dstTalk = await _repository.get(talkId);
    dstTalk!.sessions
        .firstWhere((element) => element.id == sessionId)
        .addSupportCard(card);
    state = [
      for (final talk in state)
        if (talk.id != dstTalk.id) talk else dstTalk,
    ];
  }
}
