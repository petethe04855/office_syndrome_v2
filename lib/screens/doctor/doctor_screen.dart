import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _authUser = FirebaseAuth.instance;

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

  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ProductCategory') // เปลี่ยนเป็นชื่อคอลเล็กชันของคุณ
        .where('uidUpLoadvideo',
            isEqualTo: _authUser.currentUser!
                .uid) // เปลี่ยน 'user_uid' เป็น UID ของผู้ใช้ที่ต้องการดึงข้อมูล
        .get();

    setState(() {
      documents = querySnapshot.docs;
    });
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
      body: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("data"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("data"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.amber,
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(documents[index][
                        'uidUpLoadvideo']), // เปลี่ยน 'field_name' เป็นชื่อของฟิลด์ที่คุณต้องการแสดง
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
