import 'package:activity_guide/screens/admin/template/preview_template.dart';
import 'package:activity_guide/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class PreviewTemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: PreviewTemplate(),title: appName,key: ValueKey('preview_template'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/preview_template'];
  
}