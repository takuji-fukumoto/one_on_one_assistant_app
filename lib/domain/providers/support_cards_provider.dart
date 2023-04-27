import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/constants/default_data.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_all_support_cards_usecase.dart';

import '../repositories/support_card_repository_provider.dart';

final supportCardsProvider = StateNotifierProvider.autoDispose<
    SupportCardsStateNotifier, List<SupportCard>>((ref) {
  var repository = ref.watch(supportCardRepositoryProvider);
  var cards = ref.watch(fetchAllSupportCardsProvider);
  if (cards.isLoading || cards.isRefreshing || cards.isReloading) {
    return SupportCardsStateNotifier(ref, repository, []);
  }

  return SupportCardsStateNotifier(ref, repository, cards.value);
});

class SupportCardsStateNotifier extends StateNotifier<List<SupportCard>> {
  SupportCardsStateNotifier(
      this._ref, this._repository, List<SupportCard>? initialList)
      : super(initialList ?? []);

  final Ref _ref;
  final RepositoryInterface<SupportCard> _repository;

  Future<void> addCard(SupportCard card) async {
    var newCard = await _repository.add(card);
    state = [...state, newCard];
  }

  Future<void> updateCard(SupportCard dstCard) async {
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
    await _repository.addMany(defaultSupportCards);
    if (mounted) {
      state = defaultSupportCards;
    }
  }
}
