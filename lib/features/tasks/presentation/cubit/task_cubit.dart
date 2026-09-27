import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/task_entity.dart';
import '../../data/task_model.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  TaskLoaded(this.tasks);
}

class TaskCubit extends Cubit<TaskState> {
  final Box<TaskModel> _taskBox;

  TaskCubit(this._taskBox) : super(TaskInitial());

  void loadTasks() {
    emit(TaskLoading());
    final tasks = _taskBox.values.map((model) => model.toEntity()).toList();
    emit(TaskLoaded(tasks));
  }

  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _taskBox.put(task.id, model);
    await _taskBox.flush();
    loadTasks();
  }

  Future<void> toggleTask(TaskEntity task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _taskBox.put(updated.id, TaskModel.fromEntity(updated));
    await _taskBox.flush();
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
    await _taskBox.flush();
    loadTasks();
  }
}
