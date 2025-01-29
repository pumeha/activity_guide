import 'package:activity_guide/screens/users/large_screen.dart';
import 'package:activity_guide/screens/users/responsiveness.dart';
import 'package:activity_guide/screens/users/small_screen_admin.dart';
import 'package:activity_guide/screens/users/top_nav.dart';
import 'package:activity_guide/views/side_menu_admin.dart';
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
        body: ResponsiveWidget(largeScreen: LargeScreen(sideMenu: SideMenuAdmin(),),
            smallScreen: SmallScreenAdmin())
    );
  }
}
