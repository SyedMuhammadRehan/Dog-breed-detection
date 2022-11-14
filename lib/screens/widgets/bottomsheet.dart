import 'dart:io';

import 'package:flutter/material.dart';

import '../../resources/assets.dart';
import '../../resources/colormanager.dart';
import '../../resources/fontsmanager.dart';
import '../../resources/sizeconfig.dart';

class ReusableBottomSheet {
  var context = BuildContext;
  static
  
  
   void showbottomsheet(
      BuildContext context, File imageFile, String result) {
    showModalBottomSheet(
        elevation: 50,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Colors.transparent,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      ImageAssets.bottom,
                    ))),
            child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.white.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Container(
                      height: getProportionateScreenHeight(250),
                      width: getProportionateScreenWidth(250),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorManager.primary, width: 10),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            foregroundImage: Image.file(imageFile).image,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Card(
                      color: ColorManager.primary,
                      shadowColor: ColorManager.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 20,
                      child: ListTile(
                        dense: true,
                        focusColor: ColorManager.white,
                        leading: Text(
                          "DOG BREED:",
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s18,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                          result,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s18),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
