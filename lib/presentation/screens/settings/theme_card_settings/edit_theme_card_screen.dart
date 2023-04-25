import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../constants/app_routes.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../domain/providers/theme_cards_provider.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/input_number_field.dart';
import '../../../common_widgets/input_text_field.dart';
import '../../../common_widgets/theme_card_builder.dart';

class EditThemeCardScreen extends ConsumerStatefulWidget {
  final ThemeCard card;
  const EditThemeCardScreen(this.card, {Key? key}) : super(key: key);

  @override
  ConsumerState<EditThemeCardScreen> createState() =>
      _EditThemeCardScreenState();
}

class _EditThemeCardScreenState extends ConsumerState<EditThemeCardScreen> {
  late final FormGroup form;
  late ThemeCard editedCard;

  @override
  void initState() {
    super.initState();
    editedCard = widget.card;
    form = FormGroup({
      'theme': FormControl<String>(
        value: widget.card.theme,
        validators: [
          Validators.required,
          Validators.maxLength(30),
        ],
      ),
      'category': FormControl<String>(
        value: widget.card.category,
        validators: [
          Validators.required,
          Validators.maxLength(20),
        ],
      ),
      'question': FormControl<String>(
        value: widget.card.question,
        validators: [
          Validators.required,
          Validators.maxLength(30),
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
      appBarTitle: 'テーマカード編集',
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Dialogs.bottomMaterialDialog(
              msg: 'テーマカードを削除しますか？',
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
                        .removeCard(widget.card.id!)
                        .then((value) {
                      Navigator.of(context).popUntil((route) {
                        return route.settings.name ==
                            AppRoute.themeCardSettings.name;
                      });
                      Flushbar(
                        message: "テーマカードを削除しました",
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
      ],
      body: Column(
        children: [
          gapH8,
          _ThemeCardView(card: editedCard),
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
                        controlName: 'theme',
                        validationMessages: {
                          'required': (error) => '必須項目です',
                          'maxLength': (error) => '30文字以内で入力してください'
                        },
                        fieldName: 'テーマ',
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      InputTextField(
                        controlName: 'category',
                        validationMessages: {
                          'required': (error) => '必須項目です',
                          'maxLength': (error) => '20文字以内で入力してください'
                        },
                        fieldName: 'カテゴリー',
                        onChanged: (_) {
                          _applyCardView();
                        },
                      ),
                      gapH20,
                      InputTextField(
                        controlName: 'question',
                        validationMessages: {
                          'required': (error) => '必須項目です',
                          'maxLength': (error) => '30文字以内で入力してください'
                        },
                        fieldName: '質問内容',
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
                              .read(themeCardsProvider.notifier)
                              .updateCard(widget.card.copyWith(
                                theme: form.control('theme').value,
                                category: form.control('category').value,
                                question: form.control('question').value,
                                level: form.control('level').value,
                                remarks: form.control('remarks').value,
                              ))
                              .then((value) {
                            Navigator.of(context).pop();
                            Flushbar(
                              message: "テーマカードを更新しました",
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
      editedCard = ThemeCard(
        theme: form.control('theme').value ?? '',
        category: form.control('category').value ?? '',
        question: form.control('question').value ?? '',
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

class _ThemeCardView extends ConsumerWidget {
  final ThemeCard card;
  const _ThemeCardView({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width * (8.0 / 10.0);
    final height = width * (3.0 / 4.0);
    return SizedBox(
      width: width,
      height: height,
      child: ThemeCardBuilder(card: card),
    );
  }
}
