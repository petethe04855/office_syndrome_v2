import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/utils/utility.dart';

class DoctorVerifyScreen extends StatefulWidget {
  const DoctorVerifyScreen({super.key});

  @override
  State<DoctorVerifyScreen> createState() => _DoctorVerifyScreenState();
}

class _DoctorVerifyScreenState extends State<DoctorVerifyScreen> {
  void sigOut() {
    FirebaseAuth.instance.signOut();
    // Remove token, loginStatus shared preference
    Utility.removeSharedPreference('token');
    Utility.removeSharedPreference('loginStatus');

    // Clear all route and push to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouter.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Dr Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Check Dr Screen'),
            ElevatedButton(
              onPressed: () {
                sigOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
