/// 一番下にテーマ、サポートのセグメント
/// 選択したセグメントのカード一覧をすぐ上にカルーセル形式で表示
/// その上にカードを出すスペースがある
/// スペースにはテーマ、サポートカードをそれぞれ一枚出せる（上書き可能）
/// トークを終える場合「終了」ボタン
/// そのまま次のテーマで話したい場合は「次のテーマ」ボタン
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/support_card_builder.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/theme_card_builder.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../domain/models/support_card.dart';
import '../../../../domain/models/theme_card.dart';

final selectedThemeCardProvider = StateProvider<ThemeCard?>((ref) => null);
final selectedSupportCardsProvider =
    StateProvider<List<SupportCard>>((ref) => []);

class SelectedCardField extends ConsumerWidget {
  const SelectedCardField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: const [
        gapH8,
        Expanded(child: _ThemeCardField()),
        gapH8,
        _FieldLine(),
        gapH8,
        Expanded(child: _SupportCardsField()),
        gapH8,
        _FieldLine(),
      ],
    );
  }
}

class _ThemeCardField extends ConsumerWidget {
  const _ThemeCardField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.6;
    final height = width * (3 / 4);
    final card = ref.watch(selectedThemeCardProvider);
    return DragTarget<ThemeCard>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Stack(
          children: [
            const Center(
              child: Text(
                'テーマカード',
                style: TextStyle(
                    fontSize: Sizes.p48,
                    color: Colors.black12,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                strokeWidth: 0.5,
                dashPattern: const [8, 4],
                radius: const Radius.circular(8),
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: card != null
                      ? ThemeCardBuilder(card: card)
                      : const _DrugAndDropText(),
                ),
              ),
            ),
          ],
        );
      },
      onAccept: (ThemeCard data) {
        ref.read(selectedThemeCardProvider.notifier).state = data;
      },
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

class _SupportCardsField extends ConsumerStatefulWidget {
  const _SupportCardsField({Key? key}) : super(key: key);

  @override
  ConsumerState<_SupportCardsField> createState() => _SupportCardsFieldState();
}

class _SupportCardsFieldState extends ConsumerState<_SupportCardsField> {
  List<Widget> rows = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width * 0.45;
    final height = width * (3 / 4);

    return DragTarget<SupportCard>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return Stack(
          children: [
            const Center(
              child: Text(
                'サポートカード',
                style: TextStyle(
                    fontSize: Sizes.p48,
                    color: Colors.black12,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Center(
              child: ReorderableWrap(
                footer: DottedBorder(
                  borderType: BorderType.RRect,
                  strokeWidth: 0.5,
                  dashPattern: const [8, 4],
                  radius: const Radius.circular(8),
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: const _DrugAndDropText(),
                  ),
                ),
                spacing: 8.0,
                runSpacing: 4.0,
                padding: const EdgeInsets.all(8),
                onReorder: _onReorder,
                children: rows,
              ),
            ),
          ],
        );
      },
      onAccept: (SupportCard data) {
        ref.read(selectedSupportCardsProvider.notifier).state.add(data);
        setState(() {
          rows.add(
            SizedBox(
              key: ValueKey(rows.length + 1),
              width: width,
              height: height,
              child: SupportCardBuilder(card: data),
            ),
          );
        });
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    var cards = ref.read(selectedSupportCardsProvider);
    var orderedCard = cards.removeAt(oldIndex);
    cards.insert(newIndex, orderedCard);
    ref.read(selectedSupportCardsProvider.notifier).state = cards;
    setState(() {
      var row = rows.removeAt(oldIndex);
      rows.insert(newIndex, row);
    });
  }
}

class _DrugAndDropText extends StatelessWidget {
  const _DrugAndDropText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'ドラッグ&ドロップで追加',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: Sizes.p12, color: Colors.black38),
    );
  }
}
