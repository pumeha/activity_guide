import 'package:activity_guide/screens/users/feedback_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedbackLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    // TODO: implement buildPages
   return [BeamPage(child: FeedbackPage(),key: ValueKey('feedback'),title: 'Activity Guide')];
  }

  @override
  List<Pattern> get pathPatterns => ['/admin/feedback'];
}
