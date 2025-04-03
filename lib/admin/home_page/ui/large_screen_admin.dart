
import 'package:activity_guide/admin/template_list_page/template_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../../../users/routing/users_routing.dart';
import '../../routing/admin_routing.dart';

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
            TemplatesListLocation(),
            DashboardLocation() ,
            DatatableLocation(),UsersLocation(),TemplateBuilderLocation(),PreviewTemplateLocation()
          ]),transitionDelegate: NoAnimationTransitionDelegate()),key: _beamerKey,),)
      ],
     );
  }
}


