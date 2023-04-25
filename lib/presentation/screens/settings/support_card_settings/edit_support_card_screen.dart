import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../domain/providers/support_cards_provider.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/input_number_field.dart';
import '../../../common_widgets/input_text_field.dart';
import '../../../common_widgets/support_card_builder.dart';

class EditSupportCardScreen extends ConsumerStatefulWidget {
  final SupportCard card;
  const EditSupportCardScreen(this.card, {Key? key}) : super(key: key);

  @override
  ConsumerState<EditSupportCardScreen> createState() =>
      _EditSupportCardScreenState();
}

class _EditSupportCardScreenState extends ConsumerState<EditSupportCardScreen> {
  late final FormGroup form;
  late SupportCard editedCard;

  @override
  void initState() {
    super.initState();
    editedCard = widget.card;
    form = FormGroup({
      'situation': FormControl<String>(
        value: widget.card.situation,
        validators: [
          Validators.required,
          Validators.maxLength(30),
        ],
      ),
      'advice': FormControl<String>(
        value: widget.card.advice,
        validators: [
          Validators.required,
          Validators.maxLength(50),
        ],
      ),
      'level': FormControl<int>(
        value: widget.card.level,
        validators: [
          Validators.required,
          Validators.number,
        ],
      ),
      'remarks': FormControl<String>(
        value: widget.card.remarks,
        validators: [
          Validators.maxLength(100),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBarTitle: 'サポートカード編集',
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Dialogs.bottomMaterialDialog(
              msg: 'サポートカードを削除しますか？',
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
                        .removeCard(widget.card.id!)
                        .then((value) {
                      Navigator.of(context).popUntil((route) {
                        return route.settings.name ==
                            AppRoute.supportCardSettings.name;
                      });
                      Flushbar(
                        message: "サポートカードを削除しました",
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
            //
            // ref.read(supportCardsProvider.notifier).removeCard(widget.card.id!);
            // Navigator.of(context).pop();
            // Flushbar(
            //   message: "サポートカードを削除しました",
            //   duration: const Duration(seconds: 2),
            //   margin: const EdgeInsets.all(16),
            //   borderRadius: BorderRadius.circular(8),
            // ).show(context);
          },
        ),
      ],
      body: Column(
        children: [
          gapH8,
          _SupportCardView(card: editedCard),
          gapH8,
          const _FieldLine(),
          Expanded(
            child: ReactiveForm(
              formGroup: form,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      gapH8,
                      InputTextField(
                        controlName: 'situation',
                        validationMessages: {
                          'required': (error) => '必須項目です',
                          'maxLength': (error) => '30文字以内で入力してください'
                        },
                        fieldName: 'ケース',
                        maxLines: 2,
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      InputTextField(
                        controlName: 'advice',
                        validationMessages: {
                          'required': (error) => '必須項目です',
                          'maxLength': (error) => '30文字以内で入力してください'
                        },
                        fieldName: '助言',
                        maxLines: 2,
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      InputNumberField(
                        controlName: 'level',
                        fieldName: 'レベル',
                        minValue: 1,
                        maxValue: 5,
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      InputTextField(
                        controlName: 'remarks',
                        validationMessages: {
                          'maxLength': (error) => '100文字以内で入力してください'
                        },
                        fieldName: '補足',
                        maxLines: 3,
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      BaseButton(
                        onPressed: () async {
                          if (form.invalid) {
                            form.markAllAsTouched();
                            return;
                          }

                          await ref
                              .read(supportCardsProvider.notifier)
                              .updateCard(widget.card.copyWith(
                                situation: form.control('situation').value,
                                advice: form.control('advice').value,
                                level: form.control('level').value,
                              ))
                              .then((value) {
                            Navigator.of(context).pop();
                            Flushbar(
                              message: "サポートカードを更新しました",
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(8),
                            ).show(context);
                          });
                        },
                        child: const Text(
                          '更新',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyCardView() {
    setState(() {
      editedCard = SupportCard(
        situation: form.control('situation').value ?? '',
        advice: form.control('advice').value ?? '',
        level: form.control('level').value ?? 1,
        remarks: form.control('remarks').value ?? '',
      );
    });
  }
}

class _FieldLine extends StatelessWidget {
  const _FieldLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}

class _SupportCardView extends ConsumerWidget {
  final SupportCard card;
  const _SupportCardView({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width * (8.0 / 10.0);
    final height = width * (3.0 / 4.0);
    return SizedBox(
      width: width,
      height: height,
      child: SupportCardBuilder(card: card),
    );
  }
}

// class EditSupportCardScreen extends ConsumerWidget {
// final SupportCard card;
// const EditSupportCardScreen(this.card, {Key? key}) : super(key: key);
//
// @override
// Widget build(BuildContext context, WidgetRef ref) {
//
// return BaseScreen(
// appBarTitle: 'サポートカード編集',
// actions: [
// IconButton(
// icon: const Icon(Icons.delete),
// onPressed: () {
// ref.read(supportCardsProvider.notifier).removeCard(card.id!);
// Navigator.of(context).pop();
// Flushbar(
// message: "サポートカードを削除しました",
// duration: const Duration(seconds: 2),
// margin: const EdgeInsets.all(16),
// borderRadius: BorderRadius.circular(8),
// ).show(context);
// },
// ),
// ],
// body: ReactiveForm(
// formGroup: form,
// child: Container(
// padding: const EdgeInsets.symmetric(horizontal: 20.0),
// child: SingleChildScrollView(
// child: Column(
// children: <Widget>[
// gapH32,
// // TODO: カードの画像に直接入力された文字が入るようにする
// const Icon(Icons.article_rounded, size: 100.0),
// InputTextField(
// controlName: 'situation',
// validationMessages: {
// 'required': (error) => '必須項目です',
// 'maxLength': (error) => '30文字以内で入力してください'
// },
// fieldName: 'ケース',
// maxLines: 2,
// ),
// gapH20,
// InputTextField(
// controlName: 'advice',
// validationMessages: {
// 'required': (error) => '必須項目です',
// 'maxLength': (error) => '30文字以内で入力してください'
// },
// fieldName: '助言',
// maxLines: 2,
// ),
// gapH20,
// const InputNumberField(
// controlName: 'level',
// fieldName: 'レベル',
// minValue: 1,
// maxValue: 5,
// ),
// gapH20,
// InputTextField(
// controlName: 'remarks',
// validationMessages: {
// 'maxLength': (error) => '100文字以内で入力してください'
// },
// fieldName: '補足',
// maxLines: 3,
// ),
// gapH20,
// BaseButton(
// onPressed: () async {
// if (form.invalid) {
// form.markAllAsTouched();
// return;
// }
//
// await ref
//     .read(supportCardsProvider.notifier)
//     .updateCard(card.copyWith(
// situation: form.control('situation').value,
// advice: form.control('advice').value,
// level: form.control('level').value,
// ))
//     .then((value) {
// Navigator.of(context).pop();
// Flushbar(
// message: "サポートカードを更新しました",
// duration: const Duration(seconds: 2),
// margin: const EdgeInsets.all(16),
// borderRadius: BorderRadius.circular(8),
// ).show(context);
// });
// },
// child: const Text(
// '更新',
// style: TextStyle(color: Colors.blue),
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// );
// }
// }
