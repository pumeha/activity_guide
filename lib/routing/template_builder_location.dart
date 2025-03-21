import 'package:activity_guide/screens/admin/template/template_builder.dart';
import 'package:activity_guide/screens/admin/template/template_builder2.dart';
import 'package:activity_guide/screens/onboarding/responsiveness.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class TemplateBuilderLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable state) {
    // TODO: implement buildPages
    return [
      BeamPage(child: ResponsiveWidget.isLargeScreen(context) ?
      TemplateBuilder() : TemplateBuilder2(),
      key: ValueKey('builder'),title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/builder'];

}