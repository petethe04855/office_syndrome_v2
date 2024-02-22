import 'dart:io';

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

class DataUserProvider with ChangeNotifier {
  var userData;

  final FirebaseAuthService _userService = FirebaseAuthService();

  Function()? onDataUpdated = () {
    print('User data has been updated!');
  }; // Callback function

  void updateUserData(String firstName, String lastName, File? imageFile) {
    // Call FirebaseAuthService to update data
    _userService.updateUser(firstName, lastName, imageFile);
    // Update internal user and notify listeners
    userData = _userService.updateUser(firstName, lastName, imageFile);
    // Update user based on response
    notifyListeners();
  }
}
