import 'package:flutter/material.dart';
import 'package:one_on_one_assistant_app/constants/app_sizes.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InputTextField extends StatelessWidget {
  final String controlName;
  final String fieldName;
  final Map<String, String Function(Object)>? validationMessages;
  final String? hintText;
  final int? maxLines;
  final Function(FormControl<dynamic>)? onChanged;

  const InputTextField({
    Key? key,
    required this.controlName,
    required this.fieldName,
    this.validationMessages,
    this.hintText,
    this.maxLines,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(fieldName),
        gapH4,
        ReactiveTextField(
          formControlName: controlName,
          validationMessages: validationMessages,
          maxLines: maxLines,
          cursorColor: Colors.black54,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p8,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
