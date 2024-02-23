// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/providers/getdata_provider.dart';
import 'package:office_syndrome_v2/screens/users/editprofile/edit_profile_screen.dart';
import 'package:office_syndrome_v2/themes/colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    // TODO: implement initState
    // _fetchUserData();
    super.initState();
    Provider.of<GetDataProvider>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GetDataProvider>(
        builder: (context, getDataProvider, child) {
          final userData = getDataProvider.provideGetData;

          return ListView(
            shrinkWrap: true,
            children: [
              _buildHeader(userData),
              _buildListMenu(userData),
            ],
          );
        },
      ),
    );
  }

  // สร้าง widget สำหรับแสดงข้อมูล profile ที่อ่านมาจาก shared preference
  Widget _buildHeader(userData) {
    final getDataProvider = Provider.of<GetDataProvider>(context);

    getDataProvider.onDataUpdated = () {
      setState(() {});
    };
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

  Widget _buildListMenu(userData) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EditProfileScreen(data: userData);
                },
              ),
            );
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
