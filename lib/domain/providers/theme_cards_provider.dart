import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/constants/default_data.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_all_theme_cards_usecase.dart';

import '../../data/repositories/theme_card_repository_provider.dart';

final themeCardsProvider =
    StateNotifierProvider.autoDispose<ThemeCardsStateNotifier, List<ThemeCard>>(
        (ref) {
  var repository = ref.watch(themeCardRepositoryProvider);
  var cards = ref.watch(fetchAllThemeCardsProvider);
  if (cards.isLoading || cards.isRefreshing || cards.isReloading) {
    return ThemeCardsStateNotifier(ref, repository, []);
  }

  return ThemeCardsStateNotifier(ref, repository, cards.value);
});

class ThemeCardsStateNotifier extends StateNotifier<List<ThemeCard>> {
  ThemeCardsStateNotifier(
      this._ref, this._repository, List<ThemeCard>? initialList)
      : super(initialList ?? []);

  final Ref _ref;
  final RepositoryInterface<ThemeCard> _repository;

  Future<void> addCard(ThemeCard card) async {
    var newCard = await _repository.add(card);
    state = [...state, newCard];
  }

  Future<void> updateCard(ThemeCard dstCard) async {
    await _repository.update(dstCard);
    state = [
      for (final card in state)
        if (card.id != dstCard.id) card else dstCard,
    ];
  }

  Future<void> removeCard(int id) async {
    await _repository.remove(id);
    state = [
      for (final card in state)
        if (card.id != id) card,
    ];
  }

  Future<void> reset() async {
    await _repository.removeAll();
    await _repository.addMany(defaultThemeCards);
    if (mounted) {
      state = defaultThemeCards;
    }
  }
}
