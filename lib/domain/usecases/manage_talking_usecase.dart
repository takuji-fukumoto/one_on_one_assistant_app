// TODO: sessionの追加、カードの追加、talkの保存
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';

import '../../presentation/screens/talk_room/talking/memo_section.dart';
import '../../presentation/screens/talk_room/talking/selected_card_field.dart';
import '../../presentation/screens/talk_room/talking/talking_screen.dart';
import '../models/session.dart';
import '../models/talk.dart';
import '../repositories/session_repository_provider.dart';
import 'fetch_user_talks_usecase.dart';

final manageTalkingUseCaseProvider =
    StateNotifierProvider.family<TalksStateNotifier, Talk, int>((ref, userId) {
  return TalksStateNotifier(ref, userId);
});

class TalksStateNotifier extends StateNotifier<Talk> {
  TalksStateNotifier(this.ref, this.userId)
      : super(Talk(createdAt: DateTime.now()));

  final Ref ref;
  final int userId;

  Future<void> talkNext() async {
    await _addCurrentSection();

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
    await _addCurrentSection();
    _updateMemo();
    await ref.read(usersProvider.notifier).addUserTalk(userId, state);
    resetTalk();
    ref.invalidate(fetchUserTalksProvider(userId));
  }

  Future<void> _addCurrentSection() async {
    var usedTheme = ref.read(selectedThemeCardProvider);
    var usedSupports = ref.read(selectedSupportCardsProvider);
    var newSession = Session(createdAt: DateTime.now());
    newSession.usedThemeCard.target = usedTheme;
    newSession.usedSupportCards.addAll(usedSupports);
    newSession.talk.target = state;
    await ref.read(sessionRepositoryProvider).add(newSession);

    var sessions = state.sessions;
    sessions.add(newSession);
    state = state.copyWith(sessions: sessions);
  }

  void _updateMemo() {
    var memo = ref.read(editedMemoProvider);
    state = state.copyWith(memo: memo);
  }
}
