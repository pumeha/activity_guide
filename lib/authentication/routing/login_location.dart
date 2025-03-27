import 'package:activity_guide/authentication/authentication.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../shared/utils/constants.dart';

class LoginLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [BeamPage(child: AuthenticationPage(),key: ValueKey('login'),title: appName)];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/login'];

}