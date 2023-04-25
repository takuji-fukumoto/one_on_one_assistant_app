import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_all_talks_usecase.dart';

import '../models/session.dart';
import '../models/talk.dart';
import '../models/theme_card.dart';
import '../repositories/talk_repository_provider.dart';

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
  TalksStateNotifier(this.ref, this.repository, List<Talk>? initialList)
      : super(initialList ?? []);

  final Ref ref;
  final RepositoryInterface<Talk> repository;

  Future<void> addTalk(Talk talk) async {
    var newTalk = await repository.add(talk);
    state = [...state, newTalk];
  }

  Future<void> updateTalk(Talk dstTalk) async {
    await repository.update(dstTalk);
    if (mounted) {
      state = [
        for (final talk in state)
          if (talk.id != dstTalk.id) talk else dstTalk,
      ];
    }
  }

  Future<void> removeTalk(int id) async {
    await repository.remove(id);
    state = [
      for (final talk in state)
        if (talk.id != id) talk,
    ];
  }

  Future<List<Session>> getTalkSessions(int talkId) async {
    var talk = await repository.get(talkId);
    return talk!.sessions;
  }

  Future<void> addSession(int talkId, Session session) async {
    var dstTalk = await repository.get(talkId);
    dstTalk!.addSession(session);
    state = [
      for (final talk in state)
        if (talk.id != dstTalk.id) talk else dstTalk,
    ];
  }

  Future<void> addThemeCardToSession(
      int talkId, int sessionId, ThemeCard card) async {
    var dstTalk = await repository.get(talkId);
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
    var dstTalk = await repository.get(talkId);
    dstTalk!.sessions
        .firstWhere((element) => element.id == sessionId)
        .addSupportCard(card);
    state = [
      for (final talk in state)
        if (talk.id != dstTalk.id) talk else dstTalk,
    ];
  }
}
