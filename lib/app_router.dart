// ignore_for_file: prefer_const_constructors

import 'package:office_syndrome_v2/screens/doctor/doctor_screen.dart';
import 'package:office_syndrome_v2/screens/regions/region_screen.dart';
import 'package:office_syndrome_v2/screens/users/dashboard/dashboard_screen.dart';
import 'package:office_syndrome_v2/screens/login/login_screen.dart';
import 'package:office_syndrome_v2/screens/products/components/product_item.dart';
import 'package:office_syndrome_v2/screens/register/register_screen.dart';
import 'package:office_syndrome_v2/screens/welcome/welcome_screen.dart';

class AppRouter {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String register = 'register';
  static const String dashboard = 'dashboard';
  static const String productScreen = 'productScreen';
  static const String productItem = 'productItem';
  // static const String editProfile = 'editProfile';
  static const String region = 'region';
  static const String doctor = 'doctor';

  // Router Map
  static get routes => {
        welcome: (context) => WelcomeScreen(),
        login: (context) => LoginScreen(),
        register: (context) => RegisterScreen(),
        dashboard: (context) => DashboardScreen(),
        productItem: (context) => ProductItem(),
        // editProfile: (context) => EditProfileScreen(),
        region: (context) => RegionScreen(),
        doctor: (context) => DoctorScreen(),
      };
}
