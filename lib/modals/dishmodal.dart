class DishModal {
  String? dishName;
  List<String>? dishImage;
  String? dishDescription;
  String? userId;
  String? placeName; // Add this field to store the associated placeName

  DishModal({
    this.dishName,
    this.dishImage,
    this.dishDescription,
    this.userId,
    this.placeName, // Initialize it in the constructor if needed
  });

  Map<String, dynamic> toJson() {
    return {
      'dishName': dishName,
      'dishImage': dishImage,
      'dishDescription': dishDescription,
      'userId': userId,
      'placeName': placeName, // Include placeName in the JSON representation
    };
  }
}
