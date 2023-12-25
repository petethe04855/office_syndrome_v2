// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/themes/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      child: Column(
        children: [
          Text(
            "Hello",
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/noavartar.png'),
          ),
          const SizedBox(height: 10),
          Text(
            '_firstName _lastName',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '_email',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildListMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text("menu_account"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
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
