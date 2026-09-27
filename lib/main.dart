import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/themes/app_theme.dart';
import 'core/widgets/home_navigation_shell.dart';
import 'features/tasks/data/task_model.dart';
import 'features/tasks/presentation/cubit/task_cubit.dart';
import 'features/habits/data/habit_model.dart';
import 'features/habits/presentation/cubit/habit_cubit.dart';
import 'features/focus_timer/presentation/cubit/focus_timer_cubit.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(HabitModelAdapter());

  final taskBox = await Hive.openBox<TaskModel>('tasks_box');
  final habitBox = await Hive.openBox<HabitModel>('habits_box');
  await Hive.openBox('settings_box');

  await NotificationService.instance.initialize();

  runApp(LifeFlowApp(taskBox: taskBox, habitBox: habitBox));
}

class LifeFlowApp extends StatelessWidget {
  final Box<TaskModel> taskBox;
  final Box<HabitModel> habitBox;

  const LifeFlowApp({
    super.key,
    required this.taskBox,
    required this.habitBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TaskCubit(taskBox)..loadTasks(),
        ),
        BlocProvider(
          create: (_) => HabitCubit(habitBox)..loadHabits(),
        ),
        BlocProvider(
          create: (_) => FocusTimerCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'LifeFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeNavigationShell(),
      ),
    );
  }
}
