import 'package:hive/hive.dart';
import '../domain/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int dueDateMillis;

  @HiveField(4)
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDateMillis,
    required this.isCompleted,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDateMillis: entity.dueDate.millisecondsSinceEpoch,
      isCompleted: entity.isCompleted,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: DateTime.fromMillisecondsSinceEpoch(dueDateMillis),
      isCompleted: isCompleted,
    );
  }
}
