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
          Container(
            height: mq.size.height - 56,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft,
                    //end: Alignment.bottomRight,
                    colors: [
                  const Color.fromARGB(255, 148, 166, 247).withOpacity(.1),
                  Colors.white
                ])),
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Hero(
                    tag: "logo",
                    child: Image.asset(
                      'assets/transparent_logo.png',
                      color: Colors.black,
                      height: 100,
                      width: 100,
                    )),
                const SizedBox(height: 10),
                SizedBox(
                  height: mq.size.height - 290,
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
                          Image.asset(
                            onboardingElements[index]['image'],
                            height: 380,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 40),
                            child: StText(
                              onboardingElements[index]['title'],
                              align: TextAlign.center,
                              size: 24,
                              height: 1.4,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Transform.scale(
                    scale: 1.2,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 10, left: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: primaryColor),
                          height: 10,
                          width: currentIndex == i ? 60 : 10,
                        );
                      },
                      itemCount: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: Container(
                height: 56,
                padding: const EdgeInsets.only(top: 2, left: 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: primaryColor),
                width: mq.size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    StText("Get Started  ", size: 20, color: Colors.white),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 20, color: Colors.white)
                  ],
                )),
          )
        ],
      ),
    );
  }
}
