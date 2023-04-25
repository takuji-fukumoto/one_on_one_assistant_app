import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../domain/models/theme_card.dart';

class ThemeCardWithDetailBuilder extends StatelessWidget {
  final ThemeCard card;
  const ThemeCardWithDetailBuilder({Key? key, required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.all(Sizes.p12),
        decoration: const BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                card.theme,
                minFontSize: Sizes.p8,
                style: const TextStyle(fontSize: Sizes.p20),
                maxLines: 2,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeText(
                      card.category,
                      style: const TextStyle(fontSize: Sizes.p16),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                  ),
                  Text('Level ${card.level.toString()}'),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  card.question,
                  minFontSize: Sizes.p8,
                  style: const TextStyle(fontSize: Sizes.p16),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ),
            gapH12,
            if (card.remarks != null && card.remarks!.isNotEmpty)
              Expanded(
                flex: 2,
                child: AutoSizeText(
                  card.remarks!,
                  minFontSize: Sizes.p8,
                  style: const TextStyle(fontSize: Sizes.p12),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
