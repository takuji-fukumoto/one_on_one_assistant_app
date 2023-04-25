import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/async_value_widget.dart';
import 'package:one_on_one_assistant_app/presentation/screens/talk_room/talk_detail.dart';
import 'package:one_on_one_assistant_app/presentation/screens/talk_room/talking/talking_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_sizes.dart';
import '../../../domain/models/talk.dart';
import '../../../domain/models/user.dart';
import '../../../domain/usecases/fetch_user_talks_usecase.dart';
import '../../common_widgets/base_screen.dart';

class TalkRoomScreen extends ConsumerWidget {
  final User user;
  const TalkRoomScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScreen(
      appBarTitle: user.name,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushNewScreenWithRouteSettings(
            context,
            settings: RouteSettings(name: AppRoute.talking.name),
            screen: TalkingScreen(user: user),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        foregroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: _TalkRoomListView(user: user),
    );
  }
}

class _TalkRoomListView extends ConsumerWidget {
  final User user;
  const _TalkRoomListView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    return AsyncValueWidget(
      asyncValue: ref.watch(fetchUserTalksProvider(user.id!)),
      data: (talks) {
        if (talks.isEmpty) {
          return const Center(
            child: Text(
              'トークがありません\n＋ボタンをタップして1on1を開始できます',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black38),
            ),
          );
        }

        return GroupedListView<Talk, String>(
          elements: talks,
          reverse: true,
          order: GroupedListOrder.DESC,
          groupBy: (talk) => outputFormat.format(talk.createdAt!),
          groupSeparatorBuilder: (String groupByValue) => _SeparatorBuilder(
            groupByValue: groupByValue,
          ),
          itemBuilder: (context, Talk talk) => _ChatBubble(
            talk: talk,
          ),
          floatingHeader: true,
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final Talk talk;
  const _ChatBubble({Key? key, required this.talk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat outputFormat = DateFormat('Hm');

    return GestureDetector(
      onTap: () => {
        pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: AppRoute.talkDetail.name),
          screen: TalkDetail(talkId: talk.id!),
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ),
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Sizes.p8, horizontal: Sizes.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                ),
                Expanded(
                  child: BubbleSpecialThree(
                    text: talk.memo ?? 'メモはありません',
                    color: AppColors.ivory,
                    tail: true,
                    isSender: false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: Sizes.p12),
                  child: Text(
                    outputFormat.format(talk.createdAt!),
                    style: const TextStyle(color: AppColors.ardoise),
                  ),
                ),
              ],
            ),
            Row(
              children: const [
                gapW48,
                Text(
                  'タップして詳細を確認',
                  style: TextStyle(color: AppColors.ardoise),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeparatorBuilder extends StatelessWidget {
  final String groupByValue;
  const _SeparatorBuilder({Key? key, required this.groupByValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding:
          const EdgeInsets.symmetric(vertical: Sizes.p8, horizontal: Sizes.p48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            child: _SeparateLine(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
            child: Text(
              groupByValue,
              style: const TextStyle(color: AppColors.ardoise),
            ),
          ),
          const Expanded(
            child: _SeparateLine(),
          ),
        ],
      ),
    );
  }
}

class _SeparateLine extends StatelessWidget {
  const _SeparateLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black26,
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
