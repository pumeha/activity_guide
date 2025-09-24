import 'package:activity_guide/users/dashboard_page/custom_dashboard_page.dart';
import 'package:activity_guide/users/home_page/ui/user_landing_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../sub_admin/data_table_page/data_table.dart';
import '../../shared/utils/constants.dart';
import '../edit_data_collection/edit_data_collection_page.dart';
import '../home_page/ui/home_page_users.dart';
import '../data_collection_page/data_collection_page.dart';
import '../dashboard_page/user_dashboard_page.dart';

class HomeLocationUsers extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(
          child: HomePageUsers(),
          title: 'Activity Guide',
          key: ValueKey('home'))
    ];
  }

//08038891933
  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => [
        '/home',
        '/home/template',
        '/home/database',
        '/home/dashboard',
        '/home/data_entry',
        '/home/landing_page'
      ];
}

class UserDashboardLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(
          child: CustomDashboardPage(),
          key: ValueKey('dashboard'),
          title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/dashboard'];
}

class DatatableLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(
          child: MyTable(), title: appName, key: ValueKey('database'))
    ];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/database', '/home/database'];
}

class DataCollectionPageLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      BeamPage(
          child: DataCollectionPage(),
          key: ValueKey('template'),
          title: 'Activity Guide'),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/template', '/home/edit'];
}

class EditingMonthlyTemplateLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(
          child: EditDataCollectionPage(),
          key: ValueKey('data_entry'),
          title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/data_entry'];
}

class UserLandingPageLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    return [
      const BeamPage(
          child: UserLandingPage(), title: appName, key: ValueKey('landing'))
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/landing_page'];
}
