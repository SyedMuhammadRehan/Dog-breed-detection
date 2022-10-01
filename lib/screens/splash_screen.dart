import 'package:dog_breed_detection/resources/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                child: SvgPicture.asset(ImageAssets.logo, fit: BoxFit.fill)),
            // AnimatedTextKit(
            //   animatedTexts: [
            //     TypewriterAnimatedText('Dogs Breed Detection',
            //         textStyle: TextStyle(color: ColorManager.primary)),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
