import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:lifeflow/core/constants/app_colors.dart';
import 'package:lifeflow/features/tasks/domain/task_entity.dart';
import 'package:lifeflow/features/tasks/presentation/cubit/task_cubit.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Box? _settingsBox;
  late final TextEditingController _notesController;
  Timer? _debounceTimer;

  static const String _notesKey = 'daily_notes_content';

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _initNotesBox();
  }

  Future<void> _initNotesBox() async {
    // Open box safely if not already opened
    if (Hive.isBoxOpen('settings_box')) {
      _settingsBox = Hive.box('settings_box');
    } else {
      _settingsBox = await Hive.openBox('settings_box');
    }

    if (mounted && _settingsBox != null) {
      final savedNote =
          _settingsBox!.get(_notesKey, defaultValue: '') as String;
      _notesController.text = savedNote;
    }
  }

  void _onNotesChanged(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      if (_settingsBox != null) {
        await _settingsBox!.put(_notesKey, text);
        await _settingsBox!.flush();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _showAddTaskModal(BuildContext context) {
    final titleController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.paperCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border:
              Border(top: BorderSide(color: AppColors.outerBorder, width: 2)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'NEW TASK',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
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
                hintText: 'Write your task here...',
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
            const SizedBox(height: 16),
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
                  final task = TaskEntity(
                    id: const Uuid().v4(),
                    title: titleController.text.trim(),
                    dueDate: DateTime.now(),
                  );
                  context.read<TaskCubit>().addTask(task);
                  Navigator.pop(modalCtx);
                }
              },
              child: const Text('Add to List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
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
                    color: Colors.brown.withAlpha(30),
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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'TO DO LIST',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppColors.mochaText,
                          ),
                        ),
                        const Text(
                          'CHECKLIST',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                            color: AppColors.mochaText,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tasks Checklist
                        Expanded(
                          flex: 5,
                          child: BlocBuilder<TaskCubit, TaskState>(
                            builder: (context, state) {
                              final tasks = state is TaskLoaded
                                  ? state.tasks
                                  : <TaskEntity>[];

                              return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: tasks.length < 7 ? 7 : tasks.length,
                                itemBuilder: (context, index) {
                                  final task = index < tasks.length
                                      ? tasks[index]
                                      : null;

                                  return Container(
                                    height: 46,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.ruledLine,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: task != null
                                        ? Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => context
                                                    .read<TaskCubit>()
                                                    .toggleTask(task),
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: task.isCompleted
                                                        ? AppColors
                                                            .warmTanAccent
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                      color: AppColors
                                                          .warmTanAccent,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: task.isCompleted
                                                      ? const Icon(
                                                          Icons.check_rounded,
                                                          color: Colors.white,
                                                          size: 18,
                                                        )
                                                      : null,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: task.isCompleted
                                                        ? AppColors.mutedText
                                                        : AppColors.mochaText,
                                                    decoration: task.isCompleted
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                    decorationColor:
                                                        AppColors.warmTanAccent,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.close_rounded,
                                                  size: 18,
                                                  color: AppColors.mutedText,
                                                ),
                                                onPressed: () => context
                                                    .read<TaskCubit>()
                                                    .deleteTask(task.id),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: AppColors.ruledLine,
                                                    width: 1.8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // Editable & Persistent NOTES Section
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 70, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NOTES:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                    color: AppColors.mochaText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: TextField(
                                    controller: _notesController,
                                    onChanged: _onNotesChanged,
                                    maxLines: null,
                                    expands: true,
                                    style: const TextStyle(
                                      color: AppColors.mochaText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Jot down quick thoughts, ideas, or reminders...',
                                      hintStyle: TextStyle(
                                        color: AppColors.mutedText,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Botanical Leaf Badge Accent
                    Positioned(
                      bottom: 8,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.paperBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.outerBorder, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          size: 32,
                          color: AppColors.warmTanAccent,
                        ),
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
        onPressed: () => _showAddTaskModal(context),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
