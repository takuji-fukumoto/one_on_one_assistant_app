import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../domain/models/user.dart';
import '../../../../domain/providers/users_provider.dart';
import '../../../common_widgets/base_button.dart';
import '../../../common_widgets/base_screen.dart';
import '../../../common_widgets/input_text_field.dart';

class AddUserScreen extends ConsumerWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      'name': FormControl<String>(validators: [
        Validators.required,
        Validators.maxLength(10),
      ]),
      'team': FormControl<String>(validators: [
        Validators.required,
        Validators.maxLength(20),
      ]),
    });
    return BaseScreen(
      appBarTitle: 'ユーザー追加',
      body: ReactiveForm(
        formGroup: form,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                gapH32,
                const Icon(Icons.account_circle_outlined, size: 100.0),
                InputTextField(
                  controlName: 'name',
                  validationMessages: {
                    'required': (error) => '必須項目です',
                    'maxLength': (error) => '10文字以内で入力してください'
                  },
                  fieldName: 'ユーザー名',
                  hintText: '1on1太郎',
                ),
                gapH20,
                InputTextField(
                  controlName: 'team',
                  validationMessages: {
                    'required': (error) => '必須項目です',
                    'maxLength': (error) => '20文字以内で入力してください'
                  },
                  fieldName: '所属部署',
                  hintText: '第3開発部',
                ),
                gapH20,
                BaseButton(
                  onPressed: () async {
                    if (form.invalid) {
                      form.markAllAsTouched();
                      return;
                    }
                    ref
                        .read(usersProvider.notifier)
                        .addUser(User(
                          name: form.control('name').value,
                          team: form.control('team').value,
                        ))
                        .then((value) {
                      Navigator.of(context).pop();
                      Flushbar(
                        message: "ユーザーを追加しました",
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(8),
                      ).show(context);
                    });
                  },
                  child: const Text(
                    '登録',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
