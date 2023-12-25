import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/components/mobile_layout.dart';
import 'package:office_syndrome_v2/components/responsive_layout.dart';
import 'package:office_syndrome_v2/components/web_layout.dart';
import 'package:office_syndrome_v2/screens/register/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      webChild: WebLayout(
        imageWidget: Image.asset(
          "assets/images/signup.png",
          width: 200,
        ),
        dataWidget: RegisterForm(),
      ),
      mobileChild: MobileLayout(
        imageWidget: Image.asset(
          "assets/images/signup.png",
          width: 75,
        ),
        dataWidget: RegisterForm(),
      ),
    );
  }
}
