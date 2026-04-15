class AdsModel {
  final String name;
  final String kidEmail;
  final String title;
  final String description;
  final String endTime;
  final String imageUrl;

  AdsModel({
    required this.name,
    required this.kidEmail,
    required this.title,
    required this.description,
    required this.endTime,
    required this.imageUrl,

  });

  factory AdsModel.fromMap(Map<String, dynamic> data) {
    return AdsModel(
      name: data['name'] ?? '',
      kidEmail: data['kidEmail'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      endTime: data['endTime'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}