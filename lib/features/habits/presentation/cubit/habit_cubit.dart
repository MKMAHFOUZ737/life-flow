import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/habit_entity.dart';
import '../../data/habit_model.dart';

abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<HabitEntity> habits;
  HabitLoaded(this.habits);
}

class HabitCubit extends Cubit<HabitState> {
  final Box<HabitModel> _habitBox;

  HabitCubit(this._habitBox) : super(HabitInitial());

  void loadHabits() {
    emit(HabitLoading());
    final habits = _habitBox.values.map((e) => e.toEntity()).toList();
    emit(HabitLoaded(habits));
  }

  Future<void> addHabit(HabitEntity habit) async {
    final model = HabitModel.fromEntity(habit);
    await _habitBox.put(habit.id, model);
    loadHabits();
  }

  Future<void> toggleToday(HabitEntity habit) async {
    final now = DateTime.now();
    final todayKey =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final updatedDates = List<String>.from(habit.completedDates);

    int newStreak = habit.streak;
    if (updatedDates.contains(todayKey)) {
      updatedDates.remove(todayKey);
      newStreak = (newStreak > 0) ? newStreak - 1 : 0;
    } else {
      updatedDates.add(todayKey);
      newStreak += 1;
    }

    final updatedHabit = habit.copyWith(
      completedDates: updatedDates,
      streak: newStreak,
    );

    await _habitBox.put(updatedHabit.id, HabitModel.fromEntity(updatedHabit));
    loadHabits();
  }

  Future<void> deleteHabit(String id) async {
    await _habitBox.delete(id);
    loadHabits();
  }
}
