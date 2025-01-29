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

class SmallScreen extends StatefulWidget {
  const SmallScreen({super.key});

  @override
  State<SmallScreen> createState() => _SmallScreenState();
}

class _SmallScreenState extends State<SmallScreen> {
  final _beamerKey = GlobalKey<BeamerState>();
  late int _selectedIndex = 0;
  final beamLocationMap = {
    WelcomeLocation2 : 0,
    TemplateLocation : 1,
    DashboardLocation : 2
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
        ]),
    transitionDelegate: NoAnimationTransitionDelegate());
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
            label: 'Template',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',),
        ],
        currentIndex: _selectedIndex
        ,

        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });

          switch (index) {
            case 0:
             _beamerKey.currentState!.routerDelegate.beamToNamed('/home/welcome');
              // Beamer.of(context).beamToNamed(
              //     '/home/welcome');

              break;
            case 1:
              _beamerKey.currentState!.routerDelegate.beamToNamed('/home/template');
              // Beamer.of(context).beamToNamed(
              //     '/home/template');

              break;
            case 2:
              _beamerKey.currentState!.routerDelegate.beamToNamed('/home/dashboard');
            //  Beamer.of(context).beamToNamed(
               //   '/home/dashboard');

            default:
              Beamer.of(context).beamToNamed(
                  '/home/welcome');

              break;
          }
        },
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black,

      ),
      body: Beamer(routerDelegate: _beamerDelegate, key: _beamerKey,
      ),
    );
  }
}
