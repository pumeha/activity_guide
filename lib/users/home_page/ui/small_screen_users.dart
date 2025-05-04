
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../../routing/users_routing.dart';

class SmallScreenUsers extends StatefulWidget {
  const SmallScreenUsers({super.key});

  @override
  State<SmallScreenUsers> createState() => _SmallScreenUsersState();
}

class _SmallScreenUsersState extends State<SmallScreenUsers> {
  final _beamerKey = GlobalKey<BeamerState>();
  late int _selectedIndex = 0;

  late BeamerDelegate _beamerDelegate;
  //void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();

    _beamerDelegate = BeamerDelegate(
        locationBuilder: BeamerLocationBuilder(beamLocations: [
         UserLandingPageLocation(), DataCollectionPageLocation(),
          UserDashboardLocation(),
          DatatableLocation(),EditingMonthlyTemplateLocation()
        ]),
    transitionDelegate: const NoAnimationTransitionDelegate());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // BottomNavigationBarItem(icon: Text('W',style: TextStyle(fontSize: 16,color: Colors.black,
          // fontWeight: FontWeight.bold),),
          //   label: 'Workplan',
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.home),
            label: 'Home',
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

              _beamerKey.currentState!.routerDelegate.beamToNamed('/home/landing_page');
              // Beamer.of(context).beamToNamed(
              //     '/home/template');
              break;
            case 1:
              _beamerKey.currentState!.routerDelegate.beamToNamed('/home/dashboard');
              break;
            default:
              Beamer.of(context).beamToNamed(
                  '/home/landing_page');

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
