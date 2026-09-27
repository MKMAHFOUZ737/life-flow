import 'package:flutter/material.dart';
import 'package:lifeflow/core/constants/app_colors.dart';
import '../../features/tasks/presentation/screens/task_screen.dart';
import '../../features/habits/presentation/screens/habits_screen.dart';
import '../../features/focus_timer/presentation/screens/focus_timer_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';

class HomeNavigationShell extends StatefulWidget {
  const HomeNavigationShell({super.key});

  @override
  State<HomeNavigationShell> createState() => _HomeNavigationShellState();
}

class _HomeNavigationShellState extends State<HomeNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TaskScreen(),
    HabitsScreen(),
    FocusTimerScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.ruledLine, width: 1)),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.paperCard,
          indicatorColor: AppColors.innerBorder,
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.checklist_rounded, color: AppColors.mutedText),
              selectedIcon:
                  Icon(Icons.checklist_rounded, color: AppColors.mochaText),
              label: 'Checklist',
            ),
            NavigationDestination(
              icon: Icon(Icons.eco_outlined, color: AppColors.mutedText),
              selectedIcon: Icon(Icons.eco_rounded, color: AppColors.mochaText),
              label: 'Habits',
            ),
            NavigationDestination(
              icon: Icon(Icons.hourglass_empty_rounded,
                  color: AppColors.mutedText),
              selectedIcon: Icon(Icons.hourglass_full_rounded,
                  color: AppColors.mochaText),
              label: 'Focus',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined,
                  color: AppColors.mutedText),
              selectedIcon: Icon(Icons.calendar_today_rounded,
                  color: AppColors.mochaText),
              label: 'Calendar',
            ),
          ],
        ),
      ),
    );
  }
}
