class KidModel {
  final String name;
  final String email;
  final bool accept;
  final String startDay;
  final String endDay;
  final String adTitle;
  final String adDescription;
  final String adImageUrl;
  final String adEndTime;

  KidModel({
    required this.name,
    required this.email,
    required this.accept,
    required this.startDay,
    required this.endDay,
    required this.adTitle,
    required this.adDescription,
    required this.adImageUrl,
    required this.adEndTime,
  });

  factory KidModel.fromMap(Map<String, dynamic> data) {
    return KidModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      accept: data['accept'] ?? false,
      startDay: data['startDay'] ?? '',
      endDay: data['endDay'] ?? '',
      adTitle: data['adTitle'] ?? '',
      adDescription: data['adDescription'] ?? '',
      adImageUrl: data['adImageUrl'] ?? '',
      adEndTime: data['adEndTime'] ?? '',
    );
  }
}