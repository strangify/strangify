import 'package:flutter/material.dart';
import 'package:strangify/models/user_model.dart';
import 'package:strangify/screens/become_a_listener_screen.dart';
import 'package:strangify/screens/onboarding_screen.dart';
import 'package:strangify/screens/under_review_screen.dart';
import 'package:strangify/screens/wallet_screen.dart';

import '../screens/call_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/listener_detail_screen.dart';
import '../screens/listener_home.dart';
import '../screens/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case ListenerHomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ListenerHomeScreen(),
        );
      case CallScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CallScreen(args: args as Map),
        );
      case WalletScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const WalletScreen(),
        );
      case ChatScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ChatScreen(args: args as Map),
        );
      case UnderReviewScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const UnderReviewScreen(),
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
          builder: (context) => BecomeAListenerScreen(isListener: args as bool),
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
