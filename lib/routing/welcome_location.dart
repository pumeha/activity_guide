import 'package:activity_guide/screens/onboarding/welcome_page.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
class WelcomeLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    // TODO: implement buildPages
    return [BeamPage(child: WelcomePage(),key: ValueKey('welcome'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/home/welcome'];

}