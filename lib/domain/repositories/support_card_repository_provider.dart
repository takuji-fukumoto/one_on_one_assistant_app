import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/repositories/local/support_card_repository.dart';
import 'package:one_on_one_assistant_app/domain/repositories/repository_interface.dart';

import '../../store.dart';
import '../models/support_card.dart';

final supportCardRepositoryProvider =
    Provider<RepositoryInterface<SupportCard>>((ref) {
  // MEMO: 今後リモートから取得する場合はここで切り替え
  var dataStore = ref.watch(storeProvider);
  return LocalSupportCardRepositoryImpl(dataStore!.box<SupportCard>());
});
