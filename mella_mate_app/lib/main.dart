import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/signup_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MellaMate',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SignupPage(),
    );
  }
}
