import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifeflow/core/constants/app_colors.dart';
import 'package:uuid/uuid.dart';
import '../../domain/habit_entity.dart';
import '../cubit/habit_cubit.dart';
import '../widgets/habit_card.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  // Earthy, warm boho palette presets
  static const List<Color> _presetColors = [
    Color(0xFF6B4E3D), // Deep Mocha
    Color(0xFFBF9C7D), // Warm Tan
    Color(0xFF8F9E82), // Sage Green
    Color(0xFFDF9B78), // Warm Peach
    Color(0xFF9E7777), // Rose Earth
  ];

  void _showAddHabitDialog(BuildContext context) {
    final titleController = TextEditingController();
    Color selectedColor = _presetColors.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.paperCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border:
                Border(top: BorderSide(color: AppColors.outerBorder, width: 2)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'NEW HABIT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: AppColors.mochaText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: true,
                style: const TextStyle(
                    color: AppColors.mochaText, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  hintText: 'e.g., Morning Pages, Herbal Tea...',
                  hintStyle: const TextStyle(color: AppColors.mutedText),
                  filled: true,
                  fillColor: AppColors.paperBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.ruledLine),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.ruledLine),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: AppColors.warmTanAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'ACCENT COLOR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _presetColors.map((color) {
                  final isSelected = selectedColor == color;
                  return GestureDetector(
                    onTap: () => setModalState(() => selectedColor = color),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppColors.mochaText, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mochaText,
                  foregroundColor: AppColors.paperBg,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    final habit = HabitEntity(
                      id: const Uuid().v4(),
                      title: titleController.text.trim(),
                      iconName: 'spa',
                      colorValue: selectedColor.toARGB32(),
                    );
                    context.read<HabitCubit>().addHabit(habit);
                    Navigator.pop(modalCtx);
                  }
                },
                child: const Text('Add Habit',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperBg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.outerBorder,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withAlpha(25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.paperCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.innerBorder, width: 1.5),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'DAILY HABITS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: AppColors.mochaText,
                      ),
                    ),
                    const Text(
                      'RHYTHM & STREAKS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: BlocBuilder<HabitCubit, HabitState>(
                        builder: (context, state) {
                          final habits = state is HabitLoaded
                              ? state.habits
                              : <HabitEntity>[];

                          if (habits.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.spa_outlined,
                                      size: 48, color: AppColors.mutedText),
                                  SizedBox(height: 12),
                                  Text(
                                    'No rituals tracked yet.\nTap below to cultivate one.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.mutedText,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              return HabitCard(
                                habit: habit,
                                onToggle: () => context
                                    .read<HabitCubit>()
                                    .toggleToday(habit),
                                onDelete: () => context
                                    .read<HabitCubit>()
                                    .deleteHabit(habit.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mochaText,
        foregroundColor: AppColors.paperBg,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
