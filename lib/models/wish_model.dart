class WishModel {
  final String wish;
  final String whyNeed;
  final String imageUrl;


  WishModel({
    required this.wish,
    required this.whyNeed,
    required this.imageUrl,
  });

  factory WishModel.fromMap(Map<String, dynamic> data) {
    return WishModel(
      wish: data['wish'] ?? '',
      whyNeed: data['whyNeed'] ?? '',
      imageUrl: data['imageUrl'] ?? false,
    );
  }
}