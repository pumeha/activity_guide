import 'package:activity_guide/screens/admin/side_menu_admin.dart';
import 'package:activity_guide/screens/admin/large_screen_admin.dart';
import 'package:activity_guide/screens/onboarding/responsiveness.dart';
import 'package:activity_guide/screens/admin/small_screen_admin.dart';
import 'package:activity_guide/screens/users/top_nav.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageAdmin> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: topNavigationBar(context, scaffoldKey),
        // extendBodyBehindAppBar: true,
        body: ResponsiveWidget(largeScreen: LargeScreenAdmin(sideMenu: const SideMenuAdmin(),),
            smallScreen: const SmallScreenAdmin())
    );
  }
}
