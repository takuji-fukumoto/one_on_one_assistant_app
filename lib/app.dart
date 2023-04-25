import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_on_one_assistant_app/presentation/screens/settings/settings_screen.dart';
import 'package:one_on_one_assistant_app/presentation/screens/talks/talks_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'constants/app_colors.dart';
import 'constants/app_sizes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: '1on1 assistant app',
      theme: ThemeData(
        primarySwatch: AppColors.white,
        scaffoldBackgroundColor: Colors.white,
        cardColor: AppColors.lightGray,
        textTheme: GoogleFonts.notoSansJavaneseTextTheme(textTheme).copyWith(
          headline1: const TextStyle(
            fontSize: Sizes.p32,
            fontWeight: FontWeight.w500,
          ),
          headline2: const TextStyle(
            fontSize: Sizes.p24,
            fontWeight: FontWeight.w500,
          ),
          headline3: const TextStyle(
            fontSize: Sizes.p20,
            fontWeight: FontWeight.w500,
          ),
          headline4: const TextStyle(
            fontSize: Sizes.p32,
            fontWeight: FontWeight.w500,
          ),
          headline5: const TextStyle(
            fontSize: Sizes.p24,
            fontWeight: FontWeight.w500,
          ),
          headline6: const TextStyle(
            fontSize: Sizes.p20,
            fontWeight: FontWeight.w500,
          ),
          subtitle1: const TextStyle(
            fontSize: Sizes.p16,
            fontWeight: FontWeight.w400,
          ),
          subtitle2: const TextStyle(
            fontSize: Sizes.p16,
            fontWeight: FontWeight.w400,
          ),
          bodyText1: const TextStyle(
            fontSize: Sizes.p12,
            fontWeight: FontWeight.w400,
          ),
          bodyText2: const TextStyle(
            fontSize: Sizes.p12,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
      home: _BaseScreen(),
    );
  }
}

class _BaseScreen extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        border: Border.all(color: Colors.black54, width: 0.5),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> _buildScreens() {
    return const [
      TalksScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat_bubble),
        title: "トーク",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: "設定",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
