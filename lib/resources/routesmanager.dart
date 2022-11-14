import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:dog_breed_detection/screens/home.dart';
import 'package:dog_breed_detection/screens/image_detection.dart';
import 'package:dog_breed_detection/screens/live_detection.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Routes {
  static const String splashscreen = '/';
  static const String home = 'home';
  static const String main = 'main';
  static const String live = 'live';
}

class RoutGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splashscreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const Home(),
        );
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );
      case Routes.live:
        return MaterialPageRoute(
          builder: (_) => const Communication(),
        );

      default:
        return undefinedNameRoute();
    }
  }

  static Route<dynamic> undefinedNameRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(
              body: Text(AppStrings.noRoute),
            ));
  }
}
