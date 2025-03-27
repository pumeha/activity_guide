import 'side_menu_admin.dart';
import 'large_screen_admin.dart';
import 'small_screen_admin.dart';
import '../../../shared/top_nav.dart';
import 'package:flutter/material.dart';
import '../../../shared/responsiveness.dart';


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
