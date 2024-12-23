import 'package:activity_guide/screens/users/dashboard_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class DashboardLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
  return  [BeamPage(child: DashboardPage(),key: ValueKey('dashboard'),
  title: 'Activity Guide')];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/dashboard','/admin/dashboard'];

}