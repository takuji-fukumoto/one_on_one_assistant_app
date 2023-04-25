import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../domain/models/support_card.dart';

class SupportCardBuilder extends StatelessWidget {
  final SupportCard card;
  const SupportCardBuilder({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        speed: 400,
        front: Container(
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
              const Expanded(
                child: _TapToFlipText(),
              ),
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
            ],
          ),
        ),
        back: Container(
          padding: const EdgeInsets.all(Sizes.p12),
          decoration: const BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const _TapToFlipText(),
              gapH12,
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
      ),
    );
  }
}

class _TapToFlipText extends StatelessWidget {
  const _TapToFlipText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(
          Icons.compare_arrows,
          size: 18,
          color: Colors.black38,
        ),
        gapW8,
        AutoSizeText(
          'タップして反転',
          minFontSize: Sizes.p4,
          style: TextStyle(fontSize: Sizes.p12, color: Colors.black38),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ],
    );
  }
}
