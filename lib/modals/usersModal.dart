// ignore_for_file: file_names

class UserModal {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  UserModal({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  UserModal fromJson(Map<String, dynamic> json) {
    return UserModal(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
