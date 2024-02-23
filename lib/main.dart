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
    var userRole = await Utility.fetchUserRoleFromFirestore(_authUser
        .currentUser!.uid); // Replace 'user_id' with the actual user ID

    // Set initialRoute based on user role
    if (userRole == 'ผู้ป่วย') {
      initialRoute = AppRouter.dashboard;
    } else if (userRole == 'หมอ') {
      initialRoute = AppRouter.doctor;
    } else {
      initialRoute = AppRouter.dashboard;
    }
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
