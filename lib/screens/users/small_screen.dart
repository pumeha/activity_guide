import 'package:activity_guide/routing/template_location.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../routing/dashboard_location.dart';
import '../../routing/feedback_location.dart';
import '../../routing/mytable_location.dart';
import '../../routing/notification_location.dart';
import '../../routing/template_builder_location2.dart';
import '../../routing/welcome_location2.dart';

class SmallScreen extends StatelessWidget {
   SmallScreen({super.key});
  final _beamerKey = GlobalKey<BeamerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Beamer(routerDelegate: BeamerDelegate(locationBuilder: BeamerLocationBuilder(beamLocations: [
        WelcomeLocation2(),TemplateLocation(),TemplateBuilderLocation2(),DashboardLocation(),NotificationLocation(),
        FeedbackLocation(),DatatableLocation()
      ])),key: _beamerKey,),
    );
  }
}