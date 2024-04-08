class ActivitiesModal {
  String? activityName;
  List<String>? activityImage;
  String? activityDescription;
  String? userId;
  String? placeName; // Add this field to store the associated placeName

  ActivitiesModal({
    this.activityName,
    this.activityImage,
    this.activityDescription,
    this.userId,
    this.placeName, // Initialize it in the constructor if needed
  });

  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      'activityImage': activityImage,
      'activityDescription': activityDescription,
      'userId': userId,
      'placeName': placeName, // Include placeName in the JSON representation
    };
  }
}
