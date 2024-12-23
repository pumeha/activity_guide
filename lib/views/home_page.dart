import 'package:activity_guide/screens/users/large_screen.dart';
import 'package:activity_guide/screens/users/responsiveness.dart';
import 'package:activity_guide/screens/users/small_screen.dart';
import 'package:activity_guide/screens/users/top_nav.dart';
import 'package:activity_guide/views/side_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: SideMenu()),
      appBar: topNavigationBar(context, scaffoldKey),
     // extendBodyBehindAppBar: true,
      body: ResponsiveWidget(largeScreen: LargeScreen(sideMenu: SideMenu(),), smallScreen: SmallScreen())
    );
  }
}
