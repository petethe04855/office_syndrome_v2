// ignore_for_file: unused_field, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/components/custom_textfield.dart';
import 'package:office_syndrome_v2/components/rounded_button.dart';
import 'package:office_syndrome_v2/services/firbase_auth_services.dart';

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

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
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
                  RoundedButton(
                      label: "LOGIN",
                      onPressed: () {
                        // Navigator.pushReplacementNamed(
                        //     context, AppRouter.dashboard);
                      },
                      icon: null)
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
