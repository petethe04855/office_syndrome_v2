// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/screens/users/bottomnavpage/home_screen.dart';
import 'package:office_syndrome_v2/screens/users/bottomnavpage/profile_screen.dart';
import 'package:office_syndrome_v2/themes/colors.dart';
import 'package:office_syndrome_v2/utils/utility.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ส่วนของการสร้าง Bottom Navigation Bar ---------------------------------
  // สร้างตัวแปรเก็บ title ของแต่ละหน้า
  String _title = 'Flutter Store';

  // สร้าง index ของแต่ละหน้า
  int _currentIndex = 0;

  // สร้าง List ของแต่ละหน้า
  final List<Widget> _children = [
    HomeScreen(),
    ProfileScreen(),
  ];

  // สร้างฟังก์ชันในการเปลี่ยนหน้า โดยรับค่า index จากการกดที่ bottomNavigationBar
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          _title = 'home';
          break;
        case 1:
          _title = 'profile';
          break;
        default:
          _title = 'Flutter Store';
      }
    });
  }

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
        title: Text(_title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text("Name"),
                  accountEmail: Text("Name@gmail.com"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/noavartar.png'),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer_outlined,
                  ),
                  title: Text(
                    'Counter (With Stateful)',
                  ),
                ),
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
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          onTabTapped(value);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryDark,
        unselectedItemColor: secondaryText,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
