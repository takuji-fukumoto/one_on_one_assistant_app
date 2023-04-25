import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/constants/app_sizes.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _inputNumberProvider = StateProvider.autoDispose<double>((ref) => 1.0);

class InputNumberField extends ConsumerWidget {
  final String controlName;
  final double minValue;
  final double maxValue;
  final String fieldName;
  final Function(FormControl<num>)? onChanged;

  const InputNumberField({
    Key? key,
    required this.controlName,
    required this.fieldName,
    required this.minValue,
    required this.maxValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(fieldName)),
            Text(ref.watch(_inputNumberProvider).toInt().toString()),
            gapW8,
          ],
        ),
        gapH4,
        ReactiveSlider(
          formControlName: controlName,
          min: minValue,
          max: maxValue,
          activeColor: Colors.blue,
          inactiveColor: Colors.black12,
          onChanged: (form) {
            ref.read(_inputNumberProvider.notifier).state =
                form.value?.toDouble() ?? 0.0;
            onChanged?.call(form);
          },
        ),
      ],
    );
  }
}
