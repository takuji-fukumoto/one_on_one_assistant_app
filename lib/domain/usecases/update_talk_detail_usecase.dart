import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_user_talks_usecase.dart';

import '../models/talk.dart';
import '../models/user.dart';

final updateTalkDetailUseCaseProvider =
    Provider<UpdateTalkDetailUseCase>((ref) {
  return UpdateTalkDetailUseCase(ref);
});

class UpdateTalkDetailUseCase {
  UpdateTalkDetailUseCase(this.ref);
  final Ref ref;

  Future<void> execute(User user, Talk talk) async {
    await ref.read(usersProvider.notifier).updateUserTalk(user.id!, talk);
    ref.invalidate(fetchUserTalksProvider);
  }
}
