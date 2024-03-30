// ignore_for_file: file_names

class UserModal {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? profileUrl;

  UserModal({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.profileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileUrl': profileUrl,
    };
  }

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileUrl: json['profileUrl'] ?? "https://via.placeholder.com/150",
    );
  }
}
