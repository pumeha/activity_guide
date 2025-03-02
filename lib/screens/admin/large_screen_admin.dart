import 'package:activity_guide/routing/dashboard_location.dart';
import 'package:activity_guide/routing/template_location.dart';
import 'package:activity_guide/routing/users_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../routing/mytable_location.dart';
import '../../routing/template_builder_location.dart';

class LargeScreenAdmin extends StatelessWidget {
  final _beamerKey = GlobalKey<BeamerState>();
  Widget sideMenu;
  LargeScreenAdmin({super.key,required this.sideMenu});


  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        sideMenu,
        Expanded(flex: 5,
          child: Beamer(routerDelegate: BeamerDelegate(locationBuilder:
          BeamerLocationBuilder(beamLocations: [
           TemplateBuilderLocation(),
            DashboardLocation() ,
            DatatableLocation(),UsersLocation()
          ]),transitionDelegate: NoAnimationTransitionDelegate()),key: _beamerKey,),)
      ],
     ) ;
  }
}


