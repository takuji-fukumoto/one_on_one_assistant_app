import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String? appBarTitle;
  final TextStyle? titleTextStyle;
  final Widget? body;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  const BaseScreen(
      {Key? key,
      this.appBarTitle,
      this.titleTextStyle,
      this.body,
      this.leading,
      this.leadingWidth,
      this.actions,
      this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle ?? '',
          style: titleTextStyle ?? Theme.of(context).textTheme.headline3,
        ),
        elevation: 1,
        shadowColor: Colors.black87,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: leading,
        leadingWidth: leadingWidth,
        actions: actions,
      ),
      body: body != null
          ? SafeArea(
              bottom: false,
              child: body!,
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
