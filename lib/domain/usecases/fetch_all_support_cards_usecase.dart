import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';

import '../repositories/support_card_repository_provider.dart';

final fetchAllSupportCardsProvider =
    FutureProvider.autoDispose<List<SupportCard>>((ref) async {
  var repository = ref.watch(supportCardRepositoryProvider);

  return await repository.getAll();
});
