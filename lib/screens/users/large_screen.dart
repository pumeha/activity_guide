import 'package:activity_guide/routing/dashboard_location.dart';
import 'package:activity_guide/routing/feedback_location.dart';
import 'package:activity_guide/routing/notification_location.dart';
import 'package:activity_guide/routing/welcome_location.dart';
import 'package:activity_guide/views/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../../routing/home_location.dart';
import '../../routing/template_location.dart';

class LargeScreen extends StatelessWidget {
  final _beamerKey = GlobalKey<BeamerState>();
  LargeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(child: SideMenu()),
        Expanded(flex: 5,
          child: Beamer(routerDelegate: BeamerDelegate(locationBuilder: BeamerLocationBuilder(beamLocations: [
            WelcomeLocation(),TemplateLocation(),DashboardLocation(),NotificationLocation(),
            FeedbackLocation()
          ])),key: _beamerKey,),)
      ],
    );
  }
}
