import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/domain/providers/support_cards_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../domain/models/support_card.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/input_number_field.dart';
import '../../../common_widgets/input_text_field.dart';
import '../../../common_widgets/support_card_builder.dart';

final _editedSupportCardProvider =
    StateProvider.autoDispose<SupportCard>((ref) {
  return SupportCard(
    level: 1,
    situation: '',
    advice: '',
    remarks: '',
  );
});

class AddSupportCardScreen extends ConsumerWidget {
  const AddSupportCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      'situation': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(30),
        ],
      ),
      'advice': FormControl<String>(
        validators: [
          Validators.required,
          Validators.maxLength(50),
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
      appBarTitle: 'サポートカード追加',
      body: Column(
        children: [
          gapH8,
          const _SupportCardView(),
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
                        onChanged: (_) {
                          _applyCardView(ref, form);
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
                      gapH20,
                      BaseButton(
                        onPressed: () async {
                          if (form.invalid) {
                            form.markAllAsTouched();
                            return;
                          }

                          await ref
                              .read(supportCardsProvider.notifier)
                              .addCard(SupportCard(
                                situation: form.control('situation').value,
                                advice: form.control('advice').value,
                                level: form.control('level').value,
                              ))
                              .then((value) {
                            Navigator.of(context).pop();
                            Flushbar(
                              message: "サポートカードを追加しました",
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
    ref.read(_editedSupportCardProvider.notifier).state = SupportCard(
      situation: form.control('situation').value ?? '',
      advice: form.control('advice').value ?? '',
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

class _SupportCardView extends ConsumerWidget {
  const _SupportCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width * (8.0 / 10.0);
    final height = width * (3.0 / 4.0);
    final card = ref.watch(_editedSupportCardProvider);
    return SizedBox(
      width: width,
      height: height,
      child: SupportCardBuilder(card: card),
    );
  }
}
