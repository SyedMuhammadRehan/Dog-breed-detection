import 'package:dog_breed_detection/resources/assets.dart';
import 'package:dog_breed_detection/resources/colormanager.dart';
import 'package:dog_breed_detection/resources/fontsmanager.dart';
import 'package:dog_breed_detection/resources/sizeconfig.dart';
import 'package:dog_breed_detection/resources/stringmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../resources/routesmanager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startdelay();
  }

  _startdelay() {
    Future.delayed(const Duration(seconds: 5), _gonext);
  }

  _gonext() {
    Navigator.pushReplacementNamed(
      context,
      Routes.main,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: getProportionateScreenHeight(300),
                width: getProportionateScreenWidth(230),
                child: SvgPicture.asset(ImageAssets.logo, fit: BoxFit.fill)),
            Text(
              AppStrings.splashtext,
              style: TextStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s20,
                  fontWeight: FontWeightManager.bold),
            )
          ],
        ),
      ),
    );
  }
}
