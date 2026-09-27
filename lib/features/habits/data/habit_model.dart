import 'package:hive/hive.dart';
import '../domain/habit_entity.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String iconName;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final int streak;

  @HiveField(5)
  final List<String> completedDates;

  HabitModel({
    required this.id,
    required this.title,
    required this.iconName,
    required this.colorValue,
    required this.streak,
    required this.completedDates,
  });

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      iconName: entity.iconName,
      colorValue: entity.colorValue,
      streak: entity.streak,
      completedDates: List<String>.from(entity.completedDates),
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      iconName: iconName,
      colorValue: colorValue,
      streak: streak,
      completedDates: List<String>.from(completedDates),
    );
  }
}
