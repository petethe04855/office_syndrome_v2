// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/models/location_model.dart';
import 'package:office_syndrome_v2/providers/location_provider%20.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  // สร้าง GlobalKey สำหรับ Form นี้
  final _formKeyRegister = GlobalKey<FormState>();

  // สร้าง TextEditingController
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKeyRegister,
              child: Column(
                children: [
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
                  // Consumer<LocationProvider>(
                  //   builder: (context, locationProvider, child) {
                  //     return Column(
                  //       children: [
                  //         const SizedBox(
                  //           height: 10,
                  //         ),
                  //         DropdownButton<String>(
                  //           value: locationProvider.selectedLocation,
                  //           onChanged: (String? v) {
                  //             locationProvider.setCountryValue(v!);
                  //           },
                  //           items: locationProvider.locations
                  //               .map<DropdownMenuItem<String>>(
                  //             (String value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value,
                  //                 child: Text(value),
                  //               );
                  //             },
                  //           ).toList(),
                  //         ),
                  //         const SizedBox(
                  //           height: 10,
                  //         ),
                  //         DropdownButton<String>(
                  //           value: locationProvider.selectedCountryValue,
                  //           items: locationProvider.countryValue
                  //               .map<DropdownMenuItem<String>>(
                  //             (dynamic tuple) {
                  //               String countryName = tuple.toString();
                  //               return DropdownMenuItem<String>(
                  //                 value: countryName,
                  //                 child: Text(countryName),
                  //               );
                  //             },
                  //           ).toList(),
                  //           onChanged: (String? value) {
                  //             locationProvider.setselectedCountryValue(value!);
                  //           },
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),

                  const SizedBox(
                    height: 10,
                  ),
                  _provincesDropdown(),
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

  Widget _provincesDropdown() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: locationProvider.selectedProvince,
              hint: Text('เลือกจังหวัด'),
              onChanged: (value) {
                locationProvider.setselectedProvince(value!);
              },
              decoration: const InputDecoration(
                labelText: 'จังหวัด',
                border: OutlineInputBorder(),
              ),
              items: locationProvider.province.map((String province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('เลือกเขต:'),
            DropdownButtonFormField<String>(
              value: locationProvider.selectedDistrict,
              hint: Text('เลือกอำเภอ'),
              onChanged: (newValue) {
                locationProvider.setselectedDistrict(newValue!);
              },
              decoration: const InputDecoration(
                labelText: 'อำเภอ',
                border: OutlineInputBorder(),
              ),
              items: locationProvider.selectedProvince != null
                  ? locationProvider.city[locationProvider.selectedProvince]
                      ?.map((String district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(district),
                      );
                    }).toList()
                  : null,
            ),
          ],
        );
      },
    );
  }

  // Widget _provincesDropdown() {
  //   return DropdownButton<String>(
  //     value: Provinces().selectedProvince,
  //     items:
  //         Provinces().provinces.map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //     onChanged: (value) {},
  //   );
  // }

  // Widget _districtsDropdown() {
  //   return DropdownButton<String>(
  //     value: locationProvider.districts.isEmpty
  //         ? ''
  //         : locationProvider.districts[0],
  //     onChanged: (String? newValue) {
  //       // ทำตามต้องการเมื่อมีการเลือกอำเภอ
  //     },
  //     items: locationProvider.districts
  //         .map<DropdownMenuItem<String>>((String district) {
  //       return DropdownMenuItem<String>(
  //         value: district,
  //         child: Text(district),
  //       );
  //     }).toList(),
  //   );
  // }
}
