import 'package:objectbox/objectbox.dart';
import 'package:one_on_one_assistant_app/domain/models/support_card.dart';
import 'package:one_on_one_assistant_app/domain/models/talk.dart';
import 'package:one_on_one_assistant_app/domain/models/theme_card.dart';

@Entity()
class Session {
  @Id()
  int? id = 0;
  @Property(type: PropertyType.date)
  DateTime? createdAt;

  final talk = ToOne<Talk>();
  final usedThemeCard = ToOne<ThemeCard>();
  final usedSupportCards = ToMany<SupportCard>();

  Session({
    this.id,
    this.createdAt,
  });

  Session copyWith({
    int? id,
    DateTime? createdAt,
    Talk? talk,
    ThemeCard? usedThemeCard,
    List<SupportCard>? usedSupportCards,
  }) {
    var session = Session(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
    if (talk != null) {
      session.talk.target = talk;
    } else {
      session.talk.target = this.talk as Talk?;
    }
    if (usedThemeCard != null) {
      session.usedThemeCard.target = usedThemeCard;
    } else {
      session.usedThemeCard.target = this.usedThemeCard as ThemeCard?;
    }
    if (usedSupportCards != null) {
      session.usedSupportCards.addAll(usedSupportCards);
    } else {
      session.usedSupportCards.addAll(this.usedSupportCards);
    }

    return session;
  }

  void addThemeCard(ThemeCard card) {
    usedThemeCard.target = card;
  }

  void addSupportCard(SupportCard card) {
    usedSupportCards.add(card);
  }
}
