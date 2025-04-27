import 'package:flutter/material.dart';

import 'package:activity_guide/admin/view/users_page.dart';

import '../../shared/top_nav.dart';

class SuperAdminPage extends StatelessWidget {
 const SuperAdminPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topNavigationBar(context),
      body: const UsersPage(),
    );
  }
}
