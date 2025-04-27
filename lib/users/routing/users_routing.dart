
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../sub_admin/data_table_page/data_table.dart';
import '../../shared/utils/constants.dart';
import '../edit_template_page/editing_monthly_template.dart';
import '../home_page/ui/home_page_users.dart';
import '../monthly_template_page/monthly_template.dart';
import '../template_page/user_dashboard_page.dart';

class HomeLocationUsers extends BeamLocation{
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
    '/home/dashboard','/home/data_entry'];
}

class UserDashboardLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return  [const BeamPage(child: UserDashboardPage(),key: ValueKey('dashboard'),
        title: 'Activity Guide')];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/dashboard'];
}

class DatatableLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: MyTable(),title: appName,
        key: ValueKey('database'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/database','/home/database'];

}

class MonthlyTemplateLocation extends BeamLocation{

  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: MonthlyTemplate(),key: ValueKey('template'),title: 'Activity Guide'),
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/template','/home/edit'];
}


class EditingMonthlyTemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: EditingMonthlyTemplate(),key: ValueKey('data_entry'),title: 'Activity Guide')];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/data_entry'];

}