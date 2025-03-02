import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beamer/beamer.dart';
import '../utils/navigation_items_users.dart';
import '../theme/styles.dart';

class SideMenuUsers extends StatefulWidget {

  const SideMenuUsers({super.key});

  @override
  State<SideMenuUsers> createState() => _SideMenuUsersState();
}

class _SideMenuUsersState extends State<SideMenuUsers> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 80),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      // margin: ResponsiveWidget.isLargeScreen(context)
      //     ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20)
      //     : const EdgeInsets.all(10),
      child:   Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: NavigationItemsUsers.values
                .map(
                  (e) => NavigationButton(
                onPressed: () {
                  setState(() {
                  activeTab = e.index;

                  switch(e.index){
                    case 0:
                      Beamer.of(context).beamToNamed('/home/template');
                      break;
                    case 1:
                      Beamer.of(context).beamToNamed('/home/dashboard');
                      break;
                    case 2:
                      Beamer.of(context).beamToNamed('/home/database');
                      break;
                    default:
                      Beamer.of(context).beamToNamed('/home/template');
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
