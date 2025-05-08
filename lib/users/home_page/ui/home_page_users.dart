import 'package:beamer/beamer.dart';
import 'package:activity_guide/user_profile.dart';
import 'package:activity_guide/users/home_page/ui/large_screen_users.dart';
import 'package:activity_guide/users/home_page/ui/small_screen_users.dart';
import 'package:activity_guide/shared/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/responsiveness.dart';
import '../../dashboard_page/cubit/user_dashboard_cubit.dart';
import 'side_menu_users.dart';


class HomePageUsers extends StatefulWidget {
  const HomePageUsers({super.key});

  @override
  State<HomePageUsers> createState() => _HomePageUsersState();
}

class _HomePageUsersState extends State<HomePageUsers> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const UserProfile(),
      onEndDrawerChanged:  (isOpened){
        final currentLocation = Beamer.of(context).currentBeamLocation;

        if (currentLocation.state.routeInformation.uri.toString() == '/home/dashboard') {
       
                if (isOpened) {
                context.read<UserDashboardCubit>().show(false);
                } else {
                  context.read<UserDashboardCubit>().show(true);
                }
                
        }
      },
      appBar: topNavigationBar(context: context,scaffoldKey: scaffoldKey),
     // extendBodyBehindAppBar: true,
      body: ResponsiveWidget(largeScreen: LargeScreenUsers(sideMenu: const SideMenuUsers(),),
          smallScreen: const SmallScreenUsers())
    );
  }
}
