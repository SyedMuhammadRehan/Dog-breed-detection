import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Routes {
  static const String splashscreen = '/';
}

class RoutGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splashscreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
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
