import 'package:objectbox/objectbox.dart';

@Entity()
class SupportCard {
  @Id()
  int? id = 0;
  String situation = '';
  String advice = '';
  int level = 0;
  String? remarks = '';

  SupportCard(
      {this.id,
      required this.situation,
      required this.advice,
      required this.level,
      this.remarks});

  SupportCard copyWith(
      {int? id,
      String? situation,
      String? advice,
      int? level,
      String? remarks}) {
    return SupportCard(
      id: id ?? this.id,
      situation: situation ?? this.situation,
      advice: advice ?? this.advice,
      level: level ?? this.level,
      remarks: remarks ?? this.remarks,
    );
  }
}
