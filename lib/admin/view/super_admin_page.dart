import 'package:activity_guide/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:activity_guide/admin/view/users_page.dart';
import '../../shared/top_nav.dart';

class SuperAdminPage extends StatefulWidget {
  const SuperAdminPage({super.key});
  @override
  State<SuperAdminPage> createState() => _SuperAdminPageState();
}

class _SuperAdminPageState extends State<SuperAdminPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
          appBar: topNavigationBar(context: context, scaffoldKey: scaffoldKey),
      body: const UsersPage(),
      endDrawer: const UserProfile(),
    );
  }
}
