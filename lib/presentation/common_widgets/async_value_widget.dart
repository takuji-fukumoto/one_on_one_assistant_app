import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {Key? key,
      required this.asyncValue,
      required this.data,
      this.loadingWidget,
      this.errorWidget})
      : super(key: key);

  final AsyncValue<T> asyncValue;
  final Widget Function(T) data;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      error: (err, stack) {
        //TODO: エラーポップアップ実装
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //  loadingErrorDialog(context, onPressed: () {
        //       Navigator.pop(context);
        //     }, error: err, stackTrace: stack);
        //   });
        return errorWidget ?? const SizedBox();
      },
      loading: () =>
          loadingWidget ??
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.grey,
              size: 50,
            ),
          ),
    );
  }
}
