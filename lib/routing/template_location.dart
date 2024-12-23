import 'package:activity_guide/screens/admin/template/template.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../screens/admin/template/preview_template.dart';
class TemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: Template(),key: ValueKey('template'),title: 'Activity Guide')];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/template'];

}
