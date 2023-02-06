import 'package:flutter/material.dart';
import 'package:strangify/constants.dart';
import 'package:strangify/screens/login_screen.dart';

import '../widgets/st_text.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = "/OnboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Hero(
          //     tag: "logo",
          //     child: Image.asset(
          //       'assets/transparent_logo.png',
          //       color: Colors.black,
          //       height: 100,
          //       width: 100,
          //     )),
          // const SizedBox(height: 10),
          SizedBox(
            height: mq.size.height - 100,
            child: PageView.builder(
              onPageChanged: (int i) {
                setState(() {
                  currentIndex = i;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Image.asset(
                        onboardingElements[index]['image'],
                        width: mq.size.width + 20,
                        height: mq.size.height - 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 10),
                        child: Transform.scale(
                            scale: 1.1,
                            child: Image.asset(
                              'assets/Logo-01-01.png',
                              width: 50,
                            ))),
                    StText(onboardingElements[index]['title'],
                        align: TextAlign.center,
                        size: 18,
                        color: primaryColor,
                        spacing: 0,
                        weight: FontWeight.w600,
                        height: 1.4)
                  ],
                );
              },
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: primaryColor),
                width: 200,
                child: StText("Get Started",
                    size: 18,
                    weight: FontWeight.bold,
                    spacing: 1,
                    color: Colors.white)),
          ),
          SizedBox(
            height: 35,
            child: Transform.scale(
              scale: 1.2,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor),
                    height: 5,
                    width: currentIndex == i ? 50 : 5,
                  );
                },
                itemCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
