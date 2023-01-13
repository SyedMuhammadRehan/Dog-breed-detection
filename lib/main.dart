import 'package:camera/camera.dart';
import 'package:dog_breed_detection/resources/routesmanager.dart';
import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:dog_breed_detection/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutGenerator.getRoute,
      initialRoute: Routes.splashscreen,
      title: AppStrings.splashtext,
      home: SplashScreen(),
    );
  }
}
