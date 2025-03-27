
import 'package:activity_guide/users/home_page/large_screen_users.dart';
import 'package:activity_guide/users/home_page/small_screen_users.dart';
import 'package:activity_guide/shared/top_nav.dart';
import 'package:activity_guide/users/home_page/side_menu_users.dart';
import 'package:flutter/material.dart';

import '../../shared/responsiveness.dart';


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
