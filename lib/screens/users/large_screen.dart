import 'package:activity_guide/routing/dashboard_location.dart';
import 'package:activity_guide/routing/feedback_location.dart';
import 'package:activity_guide/routing/notification_location.dart';
import 'package:activity_guide/routing/template_location.dart';
import 'package:activity_guide/routing/welcome_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../routing/mytable_location.dart';
import '../../routing/template_builder_location.dart';

class LargeScreen extends StatelessWidget {
  final _beamerKey = GlobalKey<BeamerState>();
  Widget sideMenu;
  LargeScreen({super.key,required this.sideMenu});


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(child: sideMenu),
        Expanded(flex: 5,
          child: Beamer(routerDelegate: BeamerDelegate(locationBuilder: BeamerLocationBuilder(beamLocations: [
            WelcomeLocation(),TemplateBuilderLocation(),TemplateLocation(),DashboardLocation(),NotificationLocation(),
            FeedbackLocation(),DatatableLocation()
          ])),key: _beamerKey,),)
      ],
    );
  }
}


