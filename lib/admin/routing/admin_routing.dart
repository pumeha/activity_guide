
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:activity_guide/admin/users_page/users_page.dart';
import '../../shared/responsiveness.dart';
import '../../shared/utils/constants.dart';
import '../preview_view_page/preview_template.dart';
import '../template_builder_page/view/template_builder.dart';
import '../../admin/home_page/ui/home_page_admin.dart';

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
    '/admin/dashboard','/admin/database','admin/users','/admin/templates','/admin/preview_template'];

}

class UsersLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: UsersPage(),title: appName,key: ValueKey('users'))];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/users'];

}



class TemplateBuilderLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {

    return [
      BeamPage(child: ResponsiveWidget.isLargeScreen(context) ?
      TemplateBuilder() : TemplateBuilder(),
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