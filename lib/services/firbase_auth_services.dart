import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> sigUpWithEmailAndPassWord(
    String email,
    String password,
    String firstName,
    String lastName,
    String confirmPassword,
    String role,
    File? imageFile,
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

      final imageName = imageFile;
      final imageRef =
          FirebaseStorage.instance.ref().child('images/$imageName.jpg');

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
      });

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
}
