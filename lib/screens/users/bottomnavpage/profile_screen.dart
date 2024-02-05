// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuthService _userService = FirebaseAuthService();
  Map<String, dynamic>? userData;

  void _fetchUserData() async {
    try {
      // ดึงข้อมูลผู้ใช้
      userData = await _userService.getUserData();

      // อัพเดท UI หลังจากดึงข้อมูลเสร็จสมบูรณ์
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      children: [
        _buildHeader(),
        _buildListMenu(),
      ],
    ));
  }

  // สร้าง widget สำหรับแสดงข้อมูล profile ที่อ่านมาจาก shared preference
  Widget _buildHeader() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: primary,
      ),
      child: userData != null
          ? Column(
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData!['images']),
                ),
                const SizedBox(height: 10),
                Text(
                  'Name: ${userData!['first_name']} ${userData!['last_name']}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // Text(
                //   '_firstName _lastName',
                //   style: const TextStyle(
                //       fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                // ),
                Text(
                  'Email ${userData!['email']}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            )
          : Text(
              'User data not available',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }

  Widget _buildListMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text("Edit Profile"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () async {
            await Navigator.pushNamed(context, AppRouter.editProfile);
          },
        ),
        ListTile(
          title: Text("menu_changepass"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text("menu_changelang"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: Text("menu_logout"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
