import 'package:activity_guide/sub_admin/dashboard_page/cubit/dashboard_cubit.dart';
import 'package:activity_guide/sub_admin/dashboard_page/repository/dashboard_repository_impl.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_bloc.dart';
import 'package:activity_guide/sub_admin/template_list_page/repository/template_repo_impl.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/authentication/routing/login_location.dart';

import 'sub_admin/routing/admin_routing.dart';
import 'admin/bloc/user_bloc.dart';
import 'admin/repository/users_repo_impl.dart';
import 'shared/utils/colors.dart';
import 'users/routing/users_routing.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Beamer.setPathUrlStrategy(); // it removes the # in the url

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthCubit(AuthRepositoryImpl()),),
      BlocProvider(create: (_)=> BuilderBloc()),
      BlocProvider(create: (context)=> DashboardCubit(DashboardRepositoryImpl())),
      BlocProvider(create: (_)=> UserBloc(UsersRepoImpl())),
      BlocProvider(create: (_)=> TemplateBloc(TemplateRepoImpl()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(beamLocations: [
      LoginLocation(),AccountVerificationLocation(),ForgetPasswordLocation(),NewPasswordLocation(),
      AdminHomeLocation(),
      HomeLocationUsers(),
      SuperAdminLocation()
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
