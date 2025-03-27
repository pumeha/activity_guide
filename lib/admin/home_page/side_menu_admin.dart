import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beamer/beamer.dart';
import '../../theme/styles.dart';
import 'navigation_items_admin.dart';

class SideMenuAdmin extends StatefulWidget {
  const SideMenuAdmin({super.key});

  @override
  State<SideMenuAdmin> createState() => _SideMenuAdminState();
}

class _SideMenuAdminState extends State<SideMenuAdmin> {
  int activeTab = 0;
  List<String> iconNames = ['Templates','Dashboard',
                              'Database','Users'];
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 80),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child:   Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: NavigationItemsAdmin.values
              .map(
                (e) => NavigationButton(
              onPressed: () {
                setState(() {
                  activeTab = e.index;
                  switch(e.index){
                    case 0:
                      Beamer.of(context).beamToNamed(
                          '/admin/templates');
                      break;
                    case 1:
                      Beamer.of(context).beamToNamed(
                          '/admin/dashboard');
                      break;
                    case 2:
                      Beamer.of(context).beamToNamed('/admin/database');
                      break;
                    case 3:
                      Beamer.of(context).beamToNamed('/admin/users');
                      break;

                    default:
                      Beamer.of(context).beamToNamed(
                          '/admin/templates');

                      break;

                  }
                });
              },
              icon: e.icon,
              isActive: e.index == activeTab,
                  tooltip: iconNames[e.index],
            ),
          )
              .toList(),
        )

    );
  }
}



class NavigationButton extends StatelessWidget {
  const NavigationButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.isActive = false, required this.tooltip,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool isActive;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.2)
            : Styles.defaultLightWhiteColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.green[800] : Colors.grey,
        ),
        tooltip: tooltip,
      ),
    );
  }
}
