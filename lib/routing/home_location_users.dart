import 'package:activity_guide/screens/users/home_page_users.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(child: HomePageUsers(), title: 'Activity Guide',
          key: ValueKey('home'))
    ];
  }
//08038891933
  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home','/home/template','/home/database',
    '/home/dashboard'];


}
