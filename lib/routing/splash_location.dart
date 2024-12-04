import 'package:activity_guide/screens/onboarding/landing_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {

    return [
      const BeamPage(child: LandingPage(),
          key: ValueKey('landing'),title: 'Activity Guide')
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/landing'];

}
