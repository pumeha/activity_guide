import 'package:activity_guide/screens/onboarding/welcome_page2.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class WelcomeLocation2 extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    // TODO: implement buildPages
    return [BeamPage(child: WelcomePage2(),key: ValueKey('welcome'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/welcome'];

}