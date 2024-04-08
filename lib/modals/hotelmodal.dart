class HotelModal {
  String? hotelName;
  List<String>? hotelImg;
  String? hotelNum;
  String? hotelEmail;
  String? userId;
  String? placeName;

  HotelModal({
    this.hotelName,
    this.hotelImg,
    this.hotelNum,
    this.hotelEmail,
    this.userId,
    this.placeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotelName': hotelName,
      'hotelNum': hotelNum,
      'hotelEmail': hotelEmail,
      'hotelImg': hotelImg,
      'userId': userId,
      'placeName': placeName, // Include placeName in the JSON representation
    };
  }
}
