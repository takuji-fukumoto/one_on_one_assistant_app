// TODO: sessionの追加、カードの追加、talkの保存
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';

import '../../data/repositories/session_repository_provider.dart';
import '../../presentation/screens/talk_room/talking/memo_section.dart';
import '../../presentation/screens/talk_room/talking/selected_card_field.dart';
import '../../presentation/screens/talk_room/talking/talking_screen.dart';
import '../models/session.dart';
import '../models/talk.dart';
import 'fetch_user_talks_usecase.dart';

final manageTalkingUseCaseProvider =
    StateNotifierProvider.family<TalksStateNotifier, Talk, int>((ref, userId) {
  return TalksStateNotifier(ref, userId);
});

class TalksStateNotifier extends StateNotifier<Talk> {
  TalksStateNotifier(this._ref, this._userId)
      : super(Talk(createdAt: DateTime.now()));

  final Ref _ref;
  final int _userId;

  Future<void> talkNext() async {
    await _addCurrentSection();

    resetSession();
  }

  void resetSession() {
    _ref.read(selectedThemeCardProvider.notifier).state = null;
    _ref.read(selectedSupportCardsProvider.notifier).state = [];
    _ref.invalidate(segmentProvider);
  }

  void resetTalk() {
    resetSession();
    _ref.read(editedMemoProvider.notifier).state = '';
  }

  Future<void> finishTalk() async {
    await _addCurrentSection();
    _updateMemo();
    await _ref.read(usersProvider.notifier).addUserTalk(_userId, state);
    resetTalk();
    _ref.invalidate(fetchUserTalksProvider(_userId));
  }

  Future<void> _addCurrentSection() async {
    var usedTheme = _ref.read(selectedThemeCardProvider);
    var usedSupports = _ref.read(selectedSupportCardsProvider);
    var newSession = Session(createdAt: DateTime.now());
    newSession.usedThemeCard.target = usedTheme;
    newSession.usedSupportCards.addAll(usedSupports);
    newSession.talk.target = state;
    await _ref.read(sessionRepositoryProvider).add(newSession);

    var sessions = state.sessions;
    sessions.add(newSession);
    state = state.copyWith(sessions: sessions);
  }

  void _updateMemo() {
    var memo = _ref.read(editedMemoProvider);
    state = state.copyWith(memo: memo);
  }
}
