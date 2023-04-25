import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/constants/app_sizes.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common_widgets/input_text_field.dart';

final editedMemoProvider = StateProvider<String>((ref) => '');

class MemoSection extends ConsumerWidget {
  const MemoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      'memo': FormControl<String>(
        value: ref.read(editedMemoProvider),
        validators: [
          Validators.maxLength(300),
        ],
      ),
    });
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: Sizes.p8, horizontal: Sizes.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH48,
          Expanded(
            child: ReactiveForm(
              formGroup: form,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      gapH8,
                      InputTextField(
                        controlName: 'memo',
                        validationMessages: {
                          'maxLength': (error) => '300文字以内で入力してください'
                        },
                        maxLines: 10,
                        fieldName: 'トークメモ',
                        onChanged: (_) {
                          ref.read(editedMemoProvider.notifier).state =
                              form.control('memo').value ?? '';
                        },
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
}
