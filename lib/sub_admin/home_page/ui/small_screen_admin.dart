
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../../users/routing/users_routing.dart';
import '../../routing/admin_routing.dart';
import '../../template_list_page/view/template_list_page.dart';

class SmallScreenAdmin extends StatefulWidget {
  const SmallScreenAdmin({super.key});

  @override
  State<SmallScreenAdmin> createState() => _SmallScreenAdminState();
}

class _SmallScreenAdminState extends State<SmallScreenAdmin> {
  final _beamerKey = GlobalKey<BeamerState>();
  late int _selectedIndex = 0;

  late BeamerDelegate _beamerDelegate;
  //void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    _beamerDelegate = BeamerDelegate(
        locationBuilder: BeamerLocationBuilder(beamLocations: [
          TemplatesListLocation(),
          DashboardLocation(),EditTemplateLocation(),
          DatatableLocation(),TemplateBuilderLocation(),PreviewTemplateLocation()
        ]),transitionDelegate: NoAnimationTransitionDelegate());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.edit_document),
            label: 'Templates',),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',)
        ],
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });

          switch (index) {

            case 0:
              Beamer.of(context).beamToNamed(
                  '/admin/templates');

              break;
            case 1:
              Beamer.of(context).beamToNamed(
                  '/admin/dashboard');
              break;
            default:
              Beamer.of(context).beamToNamed(
                  '/admin/templates');
              break;
          }
        },
       selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black,

      ),
      body: Beamer(routerDelegate: _beamerDelegate, key: _beamerKey,),
    );
  }
}
