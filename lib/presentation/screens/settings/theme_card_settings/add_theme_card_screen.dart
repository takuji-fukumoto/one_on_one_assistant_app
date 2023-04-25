import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/theme_card_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../domain/models/theme_card.dart';
import '../../../../domain/providers/theme_cards_provider.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/input_number_field.dart';
import '../../../common_widgets/input_text_field.dart';

final _editedThemeCardProvider = StateProvider.autoDispose<ThemeCard>((ref) {
  return ThemeCard(
    theme: '',
    category: '',
    question: '',
    level: 1,
  );
});

class AddThemeCardScreen extends ConsumerWidget {
  const AddThemeCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      'theme': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(30),
        ],
      ),
      'category': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(20),
        ],
      ),
      'question': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(30),
        ],
      ),
      'level': FormControl<int>(
        value: 1,
        validators: [
          Validators.required,
          Validators.number,
        ],
      ),
      'remarks': FormControl<String>(
        validators: [
          Validators.maxLength(100),
        ],
      ),
    });
    return BaseScreen(
      appBarTitle: 'テーマカード追加',
      body: Column(
        children: [
          gapH8,
          const _ThemeCardView(),
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
                          _applyCardView(ref, form);
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
                          _applyCardView(ref, form);
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
                          _applyCardView(ref, form);
                        },
                      ),
                      gapH20,
                      InputNumberField(
                        controlName: 'level',
                        fieldName: 'レベル',
                        minValue: 1,
                        maxValue: 5,
                        onChanged: (_) {
                          _applyCardView(ref, form);
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
                          _applyCardView(ref, form);
                        },
                      ),
                      gapH16,
                      BaseButton(
                        onPressed: () async {
                          if (form.invalid) {
                            form.markAllAsTouched();
                            return;
                          }

                          await ref
                              .read(themeCardsProvider.notifier)
                              .addCard(ThemeCard(
                                theme: form.control('theme').value,
                                category: form.control('category').value,
                                question: form.control('question').value,
                                level: form.control('level').value,
                                remarks: form.control('remarks').value,
                              ))
                              .then((value) {
                            Navigator.of(context).pop();
                            Flushbar(
                              message: "テーマカードを追加しました",
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(16),
                              borderRadius: BorderRadius.circular(8),
                            ).show(context);
                          });
                        },
                        child: const Text(
                          '追加',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      gapH16,
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

  void _applyCardView(WidgetRef ref, FormGroup form) {
    ref.read(_editedThemeCardProvider.notifier).state = ThemeCard(
      theme: form.control('theme').value ?? '',
      category: form.control('category').value ?? '',
      question: form.control('question').value ?? '',
      level: form.control('level').value ?? 1,
      remarks: form.control('remarks').value ?? '',
    );
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
  const _ThemeCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width * (8.0 / 10.0);
    final height = width * (3.0 / 4.0);
    final card = ref.watch(_editedThemeCardProvider);
    return SizedBox(
      width: width,
      height: height,
      child: ThemeCardBuilder(card: card),
    );
  }
}
