import 'package:flutter/material.dart';
import 'package:strangify/models/user_model.dart';
import 'package:strangify/screens/become_a_listener_screen.dart';
import 'package:strangify/screens/onboarding_screen.dart';
import 'package:strangify/screens/under_review_screen.dart';

import '../screens/call_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/listener_detail_screen.dart';
import '../screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case CallScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const CallScreen(),
        );
      case ChatScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ChatScreen(args: args as Map),
        );
      case UnderReviewScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => UnderReviewScreen(isFirstTime: args as bool),
        );
      // case RatingsScreen.routeName:
      //   return MaterialPageRoute(
      //     builder: (context) => RatingsScreen(args: args as Map),
      //   );
      case ListenerDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ListenerDetailScreen(user: args as User),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case OnboardingScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      case BecomeAListenerScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const BecomeAListenerScreen(),
        );
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('ERROR')),
          body: const Center(
            child: Text("Page not found"),
          ),
        );
      },
    );
  }
}
