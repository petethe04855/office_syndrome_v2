// ignore_for_file: prefer_const_constructors

import 'package:office_syndrome_v2/screens/dashboard/dashboard_screen.dart';
import 'package:office_syndrome_v2/screens/login/login_screen.dart';
import 'package:office_syndrome_v2/screens/products/components/product_form.dart';
import 'package:office_syndrome_v2/screens/products/components/product_item.dart';
import 'package:office_syndrome_v2/screens/register/register_screen.dart';
import 'package:office_syndrome_v2/screens/welcome/welcome_screen.dart';

class AppRouter {
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String register = 'register';
  static const String dashboard = 'dashboard';
  static const String productForm = 'productForm';
  static const String productItem = 'productItem';

  // Router Map
  static get routes => {
        welcome: (context) => WelcomeScreen(),
        login: (context) => LoginScreen(),
        register: (context) => RegisterScreen(),
        dashboard: (context) => DashboardScreen(),
        productForm: (context) => ProductForm(),
        productItem: (context) => ProductItem(),
      };
}
