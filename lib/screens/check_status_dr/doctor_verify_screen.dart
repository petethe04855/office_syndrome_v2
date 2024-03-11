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
  String userId = FirebaseAuth.instance.currentUser!.uid;

  bool? statusIsTrue; // ตัวอย่างค่า statusIsTrue

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

  void approveAndNavigate() async {
    // ดึงข้อมูลผู้ใช้จาก Firestore
    Map<String, dynamic>? userData =
        await Utility.checkSharedPreferenceRoleUser(userId);

    if (userData != null && userData['status'] == true) {
      // ถ้า status เป็น true แสดง Dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('การอนุมัติ'),
            content: const Text('คุณได้รับการอนุมัติแล้ว'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, AppRouter.doctor);
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
    } else {
      // กรณีที่ status เป็น false หรือไม่มีข้อมูล
      print('ไม่สามารถอนุมัติได้');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("userId ${userId}");
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
            ElevatedButton(
              onPressed: () {
                // ตรวจสอบค่า statusIsTrue
                // if (statusIsTrue) {
                //   approveAndNavigate();
                // } else {

                // }
              },
              child: const Text('อนุมัติ'),
            ),
          ],
        ),
      ),
    );
  }
}
