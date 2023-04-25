import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_assistant_app/constants/app_routes.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_talk_users_usecase.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../common_widgets/base_screen.dart';
import '../talk_room/talk_room_screen.dart';

class TalksScreen extends StatelessWidget {
  const TalksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      leading: Container(
        padding: const EdgeInsets.only(left: Sizes.p16),
        child: Text(
          'トーク',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      leadingWidth: 150.0,
      body: const _TalkListView(),
    );
  }
}

class _TalkListView extends ConsumerWidget {
  const _TalkListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    var users = ref.watch(fetchTalkUsersProvider);

    if (users.isEmpty) {
      return const Center(child: Text('ユーザーを追加するとここに表示されます'));
    }

    return ListView(
      children: [
        for (var user in users)
          Card(
            shadowColor: AppColors.ardoise,
            child: ListTile(
              leading: const Icon(
                Icons.account_circle_outlined,
                size: 40,
              ),
              title: Text(user.name),
              subtitle: Text(user.team),
              trailing: Text(user.lastTalkDate != null
                  ? outputFormat.format(user.lastTalkDate!)
                  : '-'),
              onTap: () => pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.talkRoom.name),
                screen: TalkRoomScreen(user: user),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ),
      ],
    );
  }
}
