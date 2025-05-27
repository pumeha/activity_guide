import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class Styles {
  static Color scaffoldBackgroundColor = const Color(0xFFe0efff);
  static Color defaultRedColor = const Color(0xffff698a);
  static Color defaultYellowColor = const Color(0xFFfedd69);
  static Color defaultBlueColor = const Color(0xff52beff);
  static Color defaultGreyColor = const Color(0xff77839a);
  static Color defaultLightGreyColor = const Color(0xffc4c4c4);
  static Color defaultLightWhiteColor = const Color(0xFFf2f6fe);
  static Color darkBackground = Color.fromARGB(27, 75, 141, 117); 

  static double defaultPadding = 18.0;

  static BorderRadius defaultBorderRadius = BorderRadius.circular(20);


  static ThemeData lightTheme = ThemeData(
              scaffoldBackgroundColor: darkBackground,
              colorScheme: ColorScheme.fromSeed(seedColor: darkBackground, brightness: Brightness.light),
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(cursorColor: active),
              textTheme: GoogleFonts.mulishTextTheme().apply(bodyColor: Colors.black),
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                
              }));

      static ThemeData darkTheme = ThemeData(
              scaffoldBackgroundColor: darkBackground,
              colorScheme: ColorScheme.fromSeed(seedColor: defaultLightGreyColor,
               brightness: Brightness.dark),
              useMaterial3: true,
              textSelectionTheme: TextSelectionThemeData(cursorColor: active),
              textTheme: GoogleFonts.mulishTextTheme().apply(bodyColor: Colors.white),
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                
              }));
}
