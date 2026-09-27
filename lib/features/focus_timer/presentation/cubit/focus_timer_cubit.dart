import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/notification_service.dart';
import '../../domain/timer_mode.dart';
import 'focus_timer_state.dart';

class FocusTimerCubit extends Cubit<FocusTimerState> {
  Timer? _timer;

  FocusTimerCubit()
      : super(
          FocusTimerState(
            mode: TimerMode.focus,
            status: TimerStatus.initial,
            remainingSeconds: TimerMode.focus.durationSeconds,
            totalSeconds: TimerMode.focus.durationSeconds,
            completedSessions: 0,
          ),
        );

  void setMode(TimerMode mode) {
    _timer?.cancel();
    emit(state.copyWith(
      mode: mode,
      status: TimerStatus.initial,
      remainingSeconds: mode.durationSeconds,
      totalSeconds: mode.durationSeconds,
    ));
  }

  void startTimer() {
    if (state.status == TimerStatus.running) return;

    emit(state.copyWith(status: TimerStatus.running));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      } else {
        _onTimerFinished();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void resetTimer() {
    _timer?.cancel();
    emit(state.copyWith(
      status: TimerStatus.initial,
      remainingSeconds: state.mode.durationSeconds,
      totalSeconds: state.mode.durationSeconds,
    ));
  }

  Future<void> _onTimerFinished() async {
    _timer?.cancel();
    final wasFocus = state.mode == TimerMode.focus;
    final nextSessions =
        wasFocus ? state.completedSessions + 1 : state.completedSessions;

    emit(state.copyWith(
      status: TimerStatus.completed,
      remainingSeconds: 0,
      completedSessions: nextSessions,
    ));

    // Audio chime feedback using native system sound
    SystemSound.play(SystemSoundType.alert);
    HapticFeedback.heavyImpact();

    // Trigger local completion notification
    await NotificationService.instance.showNotification(
      id: 999,
      title: wasFocus ? 'Focus Block Finished!' : 'Break Over!',
      body: wasFocus
          ? 'Great session. Take a breather to refresh your mind.'
          : 'Ready to dive back into deep work?',
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
