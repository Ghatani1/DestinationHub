// ignore_for_file: file_names

class RecommendModal {
  String? placeName;
  String? placeDescription;
  String? category;
  List<String>? images;
  String? userId;

  RecommendModal({
    this.placeName,
    this.placeDescription,
    this.category,
    this.images,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'placeName': placeName,
      'category': category,
      'placeDescription': placeDescription,
      'images': images,
      'userId': userId,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'category': category,
      'placeDescription': placeDescription,
      'images': images,
      'userId': userId,
    };
  }
}
