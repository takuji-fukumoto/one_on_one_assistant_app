import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_on_one_assistant_app/constants/app_sizes.dart';
import 'package:one_on_one_assistant_app/domain/usecases/fetch_talk_usecase.dart';
import 'package:one_on_one_assistant_app/domain/usecases/update_talk_detail_usecase.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/async_value_widget.dart';
import 'package:one_on_one_assistant_app/presentation/common_widgets/theme_card_builder.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../domain/models/session.dart';
import '../../../domain/models/talk.dart';
import '../../common_widgets/base_button.dart';
import '../../common_widgets/base_screen.dart';
import '../../common_widgets/input_text_field.dart';
import '../../common_widgets/support_card_builder.dart';

class TalkDetail extends ConsumerWidget {
  final int talkId;
  const TalkDetail({Key? key, required this.talkId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScreen(
      appBarTitle: 'トーク詳細',
      body: AsyncValueWidget(
        asyncValue: ref.watch(fetchTalkUseCaseProvider(talkId)),
        data: (talk) {
          if (talk == null) {
            return const Center(child: Text('トークが見つかりませんでした'));
          }

          return Column(
            children: [
              _Description(talk: talk),
              gapH8,
              const Text('使用したテーマ・サポートカード'),
              Expanded(
                child: _SessionListView(sessions: talk.sessions),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Description extends ConsumerWidget {
  final Talk talk;
  const _Description({Key? key, required this.talk}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = FormGroup({
      'memo': FormControl<String>(
        value: talk.memo,
        validators: [
          Validators.maxLength(100),
        ],
      ),
    });
    final DateFormat outputFormat = DateFormat('Hm');
    var startAt = outputFormat.format(talk.createdAt!);
    var endAt = outputFormat.format(talk.sessions.last.createdAt!);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          gapH12,
          Text('実施時間： $startAt ~ $endAt'),
          gapH12,
          ReactiveForm(
            formGroup: form,
            child: Column(
              children: <Widget>[
                InputTextField(
                  controlName: 'memo',
                  validationMessages: {
                    'maxLength': (error) => '100文字以内で入力してください'
                  },
                  fieldName: 'MEMO',
                  maxLines: 3,
                ),
                gapH8,
                BaseButton(
                  onPressed: () async {
                    if (form.invalid) {
                      form.markAllAsTouched();
                      return;
                    }

                    await ref
                        .read(updateTalkDetailUseCaseProvider)
                        .execute(talk.user.target!,
                            talk.copyWith(memo: form.control('memo').value))
                        .then((value) {
                      Navigator.of(context).pop();
                      Flushbar(
                        message: "トーク情報を更新しました",
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(8),
                      ).show(context);
                    });
                  },
                  child: const Text(
                    '更新',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionListView extends ConsumerWidget {
  final List<Session> sessions;
  const _SessionListView({Key? key, required this.sessions}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sessions.isEmpty) {
      return const Center(child: Text('セッションはありません'));
    }
    final DateFormat outputFormat = DateFormat('yyyy-MM-dd H:m');
    final size = MediaQuery.of(context).size;
    final width = size.width / 1.6;
    final height = width * 3 / 4;
    return ListView(
      children: [
        for (var session in sessions)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH8,
                  Container(
                    padding: const EdgeInsets.only(left: Sizes.p8),
                    child: Text(outputFormat.format(session.createdAt!)),
                  ),
                  SizedBox(
                    height: height,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (session.usedThemeCard.target != null)
                          SizedBox(
                            width: width,
                            height: height,
                            child: ThemeCardBuilder(
                                card: session.usedThemeCard.target!),
                          ),
                        for (var supportCard in session.usedSupportCards)
                          SizedBox(
                            width: width,
                            height: height,
                            child: SupportCardBuilder(card: supportCard),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
