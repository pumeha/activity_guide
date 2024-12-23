import 'package:activity_guide/screens/users/responsiveness.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beamer/beamer.dart';

class SideMenuAdmin extends StatelessWidget {
  const SideMenuAdmin({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white.withOpacity(0.9),
      child: ListView(
        children: [
          ListTile(hoverColor: active,
            leading: const Icon(Icons.home,color: active,),
            title: const Text('Home'),
            onTap: () {
              if(ResponsiveWidget.isSmallScreen(context)){
                Navigator.pop(context);
              }
              Beamer.of(context).beamToNamed('/admin/welcome',replaceRouteInformation: true);
            },),
          ListTile( hoverColor: active,
            leading: const Icon(Icons.edit,color: active,),
            title: const Text('Template Builder'),
            onTap: () {
              if(ResponsiveWidget.isSmallScreen(context)){
                Navigator.pop(context);
              }
              Beamer.of(context).beamToNamed('/admin/builder',replaceRouteInformation: true);
            },
          ),
          ListTile(hoverColor: active,
            leading: const Icon(Icons.dashboard,color: active,),
            title: const Text('Dashboard'),
            onTap: () {
              if(ResponsiveWidget.isSmallScreen(context)){
                Navigator.pop(context);
              }
              Beamer.of(context).beamToNamed('/admin/dashboard',replaceRouteInformation: true);

            },
          ),
          ListTile(hoverColor: active,
            leading: const Icon(Icons.notifications_active,color: active,),
            title: const Text('Notification'),
            onTap: () {
            if(ResponsiveWidget.isSmallScreen(context)){
              Navigator.pop(context);
            }
              Beamer.of(context).beamToNamed('/admin/notification',replaceRouteInformation: true);
            },
          ),
          ListTile(hoverColor: active,
            leading: const Icon(Icons.account_circle,color: active,),
            title: const Text('Users'),
            onTap: () {
              if(ResponsiveWidget.isSmallScreen(context)){
                Navigator.pop(context);
              }
              Beamer.of(context).beamToNamed('/admin/notification',replaceRouteInformation: true);
            },
          ),

          ListTile(hoverColor: active,
            leading: const Icon(Icons.dataset,color: active,),
              title: const Text('Dataset'),
            onTap: () {
              if(ResponsiveWidget.isSmallScreen(context)){
                Navigator.pop(context);
              }
              Beamer.of(context).beamToNamed('/admin/dataset',replaceRouteInformation: true);
            },
          ),

        ],
      ),
    );
  }

}