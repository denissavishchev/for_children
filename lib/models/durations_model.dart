class DurationsModel {
  final String day;
  final String start;
  final String end;
  final String parentStart;
  final String parentEnd;
  final String duration;

  DurationsModel({
    required this.day,
    required this.start,
    required this.end,
    required this.parentStart,
    required this.parentEnd,
    required this.duration,
  });

  factory DurationsModel.fromMap(Map<String, dynamic> data) {
    return DurationsModel(
      day: data['day'] ?? '',
      start: data['start'] ?? '',
      end: data['end'] ?? '',
      parentStart: data['parentStart'] ?? '',
      parentEnd: data['parentEnd'] ?? '',
      duration: data['duration'] ?? '',
    );
  }
}