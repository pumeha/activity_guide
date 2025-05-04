import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../../routing/users_routing.dart';

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
           UserLandingPageLocation(),DataCollectionPageLocation(),
            UserDashboardLocation(),
            DatatableLocation(),EditingMonthlyTemplateLocation()
          ]),transitionDelegate: NoAnimationTransitionDelegate()),key: _beamerKey,),)
      ],
    ) ;
  }
}


