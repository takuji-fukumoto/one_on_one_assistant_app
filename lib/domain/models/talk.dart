import 'package:objectbox/objectbox.dart';
import 'package:one_on_one_assistant_app/domain/models/session.dart';
import 'package:one_on_one_assistant_app/domain/models/user.dart';

@Entity()
class Talk {
  @Id()
  int? id = 0;
  @Property(type: PropertyType.date)
  DateTime? createdAt;
  String? memo;

  Talk({this.id, this.createdAt, this.memo});

  final user = ToOne<User>();

  @Backlink('talk')
  final sessions = ToMany<Session>();

  Talk copyWith({
    int? id,
    DateTime? createdAt,
    String? memo,
    List<Session>? sessions,
  }) {
    var talk = Talk(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      memo: memo ?? this.memo,
    );
    if (sessions != null) {
      talk.sessions.addAll(sessions);
    } else {
      talk.sessions.addAll(this.sessions);
    }

    return talk;
  }

  void addSession(Session session) {
    sessions.add(session);
  }
}
