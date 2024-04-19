import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // for animated splash screen
      home: AnimatedSplashScreen(
        splash: const Icon(
          Icons.assignment_sharp,
          color: Colors.blue,
          size: 80.0,
        ),
        nextScreen: const HomeScreen(),
        duration: 1500,
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
