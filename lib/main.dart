import 'package:flutter/material.dart';
import 'package:office_syndrome_v2/app_router.dart';
import 'package:office_syndrome_v2/providers/location_provider%20.dart';
import 'package:office_syndrome_v2/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// กำหนดตัวแปร initialRoute ให้กับ MaterialApp
var initialRoute;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //     apiKey: "AIzaSyCIj74ZdFF90sPIwotV-a1boNmpjWMHkUg",
  //     projectId: "office-syndrome-65672",
  //     messagingSenderId: "673803336541",
  //     appId: "1:673803336541:web:ec6495a1337e14c65d86b4",
  //   ));
  // } else {
  //   await Firebase.initializeApp();
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(color: primary),
        ),
        initialRoute: AppRouter.welcome,
        routes: AppRouter.routes,
      ),
    );
  }
}
