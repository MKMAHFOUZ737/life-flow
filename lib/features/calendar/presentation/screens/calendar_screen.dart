import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:lifeflow/features/tasks/domain/task_entity.dart';
import 'package:lifeflow/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:lifeflow/features/habits/domain/habit_entity.dart';
import 'package:lifeflow/features/habits/presentation/cubit/habit_cubit.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  String _dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  List<dynamic> _getEventsForDay(
    DateTime day,
    List<TaskEntity> tasks,
    List<HabitEntity> habits,
  ) {
    final String key = _dateKey(day);
    final dayTasks =
        tasks.where((task) => isSameDay(task.dueDate, day)).toList();
    final dayHabits =
        habits.where((habit) => habit.completedDates.contains(key)).toList();
    return [...dayTasks, ...dayHabits];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule & History'),
        centerTitle: true,
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, taskState) {
          return BlocBuilder<HabitCubit, HabitState>(
            builder: (context, habitState) {
              final tasks =
                  taskState is TaskLoaded ? taskState.tasks : <TaskEntity>[];
              final habits = habitState is HabitLoaded
                  ? habitState.habits
                  : <HabitEntity>[];

              final selectedTasks = tasks
                  .where((t) => isSameDay(t.dueDate, _selectedDay))
                  .toList();
              final String selKey = _dateKey(_selectedDay);

              return Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color ?? theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2035, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      eventLoader: (day) =>
                          _getEventsForDay(day, tasks, habits),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        formatButtonVisible: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        titleTextStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        markersMaxCount: 3,
                        markerDecoration: const BoxDecoration(
                          color: Color(0xFFFFB703),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          DateFormat.MMMMEEEEd().format(_selectedDay),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      children: [
                        if (selectedTasks.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(
                              'TASKS DUE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ...selectedTasks.map(
                            (task) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle_rounded
                                      : Icons.radio_button_unchecked,
                                  color: task.isCompleted
                                      ? theme.colorScheme.primary
                                      : Colors.grey,
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            'HABITS LOGGED',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ...habits.map((habit) {
                          final isDoneOnDate =
                              habit.completedDates.contains(selKey);
                          final habitColor = Color(habit.colorValue);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: habitColor.withAlpha(30),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_fire_department_rounded,
                                  color: habitColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                habit.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              trailing: isDoneOnDate
                                  ? const Icon(Icons.check_circle_rounded,
                                      color: Color(0xFF10B981))
                                  : const Icon(Icons.remove_circle_outline,
                                      color: Colors.grey),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
