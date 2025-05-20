import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/shared_pref_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),
      home: FutureBuilder<String?>(
        future: SharedPrefService.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const SizedBox();
          if (snapshot.data == null) {
            return LoginPage();
          } else {
            return HomePage();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
