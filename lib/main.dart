import 'package:activity_guide/shared/theme/styles.dart';
import 'package:activity_guide/shared/theme_mode_bloc/theme_bloc.dart';
import 'package:activity_guide/shared/theme_mode_bloc/theme_event_et_state.dart';
import 'package:activity_guide/sub_admin/dashboard_page/cubit/dashboard_cubit.dart';
import 'package:activity_guide/sub_admin/dashboard_page/repository/dashboard_repository_impl.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_bloc.dart';
import 'package:activity_guide/sub_admin/template_list_page/repository/template_repo_impl.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_bloc.dart';
import 'package:activity_guide/users/edit_data_collection/bloc/edit_data_collection_bloc.dart';
import 'package:activity_guide/users/edit_data_collection/repo/edit_repo_impl.dart';
import 'package:activity_guide/users/home_page/cubit/user_home_cubit.dart';
import 'package:activity_guide/users/home_page/repo/user_home_impl.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:activity_guide/authentication/repository/auth_repository_impl.dart';
import 'package:activity_guide/authentication/routing/login_location.dart';

import 'sub_admin/routing/admin_routing.dart';
import 'admin/bloc/user_bloc.dart';
import 'admin/repository/users_repo_impl.dart';
import 'users/routing/users_routing.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Beamer.setPathUrlStrategy(); // it removes the # in the url

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthCubit(AuthRepositoryImpl()),
      ),
      BlocProvider(create: (_) => BuilderBloc()),
      BlocProvider(create: (_) => DashboardCubit(DashboardRepositoryImpl())),
      BlocProvider(create: (_) => UserBloc(UsersRepoImpl())),
      BlocProvider(create: (_) => TemplateBloc(TemplateRepoImpl())),
      BlocProvider(create: (_) => DataCollectionBloc()),
      BlocProvider(create: (_) => EditDataCollectionBloc(EditRepoImpl())),
      BlocProvider(create: (_) => UserHomeCubit(UserHomeImpl())),
      BlocProvider(create: (_) => UserDashboardCubit()),
      BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme()))
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(beamLocations: [
      LoginLocation(),
      AccountVerificationLocation(),
      ForgetPasswordLocation(),
      NewPasswordLocation(),
      AdminHomeLocation(),
      HomeLocationUsers(),
      SuperAdminLocation()
    ]),
    transitionDelegate: const NoAnimationTransitionDelegate(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Activity Guide',
          darkTheme: Styles.darkTheme,
          theme: Styles.lightTheme,
          themeMode: state.themeMode,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          routerDelegate: _routerDelegate,
          routeInformationParser: BeamerParser(),
        );
      },
    );
  }
}
