// ignore_for_file: unused_field, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';
import 'package:office_syndrome_v2/utils/utility.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  // สร้าง GlobalKey สำหรับ Form นี้
  final _formKeyLogin = GlobalKey<FormState>();

  // สร้าง TextEditingController
  final _emailController = TextEditingController(text: 'dddd@gmail.com');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            "เข้าสู่ระบบ",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
              key: _formKeyLogin,
              child: Column(
                children: [
                  customTextField(
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    obscureText: false,
                    textInputType: TextInputType.emailAddress,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          //Open Forgot password screen here
                          // Navigator.pushNamed(context, AppRouter.forgotPassword);
                        },
                        child: const Text("ลืมรหัสผ่าน ?"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // RoundedButton(
                  //   label: "LOGIN",
                  //   onPressed: () async {
                  //     // Navigator.pushReplacementNamed(
                  //     //     context, AppRouter.dashboard);
                  //     if (_formKeyLogin.currentState!.validate()) {
                  //       _formKeyLogin.currentState!.save();
                  //       // _signIn();

                  //       await Utility.setSharedPreference('loginStatus', true);

                  //       FirebaseAuthService().sigInWithEmailAndPassWord(
                  //           _emailController.text, _passwordController.text);
                  //       Navigator.pushReplacementNamed(
                  //         context,
                  //         AppRouter.dashboard,
                  //       );
                  //     }
                  //   },
                  //   icon: null,
                  // ),
                  RoundedButton(
                    label: "LOGIN",
                    onPressed: () async {
                      if (_formKeyLogin.currentState!.validate()) {
                        _formKeyLogin.currentState!.save();

                        // Perform Firebase authentication
                        try {
                          bool isAuthenticated =
                              await _auth.sigInWithEmailAndPassWord(
                            _emailController.text,
                            _passwordController.text,
                          );

                          // Inside the onPressed method of the login button
                          // Inside the onPressed method of the login button
                          if (isAuthenticated) {
                            // Successfully authenticated, set login status and fetch user role
                            await Utility.setSharedPreference(
                                'loginStatus', true);

                            // Get the current user's ID from Firebase
                            String userId =
                                FirebaseAuth.instance.currentUser!.uid;

                            // Fetch user role and status from Firestore
                            Map<String, dynamic>? userData =
                                await Utility.checkSharedPreferenceRoleUser(
                                    userId);

                            if (userData != null) {
                              String userRole = userData['Role'] ??
                                  ''; // Replace 'Role' with the actual field name in Firestore
                              bool statusIsTrue = userData['status'] ??
                                  false; // Replace 'status' with the actual field name in Firestore

                              // Determine the route based on the user role and status
                              if (userRole == 'ผู้ป่วย') {
                                print("userRole ${userRole}");
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.dashboard);
                              } else if (userRole == 'หมอ' &&
                                  statusIsTrue == true) {
                                print("userRole ${userRole}");
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.doctor);
                                AppRouter.doctor; // ถ้า status เป็น true
                              } else if (userRole == 'หมอ' &&
                                  statusIsTrue == false) {
                                print("userRole ${userRole}");
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.doctorVerifyScreen);
                                // ถ้า status เป็น true
                              } else {
                                print("userRole ไม่เข้าเงื่อนไข");
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.dashboard);
                              }
                            }
                          } else {
                            // Authentication failed, show a SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid email or password'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          // Handle specific FirebaseAuth exceptions
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User not found'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Incorrect password'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            // Handle other FirebaseAuth exceptions if needed
                            print('Firebase Authentication error: ${e.code}');
                          }
                        } catch (e) {
                          // Handle other errors if needed
                          print('Error during authentication: $e');
                        }
                      }
                      // Navigator.pushNamed(context, AppRouter.chooseMapScreen);
                    },
                    icon: null,
                  ),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ยังไม่มีบัญชีกับเรา ? "),
              InkWell(
                onTap: () {
                  //Open Sign up screen here
                  Navigator.pushReplacementNamed(context, AppRouter.register);
                },
                child: const Text(
                  "สมัครสมาชิก",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
