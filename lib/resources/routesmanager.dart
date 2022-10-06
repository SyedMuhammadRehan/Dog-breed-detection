import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:dog_breed_detection/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Routes {
  static const String splashscreen = '/';
  static const String main = 'main';
}

class RoutGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splashscreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
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
