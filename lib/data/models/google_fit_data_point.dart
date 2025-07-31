class GoogleFitDataPoint {
  final DateTime date;
  final int steps;

  GoogleFitDataPoint({
    required this.date,
    required this.steps,
  });

  factory GoogleFitDataPoint.fromMap(Map<String, dynamic> map) {
    return GoogleFitDataPoint(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      steps: map['steps'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'steps': steps,
    };
  }
}