import '../../domain/timer_mode.dart';

enum TimerStatus { initial, running, paused, completed }

class FocusTimerState {
  final TimerMode mode;
  final TimerStatus status;
  final int remainingSeconds;
  final int totalSeconds;
  final int completedSessions;

  const FocusTimerState({
    required this.mode,
    required this.status,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.completedSessions = 0,
  });

  double get progress =>
      totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0.0;

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  FocusTimerState copyWith({
    TimerMode? mode,
    TimerStatus? status,
    int? remainingSeconds,
    int? totalSeconds,
    int? completedSessions,
  }) {
    return FocusTimerState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }
}
