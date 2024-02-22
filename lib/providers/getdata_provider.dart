import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetDataProvider with ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _authUid = FirebaseAuth.instance;

  Map<String, dynamic>? provideGetData;
  Function()? onDataUpdated = () {
    print('User data has been updated!');
  }; // Callback function

  Future<void> fetchUserData() async {
    try {
      DocumentReference userRef =
          _firestore.collection('Users').doc(_authUid.currentUser?.uid);

      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        provideGetData = userSnapshot.data() as Map<String, dynamic>;
        notifyListeners();

        // Call the callback function to inform listeners
        if (onDataUpdated != null) {
          onDataUpdated!();
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
