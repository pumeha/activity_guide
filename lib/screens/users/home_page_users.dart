import 'package:activity_guide/screens/admin/large_screen_admin.dart';
import 'package:activity_guide/screens/users/large_screen_users.dart';
import 'package:activity_guide/screens/onboarding/responsiveness.dart';
import 'package:activity_guide/screens/users/small_screen_users.dart';
import 'package:activity_guide/screens/users/top_nav.dart';
import 'package:activity_guide/screens/users/side_menu_users.dart';
import 'package:flutter/material.dart';

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
      appBar: topNavigationBar(context, scaffoldKey),
     // extendBodyBehindAppBar: true,
      body: ResponsiveWidget(largeScreen: LargeScreenUsers(sideMenu: const SideMenuUsers(),),
          smallScreen: const SmallScreenUsers())
    );
  }
}
