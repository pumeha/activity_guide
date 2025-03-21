import 'package:activity_guide/old%20stuffs/template.dart';
import 'package:activity_guide/screens/users/monthly_template.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';


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
