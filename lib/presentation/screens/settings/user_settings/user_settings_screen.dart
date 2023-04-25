import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/users_provider.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/user_settings/add_user_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../constants/app_routes.dart';
import '../../../common_widgets/base_screen.dart';
import 'edit_user_screen.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'ユーザー管理',
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: AppRoute.addUser.name),
          screen: const AddUserScreen(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        ),
        foregroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: const _UserListView(),
    );
  }
}

class _UserListView extends ConsumerWidget {
  const _UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(usersProvider);
    return ListView(
      children: [
        for (var user in userProvider)
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle_outlined, size: 40),
              title: Text(user.name),
              subtitle: Text(user.team),
              onTap: () => pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: AppRoute.editUser.name),
                screen: EditUserScreen(user),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              ),
            ),
          ),
      ],
    );
  }
}
