import 'package:flutter/material.dart';
import 'home_screen.dart'; 

void main() {
  runApp(const BeautyXPApp());
}

class BeautyXPApp extends StatelessWidget {
  const BeautyXPApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeautyXP',
      debugShowCheckedModeBanner: false, // Removes the red "DEBUG" banner
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto', // Or whichever font you prefer
      ),
      home: const HomeScreen(), // This loads your beautiful UI first
    );
  }
}