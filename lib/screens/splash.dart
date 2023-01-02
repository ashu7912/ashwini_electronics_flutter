import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ashwini_electronics/screens/login.dart';
import 'package:ashwini_electronics/screens/home_page.dart';

Widget _defaultHome = const LoginScreen();

class SplashScreen extends StatelessWidget {

  bool isLoggedIn;

  SplashScreen({required this.isLoggedIn});


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'images/app_logo.png',
      duration: 3000,
      nextScreen: (isLoggedIn) ? HomePage() : LoginScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
