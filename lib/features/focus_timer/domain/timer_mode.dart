import 'package:flutter/material.dart';

enum TimerMode {
  focus(
    label: 'FOCUS',
    durationMinutes: 25,
    accentColor: Color(0xFF6B4E3D), // Deep Mocha
    icon: Icons.spa_rounded,
  ),
  shortBreak(
    label: 'REST',
    durationMinutes: 5,
    accentColor: Color(0xFF8F9E82), // Calming Sage
    icon: Icons.coffee_rounded,
  ),
  longBreak(
    label: 'LONG REST',
    durationMinutes: 15,
    accentColor: Color(0xFFBF9C7D), // Warm Tan
    icon: Icons.park_rounded,
  );

  final String label;
  final int durationMinutes;
  final Color accentColor;
  final IconData icon;

  const TimerMode({
    required this.label,
    required this.durationMinutes,
    required this.accentColor,
    required this.icon,
  });

  int get durationSeconds => durationMinutes * 60;
}
