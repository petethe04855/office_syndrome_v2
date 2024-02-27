import 'dart:io';

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

class DataUserProvider with ChangeNotifier {
  var userData;

  final FirebaseAuthService _userService = FirebaseAuthService();

  Function()? onDataUpdated = () {
    print('User data has been updated!');
  };

  void updateUserData(String firstName, String lastName, File? imageFile) {
    // _userService.updateUser ส่งค่าไปให้ updateUser ใน FirebaseAuthService
    _userService.updateUser(firstName, lastName, imageFile);
    // เก็บค่า _userService.updateUser ไว้ใน userData
    userData = _userService.updateUser(firstName, lastName, imageFile);

    notifyListeners();
  }
}
