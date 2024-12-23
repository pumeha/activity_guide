
import 'package:activity_guide/routing/feedback_location.dart';
import 'package:activity_guide/routing/home_location.dart';
import 'package:activity_guide/routing/home_location_admin.dart';
import 'package:activity_guide/routing/login_location.dart';
import 'package:activity_guide/routing/splash_location.dart';
import 'package:activity_guide/routing/template_builder_location.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'providers/template_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beamer/beamer.dart';

void main() {

  Beamer.setPathUrlStrategy();// it removes the # in the url
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=> TemplateProvider()),
  ],child:  MyApp(),));

}

class MyApp extends StatelessWidget {
   MyApp({super.key});
   final _routerDelegate = BeamerDelegate(locationBuilder: BeamerLocationBuilder(
       beamLocations: [SplashLocation(),LoginLocation(),AdminHomeLocation(),
         HomeLocation()]
   ),
   );

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Activity Guide',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: active
        ),
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          })
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
     //home: LandingPage(),
     routerDelegate: _routerDelegate,
     routeInformationParser: BeamerParser(),
    );
  }
}


