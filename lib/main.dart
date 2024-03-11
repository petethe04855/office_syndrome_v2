import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/providers/data_user_provider.dart';
import 'package:office_syndrome_v2/providers/getdata_provider.dart';
import 'package:office_syndrome_v2/themes/colors.dart';
import 'package:office_syndrome_v2/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// กำหนดตัวแปร initialRoute ให้กับ MaterialApp
var initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // กำหนดตัวแปร initialRoute ให้กับ MaterialApp
  var _authUser = FirebaseAuth.instance;

  // เรียกใช้ SharedPreferences
  await Utility.initSharedPrefs();

  // //ถ้าเคย Login แล้ว ให้ไปยังหน้า Dashboard
  // if (Utility.getSharedPreference('loginStatus') == true) {
  //   initialRoute = AppRouter.dashboard;
  // } else if (Utility.getSharedPreference('welcomeStatus') == true) {
  //   // ถ้าเคยแสดง Intro แล้ว ให้ไปยังหน้า Login
  //   initialRoute = AppRouter.login;
  // } else {
  //   // ถ้ายังไม่เคยแสดง Intro ให้ไปยังหน้า Welcome
  //   initialRoute = AppRouter.welcome;
  // }

  if (Utility.getSharedPreference('loginStatus') == true) {
    // Fetch user role from Firestore
    if (_authUser.currentUser != null) {
      Map<String, dynamic>? userData =
          await Utility.checkSharedPreferenceRoleUser(
        _authUser.currentUser!.uid,
      );

      String userRole = userData!['Role'] ??
          ''; // Replace 'Role' with the actual field name in Firestore
      bool statusIsTrue = userData['status'] ?? false;
      if (userRole == 'ผู้ป่วย') {
        print("userRole ${userRole}");
        initialRoute = AppRouter.dashboard;
      } else if (userRole == 'หมอ' && statusIsTrue == true) {
        print("userRole ${userRole} ${statusIsTrue}");
        initialRoute = AppRouter.doctor; // ถ้า status เป็น true
      } else if (userRole == 'หมอ' && statusIsTrue == false) {
        print("userRole ${userRole} ${statusIsTrue}");
        initialRoute = AppRouter.doctorVerifyScreen; // ถ้า status เป็น true
      } else {
        print("userRole ไม่เข้าเงื่อนไข");
        initialRoute = AppRouter.dashboard;
      }
    } else {
      // Handle the case when _authUser.currentUser is null
      print('Error: Current user is null.');
      initialRoute = AppRouter.login;
      // You might want to show an error message to the user or handle it appropriately.
    }

    // Set initialRoute based on user role
  } else if (Utility.getSharedPreference('welcomeStatus') == true) {
    // ถ้าเคยแสดง Intro แล้ว
    initialRoute = AppRouter.login;
  } else {
    // ถ้ายังไม่เคยแสดง Intro
    initialRoute = AppRouter.welcome;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(color: primary),
        ),
        initialRoute: initialRoute,
        routes: AppRouter.routes,
      ),
    );
  }
}
