class Alarm {
  final String label;
  final String time;
  bool isEnabled;

  Alarm({
    required this.label,
    required this.time,
    this.isEnabled = true,
  });
}