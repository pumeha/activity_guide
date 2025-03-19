import 'package:activity_guide/screens/users/editing_monthly_template.dart';
import 'package:activity_guide/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class EditingMonthlyTemplateLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
   return [const BeamPage(child: EditingMonthlyTemplate(),key: ValueKey('edit'),title: 'Activity Guide')];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/edit','/home/template'];

}