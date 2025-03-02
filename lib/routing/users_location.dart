import 'package:activity_guide/screens/admin/users_page.dart';
import 'package:activity_guide/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class UsersLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: UsersPage(),title: appName,key: ValueKey('users'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/users'];
  
}