import 'package:activity_guide/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../screens/users/notification_page.dart';
class NotificationLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
   return [const BeamPage(child: NotificationPage(),
       title: appName,key: ValueKey('notification'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/notification'];

}

