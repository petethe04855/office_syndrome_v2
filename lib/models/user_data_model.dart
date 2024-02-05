import 'dart:io';

class UserData {
  String email;
  String password;
  String firstName;
  String lastName;
  String role;
  File imageFile;

  UserData({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.imageFile,
  });

  // factory UserData.fromMap(Map<String, dynamic> data) {
  //   return UserData(
  //     firstName: data['first_name'] ?? '',
  //     lastName: data['last_name'] ?? '',
  //     email: data['email'] ?? '',
  //     password: data['password'] ?? '',
  //     role: data['Role'] ?? '',
  //     imageFile: data['images'] ?? '',
  //   );
  // }
}
