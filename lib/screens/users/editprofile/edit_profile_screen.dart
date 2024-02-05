import 'dart:io';

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuthService _userService = FirebaseAuthService();

  final _EditKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _imageFile;

  Map<String, dynamic>? userData;

  void _fetchUserData() async {
    try {
      // ดึงข้อมูลผู้ใช้
      userData = await _userService.getUserData();

      // กำหนดค่าเริ่มต้นให้กับ TextEditingController
      if (userData != null) {
        _fnameController.text = userData!['first_name'];
        _lnameController.text = userData!['last_name'];
        _emailController.text = userData!['email'];
        // _imageFile = userData!['images'];
      }

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
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _EditKey,
            child: userData != null
                ? Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData!['images']),
                      ),
                      customTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.person),
                        obscureText: false,
                        validator: (value) {},
                      ),
                      customTextField(
                        controller: _fnameController,
                        hintText: 'First Name',
                        prefixIcon: const Icon(Icons.person),
                        obscureText: false,
                        validator: (value) {},
                      ),
                      customTextField(
                        controller: _lnameController,
                        hintText: 'Last Name',
                        prefixIcon: const Icon(Icons.abc),
                        obscureText: false,
                        validator: (value) {},
                      ),
                      RoundedButton(
                          label: 'Save',
                          onPressed: () {
                            _userService.updateUser(
                              _emailController.text,
                              _fnameController.text,
                              _lnameController.text,
                            );

                            Navigator.pop(context, 'refresh');
                          },
                          icon: null)
                    ],
                  )
                : Text(
                    'User data not available',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
