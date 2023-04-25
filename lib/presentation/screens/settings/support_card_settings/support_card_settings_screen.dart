import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../constants/app_routes.dart';
import '../../../../domain/providers/support_cards_provider.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/support_card_with_detail_builder.dart';
import 'add_support_card_screen.dart';
import 'edit_support_card_screen.dart';

class SupportCardSettingsScreen extends StatelessWidget {
  const SupportCardSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'サポートカード管理',
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: AppRoute.addSupportCard.name),
          screen: const AddSupportCardScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ),
        foregroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: const _SupportCardListView(),
    );
  }
}

class _SupportCardListView extends ConsumerWidget {
  const _SupportCardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 3.5;
    final cards = ref.watch(supportCardsProvider);

    return ListView(
      children: [
        for (var card in cards)
          TextButton(
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.editSupportCard.name),
                screen: EditSupportCardScreen(card),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: SizedBox(
              height: height,
              child: SupportCardWithDetailBuilder(card: card),
            ),
          ),
      ],
    );
  }
}
