import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/local/support_card_repository.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';

import '../../domain/models/support_card.dart';
import '../../store.dart';

final supportCardRepositoryProvider =
    Provider<RepositoryInterface<SupportCard>>((ref) {
  // MEMO: 今後リモートから取得する場合はここで切り替え
  var dataStore = ref.watch(storeProvider);
  return LocalSupportCardRepositoryImpl(dataStore!.box<SupportCard>());
});
