import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/data/repositories/repository_interface.dart';

import '../../domain/models/theme_card.dart';
import 'local/theme_card_repository.dart';
import 'local_store_provider.dart';

final themeCardRepositoryProvider =
    Provider<RepositoryInterface<ThemeCard>>((ref) {
  // MEMO: 今後リモートから取得する場合はここで切り替え
  var dataStore = ref.watch(storeProvider);
  return LocalThemeCardRepositoryImpl(dataStore!.box<ThemeCard>());
});
