import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/components/mobile_layout.dart';
import 'package:office_syndrome_v2/components/responsive_layout.dart';
import 'package:office_syndrome_v2/components/web_layout.dart';
import 'package:office_syndrome_v2/screens/login/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      webChild: WebLayout(
          imageWidget: Image.asset(
            "assets/images/login.png",
            width: 200,
          ),
          dataWidget: LoginForm()),
      mobileChild: MobileLayout(
          imageWidget: Image.asset(
            "assets/images/login.png",
            width: 75,
          ),
          dataWidget: LoginForm()),
    );
  }
}
