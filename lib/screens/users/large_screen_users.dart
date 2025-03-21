import 'package:activity_guide/routing/dashboard_location.dart';
import 'package:activity_guide/routing/editing_template_location.dart';
import 'package:activity_guide/routing/monthly_template_location.dart';
import 'package:activity_guide/routing/users_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../routing/mytable_location.dart';
import '../../routing/template_builder_location.dart';

class LargeScreenUsers extends StatelessWidget {
  final _beamerKey = GlobalKey<BeamerState>();
  Widget sideMenu;
  LargeScreenUsers({super.key,required this.sideMenu});


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        sideMenu,
        Expanded(flex: 5,
          child: Beamer(routerDelegate: BeamerDelegate(locationBuilder:
          BeamerLocationBuilder(beamLocations: [
           MonthlyTemplateLocation(),
            DashboardLocation(),
            DatatableLocation(),EditingMonthlyTemplateLocation()
          ]),transitionDelegate: NoAnimationTransitionDelegate()),key: _beamerKey,),)
      ],
    ) ;
  }
}


