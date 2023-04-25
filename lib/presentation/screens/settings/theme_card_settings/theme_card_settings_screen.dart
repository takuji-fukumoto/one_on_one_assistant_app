import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/theme_cards_provider.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/theme_card_settings/add_theme_card_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../constants/app_routes.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/theme_card_with_detail_builder.dart';
import 'edit_theme_card_screen.dart';

class ThemeCardSettingsScreen extends StatelessWidget {
  const ThemeCardSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'テーマカード管理',
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: AppRoute.addThemeCard.name),
          screen: const AddThemeCardScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ),
        foregroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: const _ThemeCardListView(),
    );
  }
}

class _ThemeCardListView extends ConsumerWidget {
  const _ThemeCardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 3.5;
    final cards = ref.watch(themeCardsProvider);

    return ListView(
      children: [
        for (var card in cards)
          TextButton(
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.editThemeCard.name),
                screen: EditThemeCardScreen(card),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: SizedBox(
              height: height,
              child: ThemeCardWithDetailBuilder(card: card),
            ),
          ),
      ],
    );
  }
}
