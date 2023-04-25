import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';
import 'package:one_on_one_assistant_app/domain/repositories/theme_card_repository.dart';

final fetchAllThemeCardsProvider =
    FutureProvider.autoDispose<List<ThemeCard>>((ref) async {
  var repository = ref.watch(themeCardRepositoryProvider);

  return await repository.getAll();
});
