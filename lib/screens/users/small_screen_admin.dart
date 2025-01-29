import 'package:activity_guide/routing/template_location.dart';
import 'package:activity_guide/routing/welcome_location.dart';
import 'package:activity_guide/theme/styles.dart';
import 'package:activity_guide/views/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../routing/dashboard_location.dart';
import '../../routing/mytable_location.dart';
import '../../routing/notification_location.dart';
import '../../routing/template_builder_location2.dart';
import '../../routing/welcome_location2.dart';

class SmallScreenAdmin extends StatefulWidget {
  const SmallScreenAdmin({super.key});

  @override
  State<SmallScreenAdmin> createState() => _SmallScreenAdminState();
}

class _SmallScreenAdminState extends State<SmallScreenAdmin> {
  final _beamerKey = GlobalKey<BeamerState>();
  late int _selectedIndex = 0;
  final beamLocationMap = {
    WelcomeLocation2 : 0,
    TemplateBuilderLocation2 : 1,
    DashboardLocation : 2,
    DatatableLocation :3
  };
  late BeamerDelegate _beamerDelegate;
  //void _setStateListener() => setState(() {});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_beamerDelegate = _beamerKey.currentState!.routerDelegate;
    //_beamerDelegate.addListener(_setStateListener);
    _beamerDelegate = BeamerDelegate(
        locationBuilder: BeamerLocationBuilder(beamLocations: [
          WelcomeLocation2(),
          TemplateLocation(),
          TemplateBuilderLocation2(),
          DashboardLocation(),
          NotificationLocation(),
          DatatableLocation()
        ]));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.edit_document),
            label: 'Builder',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',),
          BottomNavigationBarItem(icon: Icon(Icons.dataset),label: 'Database')
        ],
        currentIndex: _selectedIndex
        ,

        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });

          switch (index) {
            case 0:
              Beamer.of(context).beamToNamed(
                  '/admin/welcome');

              break;
            case 1:
              Beamer.of(context).beamToNamed(
                  '/admin/builder');

              break;
            case 2:
              Beamer.of(context).beamToNamed(
                  '/admin/dashboard');
            case 3:
              Beamer.of(context).beamToNamed('/admin/dataset');
              break;

            default:
              Beamer.of(context).beamToNamed(
                  '/admin/welcome');

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
