import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/providers/user_provider.dart';
import 'package:strangify/screens/listener_home.dart';
import 'package:strangify/screens/onboarding_screen.dart';

import '../providers/settings_provider.dart';
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
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
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
      await settingsProvider.refreshUser();
      await userProvider.refreshUser().then((value) => Navigator.of(context)
          .pushReplacementNamed(value?.role == 'speaker'
              ? HomeScreen.routeName
              : ListenerHomeScreen.routeName));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 10,
              child: Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    'assets/splash-bg.png',
                    width: size.width + 20,
                  )),
            ),
            Positioned(
              bottom: 40,
              child: Transform.scale(
                  scale: 1.1,
                  child: Image.asset(
                    'assets/Logo-01-01.png',
                    width: 60,
                  )),
            ),
          ],
        ));
  }
}
