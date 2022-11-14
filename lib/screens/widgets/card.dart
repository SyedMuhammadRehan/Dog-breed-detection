// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../resources/assets.dart';
import '../../resources/colormanager.dart';
import '../../resources/fontsmanager.dart';

class HomeCard extends StatelessWidget {
  final String name;
  final String route;
  const HomeCard({
    Key? key,
    required this.name,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: ColorManager.white.withOpacity(0.7)),
        child: ListTile(
          selectedColor: ColorManager.primary,
          onTap: (() {
            Navigator.pushNamed(context, route);
          }),
          textColor: ColorManager.primary,
          title: Text(
            name,
            style: const TextStyle(
                fontSize: FontSize.s18, fontWeight: FontWeightManager.medium),
          ),
          leading: Image.asset(ImageAssets.stackimage),
          trailing: Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.11,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.primary.withOpacity(0.3),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: ColorManager.primary,
                ),
              )),
        ),
      ),
    );
  }
}
