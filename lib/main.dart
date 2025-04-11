import 'package:activity_guide/admin/dashboard_page/cubit/dashboard_cubit.dart';
import 'package:activity_guide/admin/dashboard_page/repository/dashboard_repository_impl.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:activity_guide/admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/authentication/routing/login_location.dart';

import 'admin/routing/admin_routing.dart';
import 'shared/utils/colors.dart';
import 'users/routing/users_routing.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Beamer.setPathUrlStrategy(); // it removes the # in the url
  // runApp(MultiProvider(providers: [
  //   ChangeNotifierProvider(create: (_)=> TemplateProvider()),
  // ],child:  MyApp(),));

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(AuthRepositoryImpl()),
      ),
      BlocProvider(create: (_)=> BuilderBloc()),
      BlocProvider(create: (context)=> DashboardCubit(DashboardRepositoryImpl()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(beamLocations: [
      LoginLocation(),
      AdminHomeLocation(),
      HomeLocationUsers()
    ]),
    transitionDelegate: const NoAnimationTransitionDelegate(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Activity Guide',
      theme: ThemeData(
          scaffoldBackgroundColor: light,
          colorScheme: ColorScheme.fromSeed(seedColor: active),
          useMaterial3: true,
          textSelectionTheme: const TextSelectionThemeData(cursorColor: active),
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          })),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerParser(),
    );
  }
}
