/// 一番下にテーマ、サポートのセグメント
/// 選択したセグメントのカード一覧をすぐ上にカルーセル形式で表示
/// その上にカードを出すスペースがある
/// スペースにはテーマ、サポートカードをそれぞれ一枚出せる（上書き可能）
/// トークを終える場合「終了」ボタン
/// そのまま次のテーマで話したい場合は「次のテーマ」ボタン
import 'dart:math' as math;

import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:one_on_one_assistant_app/constants/app_sizes.dart';
import 'package:one_on_one_assistant_app/domain/providers/support_cards_provider.dart';
import 'package:one_on_one_assistant_app/domain/providers/theme_cards_provider.dart';
import 'package:one_on_one_assistant_app/domain/usecases/manage_talking_usecase.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/support_card_builder.dart';
import 'package:one_on_one_assistant_app/presentation/screens/talk_room/talking/selected_card_field.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_routes.dart';
import '../../../../domain/models/support_card.dart';
import '../../../../domain/models/theme_card.dart';
import '../../../../domain/models/user.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/theme_card_builder.dart';
import 'memo_section.dart';

final segmentProvider = StateProvider.autoDispose<String>((ref) => 'theme');

class TalkingScreen extends ConsumerWidget {
  final User user;
  const TalkingScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return BaseScreen(
      appBarTitle: '1on1トーク',
      leading: TextButton(
        onPressed: () {
          ref.read(manageTalkingUseCaseProvider(user.id!).notifier).resetTalk();

          // FIXME: なぜページ名が入っていないか要調査（おそらくnavbarを出してないから）
          Navigator.of(context).popUntil(ModalRoute.withName("/"));
        },
        child: const Text(
          'キャンセル',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      leadingWidth: 100.0,
      body: Stack(
        children: [
          _TalkingScreenBody(user: user),
          SlidingUpPanel(
            panel: const MemoSection(),
            collapsed: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.swipe_up_outlined),
                gapW4,
                Text('メモを取る'),
              ],
            ),
            minHeight: 55.0,
            maxHeight: size.height / 2.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
          ),
        ],
      ),
    );
  }
}

class _TalkingScreenBody extends ConsumerWidget {
  final User user;
  const _TalkingScreenBody({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: SelectedCardField()),
          _SelectCardSection(),
          gapH8,
          _MenuButtons(user: user),
          gapH64,
        ],
      ),
    );
  }
}

class _SelectCardSection extends ConsumerWidget {
  final CarouselController controller = CarouselController();

  _SelectCardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(segmentProvider);
    var items = type == 'theme'
        ? ref.watch(themeCardsProvider)
        : ref.watch(supportCardsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        gapH4,
        CarouselSlider(
          carouselController: controller,
          items: [
            for (var item in items) _CardBuilder(item: item),
          ],
          options: CarouselOptions(
            height: 200,
            aspectRatio: 9 / 16,
            viewportFraction: 0.7,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
        ),
        gapH4,
        Row(
          children: [
            const Expanded(child: SizedBox()),
            const _CardTypeSelectionSegment(),
            const Expanded(child: SizedBox()),
            IconButton(
              padding: const EdgeInsets.all(4.0),
              onPressed: () {
                var random = math.Random();
                controller.animateToPage(
                  random.nextInt(items.length - 1),
                  curve: Curves.easeOutExpo,
                );
              },
              icon: const Icon(Icons.shuffle),
            ),
            gapW8,
          ],
        ),
      ],
    );
  }
}

class _CardBuilder extends StatelessWidget {
  final dynamic item;
  const _CardBuilder({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.5;
    final height = width * (3 / 4);
    dynamic card = item;
    if (item is ThemeCard) {
      card as ThemeCard;
      return LongPressDraggable<ThemeCard>(
        data: card,
        feedback: SizedBox(
          width: width,
          height: height,
          child: Opacity(
            opacity: 0.5,
            child: ThemeCardBuilder(card: card),
          ),
        ),
        child: SizedBox(
          width: 400,
          child: ThemeCardBuilder(card: card),
        ),
      );
    } else {
      card as SupportCard;
      return LongPressDraggable<SupportCard>(
        data: card,
        feedback: SizedBox(
          width: width,
          height: height,
          child: Opacity(
            opacity: 0.5,
            child: SupportCardBuilder(card: card),
          ),
        ),
        child: SizedBox(
          width: 400,
          child: SupportCardBuilder(card: card),
        ),
      );
    }
  }
}

class _CardTypeSelectionSegment extends ConsumerStatefulWidget {
  const _CardTypeSelectionSegment({Key? key}) : super(key: key);

  @override
  ConsumerState<_CardTypeSelectionSegment> createState() =>
      _CardTypeSelectionSegmentState();
}

class _CardTypeSelectionSegmentState
    extends ConsumerState<_CardTypeSelectionSegment> {
  ValueNotifier<String> controller = ValueNotifier('all');

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      updateValue();
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {
      updateValue();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedSegment(
      controller: controller,
      backgroundColor: AppColors.buckwheat,
      segments: const {
        'theme': 'テーマ',
        'support': 'サポート',
      },
    );
  }

  void updateValue() {
    ref.read(segmentProvider.notifier).state = controller.value;
  }
}

class _MenuButtons extends ConsumerWidget {
  final User user;
  const _MenuButtons({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        gapW8,
        Expanded(
          child: BaseButton(
            onPressed: () {
              if (!_isSelectedThemeCard(ref)) {
                _showErrorDialog(context);
                return;
              }

              ref
                  .read(manageTalkingUseCaseProvider(user.id!).notifier)
                  .talkNext();
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.talking.name),
                screen: TalkingScreen(user: user),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                  size: 20,
                ),
                Text('次のテーマへ', style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ),
        gapW16,
        Expanded(
          child: BaseButton(
            onPressed: () async {
              if (!_isSelectedThemeCard(ref)) {
                _showErrorDialog(context);
                return;
              }

              await ref
                  .read(manageTalkingUseCaseProvider(user.id!).notifier)
                  .finishTalk()
                  .then((value) {
                Navigator.of(context).popUntil(ModalRoute.withName("/"));
                Flushbar(
                  message: "トーク内容を保存しました",
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(8),
                ).show(context);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                Text('トーク終了', style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ),
        gapW8,
      ],
    );
  }

  bool _isSelectedThemeCard(WidgetRef ref) {
    return ref.read(selectedThemeCardProvider.notifier).state != null;
  }

  void _showErrorDialog(BuildContext context) {
    Dialogs.bottomMaterialDialog(
      msg: 'テーマカードを選択してください',
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'OK',
          iconData: Icons.check_circle,
          textStyle: const TextStyle(color: Colors.black54),
          iconColor: Colors.green,
        ),
      ],
    );
  }
}
