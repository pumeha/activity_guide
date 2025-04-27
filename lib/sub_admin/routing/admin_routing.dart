import 'package:activity_guide/sub_admin/dashboard_page/dashboard_page.dart';
import 'package:activity_guide/sub_admin/template_builder_page/view/template_builder_update.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../shared/utils/constants.dart';
import '../preview_view_page/preview_template.dart';
import '../../admin/view/super_admin_page.dart';
import '../template_builder_page/view/template_builder.dart';
import '../home_page/ui/home_page_admin.dart';

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
  List<Pattern> get pathPatterns => ['/admin','/admin/builder','/admin/update_template',
    '/admin/dashboard','/admin/database','/admin/templates','/admin/preview_template'];
}

class SuperAdminLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: SuperAdminPage(),title: appName,key: ValueKey('super_admin'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/super_admin'];

}



class TemplateBuilderLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {

    return [
      const BeamPage(child: TemplateBuilder(),
          key: ValueKey('builder'),title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/builder'];

}

class PreviewTemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: PreviewTemplate(),title: appName,key: ValueKey('preview_template'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/preview_template'];

}

class DashboardLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child:   DashboardPage(),title: appName,key: ValueKey('dashboard_page'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/dashboard'];

}

class EditTemplateLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    return [BeamPage(child: TemplateBuilderUpdate(),title: appName,key: ValueKey('update_template'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/update_template'];
  
}