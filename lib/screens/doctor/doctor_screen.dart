import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/utils/utility.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
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
        title: Text('Doctor'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.timer_outlined,
              ),
              title: Text(
                'Out',
              ),
              onTap: () {
                sigOut();
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Doctor'),
      ),
    );
  }
}
