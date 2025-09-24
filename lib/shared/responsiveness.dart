import 'package:flutter/material.dart';
const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;
const int customScreenSize = 1100;


class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget smallScreen;
  const ResponsiveWidget({super.key, required this.largeScreen,
  required this.smallScreen});

  static bool isSmallScreen(BuildContext c)=>
      MediaQuery.of(c).size.width < mediumScreenSize;

  static bool isMediumScreen(BuildContext c)=>
      MediaQuery.of(c).size.width >= mediumScreenSize &&
      MediaQuery.of(c).size.width < largeScreenSize;

  static bool isLargeScreen(BuildContext c)=>
      MediaQuery.of(c).size.width >= largeScreenSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,builder){
      double _width = builder.maxWidth;
      if(_width >= mediumScreenSize){
        return largeScreen;
      }else{
        return smallScreen ;
      }
    });
  }
}
