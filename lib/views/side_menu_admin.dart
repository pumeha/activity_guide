import 'package:activity_guide/screens/users/responsiveness.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beamer/beamer.dart';
import '../enums/navigation_items_admin.dart';
import '../theme/styles.dart';

class SideMenuAdmin extends StatefulWidget {
  const SideMenuAdmin({super.key});

  @override
  State<SideMenuAdmin> createState() => _SideMenuAdminState();
}

class _SideMenuAdminState extends State<SideMenuAdmin> {
  int activeTab = 0;
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
                      Beamer.of(context).beamToNamed('/admin/welcome');

                      break;
                    case 1:
                      Beamer.of(context).beamToNamed('/admin/builder');
                      break;
                    case 2:
                      Beamer.of(context).beamToNamed('/admin/dashboard');
                    case 3:
                      Beamer.of(context).beamToNamed('/admin/dataset');
                      break;

                    default:
                      Beamer.of(context).beamToNamed('/admin/welcome');
                      break;

                  }
                });
              },
              icon: e.icon,
              isActive: e.index == activeTab,
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
    this.isActive = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool isActive;

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
      ),
    );
  }
}
