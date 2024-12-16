import 'package:activity_guide/screens/admin/template/template_builder2.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class TemplateLocation2 extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    // TODO: implement buildPages
    return [
      BeamPage(child: TemplateBuilder2(),
          key: ValueKey('template'),title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/template'];

}