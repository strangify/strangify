import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/screens/listener_home.dart';
import 'package:strangify/screens/onboarding_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    User? user = FirebaseAuth.instance.currentUser;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      prefs.setString(deviceToken, token);
    }
    if (user == null) {
      Future.delayed(const Duration(seconds: 3)).whenComplete(() =>
          Navigator.of(context)
              .pushReplacementNamed(OnboardingScreen.routeName));
    } else {
      await userProvider.refreshUser().then((value) => Navigator.of(context)
          .pushReplacementNamed(value?.role == 'speaker'
              ? HomeScreen.routeName
              : ListenerHomeScreen.routeName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: Hero(
              tag: "logo", child: Image.asset('assets/transparent_logo.png')),
        ));
  }
}
