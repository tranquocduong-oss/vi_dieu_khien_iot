import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/firebase_options.dart';
import 'package:vi_dieu_khien_iot/screen/menu/menu_screen.dart';
import 'package:vi_dieu_khien_iot/screen/login_screen.dart';
import 'package:vi_dieu_khien_iot/screen/mo_dau.dart';
// 👇 Import SplashScreen mới tạo


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 👇 ĐÃ ĐĂNG NHẬP → VÀO MENU LUÔN (Không cần Splash)
          if (snapshot.hasData) {
            return const MenuScreen();
          }

          // 👇 CHƯA ĐĂNG NHẬP → CHẠY SPLASH SCREEN TRƯỚC
          return SplashScreen(toggleTheme: toggleTheme);
        },
      ),
    );
  }
}