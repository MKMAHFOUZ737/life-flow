class HabitEntity {
  final String id;
  final String title;
  final String iconName;
  final int colorValue;
  final int streak;
  final List<String> completedDates; // Format: "yyyy-MM-dd"

  const HabitEntity({
    required this.id,
    required this.title,
    required this.iconName,
    required this.colorValue,
    this.streak = 0,
    this.completedDates = const [],
  });

  bool get isCompletedToday {
    final today = _dateKey(DateTime.now());
    return completedDates.contains(today);
  }

  static String _dateKey(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  HabitEntity copyWith({
    String? id,
    String? title,
    String? iconName,
    int? colorValue,
    int? streak,
    List<String>? completedDates,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      streak: streak ?? this.streak,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
