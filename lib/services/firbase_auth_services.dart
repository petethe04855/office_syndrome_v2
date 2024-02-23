import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool status = false;

  Future<User?> sigUpWithEmailAndPassWord(
    String email,
    String password,
    String firstName,
    String lastName,
    String confirmPassword,
    String role,
    File? _imageFile,
  ) async {
    try {
      if (password != confirmPassword) {
        // Handle password mismatch
        return null;
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (role == "ผู้ป่วย") {
        final imageFile = _imageFile;
        final imageName = credential.user!.uid;
        final imageRef =
            FirebaseStorage.instance.ref().child('users/image/$imageName.jpg');

        await imageRef.putFile(imageFile!);

        final imageUrl = await imageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(credential.user!.uid)
            .set({
          'uid': credential.user!.uid,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'images': imageUrl,
          'Role': role,
          // 'status': status,
        });
      } else if (role == "หมอ") {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(credential.user!.uid)
            .set({
          'uid': credential.user!.uid,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'Role': role,
          'status': status,
        });
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during user registration: $e");
      return null;
    }
  }

  Future<User?> sigInWithEmailAndPassWord(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String uid = _auth.currentUser?.uid ?? "";
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUser(
      String first_name, String last_name, File? _imageFile) async {
    try {
      if (_imageFile != null) {
        final imageFile = _imageFile;
        final imageName = _auth.currentUser?.uid;
        final imageRef =
            FirebaseStorage.instance.ref().child('users/image/$imageName.jpg');

        await imageRef.putFile(imageFile!);

        final imageUrl = await imageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser?.uid)
            .update({
          'first_name': first_name,
          'last_name': last_name,
          'images': imageUrl,
        });
      } else {
        // ถ้าไม่มีการเปลี่ยนรูป ให้ใช้ข้อมูลเดิม
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser?.uid)
            .update({
          'first_name': first_name,
          'last_name': last_name,
        });
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
