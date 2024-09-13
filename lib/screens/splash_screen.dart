import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'home_screen.dart'; // Import your HomeScreen

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: const HomeScreen(),
      duration: 4000,
      imageSize: 300,
      imageSrc: 'assets/logo.png',
   
      backgroundColor: const Color(0xFF0D47A1),
    );
  }
}
