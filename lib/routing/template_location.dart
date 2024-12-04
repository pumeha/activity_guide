import 'package:activity_guide/screens/admin/template/template_builder.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class TemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    // TODO: implement buildPages
    return [
      BeamPage(child: TemplateBuilder(),
      key: ValueKey('template'),title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/template'];

}