import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const BeautyXPApp());
}

class BeautyXPApp extends StatelessWidget {
  const BeautyXPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyXP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFB85CA8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB85CA8),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
