import 'package:objectbox/objectbox.dart';
import 'package:one_on_one_assistant_app/domain/models/talk.dart';

@Entity()
class User {
  @Id()
  int? id = 0;
  String name = '';
  String team = '';

  User({required this.name, required this.team, this.id});

  @Backlink('user')
  final talks = ToMany<Talk>();

  User copyWith({int? id, String? name, String? team}) {
    var newUser = User(
      id: id ?? this.id,
      name: name ?? this.name,
      team: team ?? this.team,
    );
    newUser.talks.addAll(talks);
    return newUser;
  }

  DateTime? get lastTalkDate {
    return talks.isNotEmpty ? talks.last.createdAt : null;
  }
}
