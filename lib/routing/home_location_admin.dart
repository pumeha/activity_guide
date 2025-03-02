import 'package:activity_guide/screens/admin/home_page_admin.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminHomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(child: HomePageAdmin(), title: 'Activity Guide',
          key: ValueKey('admin'))
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin','/admin/builder',
    '/admin/dashboard','/admin/database','admin/users'];

}
