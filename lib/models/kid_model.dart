class KidModel {
  final String name;
  final String email;
  final bool accept;
  final String startDay;
  final String endDay;

  KidModel({
    required this.name,
    required this.email,
    required this.accept,
    required this.startDay,
    required this.endDay,
  });

  factory KidModel.fromMap(Map<String, dynamic> data) {
    return KidModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      accept: data['accept'] ?? false,
      startDay: data['startDay'] ?? '',
      endDay: data['endDay'] ?? '',
    );
  }
}