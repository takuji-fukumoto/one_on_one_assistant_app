import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:one_on_one_assistant_app/domain/providers/support_cards_provider.dart';
import 'package:one_on_one_assistant_app/domain/providers/theme_cards_provider.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/support_card_settings/support_card_settings_screen.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/theme_card_settings/theme_card_settings_screen.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/user_settings/user_settings_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/app_sizes.dart';
import '../../common_widgets/base_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScreen(
      leading: Container(
        padding: const EdgeInsets.only(left: Sizes.p16),
        child: Text(
          '設定',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      leadingWidth: 150.0,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text('ユーザー管理'),
              onTap: () => pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.userSettings.name),
                screen: const UserSettingsScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Colors.amber,
              ),
              title: const Text('テーマカード管理'),
              onTap: () => pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.themeCardSettings.name),
                screen: const ThemeCardSettingsScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.article_rounded,
                color: Colors.green,
              ),
              title: const Text('サポートカード管理'),
              onTap: () => pushNewScreenWithRouteSettings(
                context,
                settings:
                    RouteSettings(name: AppRoute.supportCardSettings.name),
                screen: const SupportCardSettingsScreen(),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('テーマカードデータリセット'),
              onTap: () async {
                Dialogs.bottomMaterialDialog(
                  msg: 'テーマカードのデータをリセットしますか？\n初期のテーマカードのみ残ります',
                  context: context,
                  actions: [
                    IconsOutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: 'キャンセル',
                      iconData: Icons.cancel_outlined,
                      textStyle: const TextStyle(color: Colors.grey),
                      iconColor: Colors.grey,
                    ),
                    IconsButton(
                      onPressed: () async {
                        await ref
                            .read(themeCardsProvider.notifier)
                            .reset()
                            .then((value) {
                          Navigator.of(context).pop();
                          Flushbar(
                            message: "テーマカードのデータをリセットしました",
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(8),
                          ).show(context);
                        });
                      },
                      text: '削除',
                      iconData: Icons.delete,
                      color: Colors.red,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('サポートカードデータリセット'),
              onTap: () async {
                Dialogs.bottomMaterialDialog(
                  msg: 'サポートカードのデータをリセットしますか？\n初期のサポートカードのみ残ります',
                  context: context,
                  actions: [
                    IconsOutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: 'キャンセル',
                      iconData: Icons.cancel_outlined,
                      textStyle: const TextStyle(color: Colors.grey),
                      iconColor: Colors.grey,
                    ),
                    IconsButton(
                      onPressed: () async {
                        await ref
                            .read(supportCardsProvider.notifier)
                            .reset()
                            .then((value) {
                          Navigator.of(context).pop();
                          Flushbar(
                            message: "サポートカードのデータをリセットしました",
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                            ),
                            duration: const Duration(seconds: 2),
                            margin: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(8),
                          ).show(context);
                        });
                      },
                      text: '削除',
                      iconData: Icons.delete,
                      color: Colors.red,
                      textStyle: const TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
