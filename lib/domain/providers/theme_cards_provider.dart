import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/constants/default_data.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';
import 'package:one_on_one_assistant_app/domain/repositories/theme_card_repository.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_all_theme_cards_usecase.dart';

final themeCardsProvider =
    StateNotifierProvider.autoDispose<ThemeCardsStateNotifier, List<ThemeCard>>(
        (ref) {
  var repository = ref.watch(themeCardRepositoryProvider);
  // var cards = repository.getAll();
  var cards = ref.watch(fetchAllThemeCardsProvider);
  if (cards.isLoading || cards.isRefreshing || cards.isReloading) {
    return ThemeCardsStateNotifier(ref, repository, []);
  }

  return ThemeCardsStateNotifier(ref, repository, cards.value);
});

class ThemeCardsStateNotifier extends StateNotifier<List<ThemeCard>> {
  ThemeCardsStateNotifier(
      this.ref, this.repository, List<ThemeCard>? initialList)
      : super(initialList ?? []);

  final Ref ref;
  final ThemeCardRepository repository;

  Future<void> addCard(ThemeCard card) async {
    var newCard = await repository.add(card);
    state = [...state, newCard];
  }

  Future<void> updateCard(ThemeCard dstCard) async {
    await repository.update(dstCard);
    state = [
      for (final card in state)
        if (card.id != dstCard.id) card else dstCard,
    ];
  }

  Future<void> removeCard(int id) async {
    await repository.remove(id);
    state = [
      for (final card in state)
        if (card.id != id) card,
    ];
  }

  Future<void> reset() async {
    await repository.removeAll();
    await repository.addMany(defaultThemeCards);
    if (mounted) {
      state = defaultThemeCards;
    }
  }
}
