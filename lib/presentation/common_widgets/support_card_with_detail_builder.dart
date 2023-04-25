import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../domain/models/support_card.dart';

class SupportCardWithDetailBuilder extends StatelessWidget {
  final SupportCard card;
  const SupportCardWithDetailBuilder({Key? key, required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.all(Sizes.p12),
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AutoSizeText(
                card.situation,
                minFontSize: Sizes.p8,
                style: const TextStyle(fontSize: Sizes.p20),
                maxLines: 2,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Level ${card.level.toString()}'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: AutoSizeText(
                  card.advice,
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
                  minFontSize: Sizes.p4,
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
