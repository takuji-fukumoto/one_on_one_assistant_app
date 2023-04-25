// TODO: sessionの追加、カードの追加、talkの保存
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';

import '../../presentation/screens/talk_room/talking/memo_section.dart';
import '../../presentation/screens/talk_room/talking/selected_card_field.dart';
import '../../presentation/screens/talk_room/talking/talking_screen.dart';
import '../models/session.dart';
import '../models/talk.dart';
import '../repositories/session_repository.dart';
import '../repositories/talk_repository.dart';
import 'fetch_user_talks_usecase.dart';

final manageTalkingUseCaseProvider =
    StateNotifierProvider.family<TalksStateNotifier, Talk, int>((ref, userId) {
  var repository = ref.watch(talkRepositoryProvider);

  return TalksStateNotifier(ref, repository, userId);
});

class TalksStateNotifier extends StateNotifier<Talk> {
  TalksStateNotifier(this.ref, this.repository, this.userId)
      : super(Talk(createdAt: DateTime.now()));

  final Ref ref;
  final int userId;
  final TalkRepository repository;

  void talkNext() {
    _addCurrentSection();

    resetSession();
  }

  void resetSession() {
    ref.read(selectedThemeCardProvider.notifier).state = null;
    ref.read(selectedSupportCardsProvider.notifier).state = [];
    ref.invalidate(segmentProvider);
  }

  void resetTalk() {
    resetSession();
    ref.read(editedMemoProvider.notifier).state = '';
  }

  Future<void> finishTalk() async {
    _addCurrentSection();
    _updateMemo();
    await ref.read(usersProvider.notifier).addUserTalk(userId, state);
    resetTalk();
    ref.invalidate(fetchUserTalksProvider(userId));
  }

  void _addCurrentSection() {
    var usedTheme = ref.read(selectedThemeCardProvider);
    var usedSupports = ref.read(selectedSupportCardsProvider);
    var newSession = Session(createdAt: DateTime.now());
    newSession.usedThemeCard.target = usedTheme;
    newSession.usedSupportCards.addAll(usedSupports);
    newSession.talk.target = state;
    ref.read(sessionRepositoryProvider).add(newSession);

    var sessions = state.sessions;
    sessions.add(newSession);
    state = state.copyWith(sessions: sessions);
  }

  void _updateMemo() {
    var memo = ref.read(editedMemoProvider);
    state = state.copyWith(memo: memo);
  }
}
