import 'package:dog_breed_detection/resources/stylesmanager.dart';
import 'package:dog_breed_detection/resources/valuemanager.dart';
import 'package:flutter/material.dart';

import 'colormanager.dart';
import 'fontsmanager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primaryColor: ColorManager.primary,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppSize.s4,
        color: ColorManager.primary,
        titleTextStyle: regularTextStyle(
            color: ColorManager.white, fontSize: FontSize.s16)),
  );
}




// import 'package:flutter/material.dart';

// import 'colormanager.dart';
// import 'fontsmanager.dart';
// import 'valuemanager.dart';

// ThemeData getApplicationTheme() {
//   return ThemeData(
//     bottomSheetTheme:
//         BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0.0)),

// //main colors of ther app
//     primaryColor: ColorManager.primary,
//     primaryColorLight: ColorManager.primaryOpacity70,
//     primaryColorDark: ColorManager.darkprimary,
//     disabledColor: ColorManager.grey1,
// //riple color
//     splashColor: ColorManager.white,
// //cardview theme
//     cardTheme: CardTheme(
//       color: ColorManager.white,
//       shadowColor: ColorManager.grey,
//       elevation: AppSize.s4,
//     ), //App Bar theme
//     appBarTheme: AppBarTheme(
//         centerTitle: true,
//         elevation: AppSize.s4,
//         shadowColor: ColorManager.primaryOpacity70,
//         color: ColorManager.primary,
//         titleTextStyle: regularTextStyle(
//             color: ColorManager.white, fontSize: FontSize.s16)),

// //ButtonTheme
//     buttonTheme: ButtonThemeData(
//         shape: const StadiumBorder(),
//         disabledColor: ColorManager.grey1,
//         buttonColor: ColorManager.primary,
//         splashColor: ColorManager.primaryOpacity70),
// //elevated button
//     elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//             textStyle: regularTextStyle(
//               color: ColorManager.white,
//             ),
//             primary: ColorManager.primary,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppSize.s12)))),
// //TextTheme
//     textTheme: TextTheme(
//       headline3: semiBoldTextStyle(
//           color: ColorManager.primary, fontSize: FontSize.s28),
//       headline1: semiBoldTextStyle(
//           color: ColorManager.primary, fontSize: FontSize.s24),
//       headline2:
//           semiBoldTextStyle(color: ColorManager.grey1, fontSize: FontSize.s20),
//       subtitle1:
//           boldTextStyle(color: ColorManager.black, fontSize: FontSize.s16),
//       subtitle2: mediumTextStyle2(
//           color: ColorManager.black,
//           fontSize: FontSize.s14,
//           fontStyle: FontStyle.italic),
//       overline:
//           mediumTextStyle(color: ColorManager.primary, fontSize: FontSize.s14),
//       caption: regularTextStyle(color: ColorManager.grey),
//       bodyText1: regularTextStyle(color: ColorManager.primary),
//       headline4:
//           boldTextStyle(color: ColorManager.white, fontSize: FontSize.s16),
//       headline5: regularTextStyle2(
//         color: ColorManager.white,
//         fontSize: FontSize.s14,
//       ),
//     ),

//     inputDecorationTheme: InputDecorationTheme(
//       contentPadding: const EdgeInsets.all(AppPadding.p8),
//       hintStyle: regularTextStyle(color: ColorManager.grey1),
//       labelStyle: mediumTextStyle(color: ColorManager.darkgrey),
//       errorStyle: regularTextStyle(color: ColorManager.error),
// //enable border
//       enabledBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//         borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//         borderSide:
//             BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//         borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(AppSize.s8),
//         ),
//         borderSide:
//             BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
//       ),
//     ),
//     colorScheme:
//         ColorScheme.fromSwatch().copyWith(secondary: ColorManager.grey),
// //inputDecoration Theme
//   );
// }
