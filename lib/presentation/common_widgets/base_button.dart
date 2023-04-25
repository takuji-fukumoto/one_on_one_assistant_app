import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onPressed;
  const BaseButton({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(
          color: AppColors.deepBlue,
          width: 0.5,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
