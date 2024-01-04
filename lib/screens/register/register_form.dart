// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/screens/register/components/register_image.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // สร้าง GlobalKey สำหรับ Form นี้
  final _formKeyRegister = GlobalKey<FormState>();

  // สร้าง TextEditingController
  final _firstNameController = TextEditingController(text: 'dddd');

  final _lastNameController = TextEditingController(text: 'sssss');

  final _emailController = TextEditingController(text: 'dddd@gmail.com');

  final _passwordController = TextEditingController(text: '123456');

  final _confirmPasswordController = TextEditingController(text: '123456');

  // ไฟล์รูปภาพ
  File? _imageFile;

  String? _imageName;

  List<String> _position = ['ผู้ป่วย', 'หมอ'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            "ลงทะเบียน",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKeyRegister,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  RegisterImage(
                    image: _imageName,
                    (file) {
                      setState(() {
                        _imageFile = file;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    controller: _firstNameController,
                    hintText: "First Name",
                    prefixIcon: const Icon(Icons.person),
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชื่อ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    controller: _lastNameController,
                    hintText: "Last Name",
                    prefixIcon: const Icon(Icons.person),
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกนามสกุล";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกอีเมล";
                      } else if (!value.contains("@")) {
                        return "กรุณากรอกอีเมลให้ถูกต้อง";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      } else if (value.length < 6) {
                        return "กรุณากรอกรหัสผ่านอย่างน้อย 6 ตัวอักษร";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกรหัสผ่านอีกครั้ง";
                      } else if (value != _passwordController.text) {
                        return "กรุณากรอกรหัสผ่านให้ตรงกัน";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  customDropdown(),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedButton(
                    label: "Register",
                    onPressed: () {
                      if (_formKeyRegister.currentState!.validate()) {
                        _formKeyRegister.currentState!.save();
                        FirebaseAuthService().sigUpWithEmailAndPassWord(
                          _emailController.text,
                          _passwordController.text,
                          _firstNameController.text,
                          _lastNameController.text,
                          _confirmPasswordController.text,
                          _position.first,
                          _imageFile,
                        );
                        // FirebaseAuthService().upLoadImage(_imageFile);
                        Navigator.pushReplacementNamed(
                            context, AppRouter.login);
                      }
                    },
                    icon: null,
                  ),
                  // _provincesDropdown(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customDropdown() {
    return DropdownButtonFormField<String>(
      hint: Text(_position.first),
      onChanged: (value) {
        setState(() {
          print(value);
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        isDense: true,
      ),
      items: _position.map((String province) {
        return DropdownMenuItem<String>(
          value: province,
          child: Text(province),
        );
      }).toList(),
    );
  }

  // Widget _provincesDropdown() {
  //   return Consumer<LocationProvider>(
  //     builder: (context, locationProvider, child) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           DropdownButtonFormField<String>(
  //             value: locationProvider.selectedProvince,
  //             hint: Text('เลือกจังหวัด'),
  //             onChanged: (value) {
  //               locationProvider.setselectedProvince(value!);
  //             },
  //             items: locationProvider.province.map((String province) {
  //               return DropdownMenuItem<String>(
  //                 value: province,
  //                 child: Text(province),
  //               );
  //             }).toList(),
  //           ),
  //           SizedBox(height: 20),
  // Text('เลือกเขต:'),
  // DropdownButtonFormField<String>(
  //   value: locationProvider.selectedDistrict,
  //   hint: Text('เลือกอำเภอ'),
  //   onChanged: (newValue) {
  //     locationProvider.setselectedDistrict(newValue!);
  //   },
  //   decoration: const InputDecoration(
  //     labelText: 'อำเภอ',
  //     border: OutlineInputBorder(),
  //   ),
  //   items: locationProvider.selectedProvince != null
  //       ? locationProvider.city[locationProvider.selectedProvince]
  //           ?.map((String district) {
  //           return DropdownMenuItem<String>(
  //             value: district,
  //             child: Text(district),
  //           );
  //         }).toList()
  //       : null,
  // ),
  //     ],
  //   );
  // },
  // );
  // }
}
