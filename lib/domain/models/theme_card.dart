import 'package:objectbox/objectbox.dart';

@Entity()
class ThemeCard {
  @Id()
  int? id = 0;
  String theme = '';
  String category = '';
  String question = '';
  int level = 0;
  String? remarks = '';

  ThemeCard(
      {this.id,
      required this.theme,
      required this.category,
      required this.question,
      required this.level,
      this.remarks});

// @Property(type: PropertyType.date) // Store as int in milliseconds
  // DateTime? date;

  // @Transient() // Ignore this property, not stored in the database.
  // int? computedProperty;

  ThemeCard copyWith(
      {int? id,
      String? theme,
      String? category,
      String? question,
      int? level,
      String? remarks}) {
    return ThemeCard(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      category: category ?? this.category,
      question: question ?? this.question,
      level: level ?? this.level,
      remarks: remarks ?? this.remarks,
    );
  }
}
