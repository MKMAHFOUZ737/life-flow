import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifeflow/core/constants/app_colors.dart';
import '../../domain/timer_mode.dart';
import '../cubit/focus_timer_cubit.dart';
import '../cubit/focus_timer_state.dart';
import '../widgets/timer_progress_ring.dart';

class FocusTimerScreen extends StatelessWidget {
  const FocusTimerScreen({super.key});

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
                child: BlocBuilder<FocusTimerCubit, FocusTimerState>(
                  builder: (context, state) {
                    final cubit = context.read<FocusTimerCubit>();
                    final modeColor = state.mode.accentColor;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Header Titles
                        Column(
                          children: const [
                            Text(
                              'FOCUS FLOW',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: AppColors.mochaText,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'DEEP WORK & RECHARGE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),

                        // Segmented Mode Selector (FOCUS | REST | LONG REST)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.paperBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.ruledLine),
                            ),
                            child: Row(
                              children: TimerMode.values.map((mode) {
                                final isSelected = state.mode == mode;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => cubit.setMode(mode),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? mode.accentColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        mode.label,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.0,
                                          color: isSelected
                                              ? AppColors.paperBg
                                              : AppColors.mutedText,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // Circular Progress Ring
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: state.progress),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          builder: (context, animatedProgress, _) {
                            return TimerProgressRing(
                              progress: animatedProgress,
                              activeColor: modeColor,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(state.mode.icon,
                                      color: modeColor, size: 36),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.formattedTime,
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.mochaText,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.status == TimerStatus.running
                                        ? 'STAY PRESENT'
                                        : state.status == TimerStatus.paused
                                            ? 'PAUSED'
                                            : 'READY',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Botanical Badge Counter
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.paperBg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.ruledLine),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco_rounded,
                                  color: AppColors.warmTanAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${state.completedSessions} SESSIONS COMPLETED',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: AppColors.mochaText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Control Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filledTonal(
                              onPressed: cubit.resetTimer,
                              icon: const Icon(Icons.refresh_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.paperBg,
                                foregroundColor: AppColors.mochaText,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                      color: AppColors.ruledLine),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (state.status == TimerStatus.running) {
                                  cubit.pauseTimer();
                                } else {
                                  cubit.startTimer();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: modeColor,
                                foregroundColor: AppColors.paperBg,
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 42, vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    state.status == TimerStatus.running
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.status == TimerStatus.running
                                        ? 'PAUSE'
                                        : 'START',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
