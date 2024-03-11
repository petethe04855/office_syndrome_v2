import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/models/product_category_model.dart';
import 'package:office_syndrome_v2/screens/doctor/upload/components/upload_image.dart';
import 'package:office_syndrome_v2/screens/doctor/upload/upload_add.dart';
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
        .collection('ProductCategory')
        .where('uidUpLoad', isEqualTo: _authUser.currentUser!.uid)
        .get();

    setState(() {
      documents = querySnapshot.docs;
    });
  }

  bool _isGridView = true;

  // สร้างตัวแปร refreshKey สำหรับ RefreshIndicator
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  // สร้างฟังก์ชันสลับระหว่าง ListView และ GridView
  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor'),
        actions: [
          IconButton(
            onPressed: _toggleView,
            icon: Icon(_isGridView ? Icons.list_outlined : Icons.grid_view,
                color: Colors.white),
          )
        ],
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
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadAdd(),
                        ),
                      );
                    },
                    child: Text("data"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(documents[index]['uidUpLoad']));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _gridView Widget -----------------------------------------------------------
  Widget _gridView(List<ProductCategory> upLoad) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // จำนวนคอลัมน์
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          mainAxisExtent: 200,
        ),
        itemCount: upLoad.length,
        itemBuilder: (context, index) {
          return Padding(padding: const EdgeInsets.all(8.0), child: ListTile());
        });
  }
  // ---------------------------------------------------------------------------

  Widget _listView(List<ProductCategory> upLoad) {
    return ListView.builder(
      itemCount: upLoad.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: SizedBox(
            height: 350,
          ),
        );
      },
    );
  }
}
