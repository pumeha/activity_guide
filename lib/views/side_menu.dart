import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:beamer/beamer.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

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
            Beamer.of(context).beamToNamed('/home/welcome',replaceRouteInformation: true);
            },),
          ListTile( hoverColor: active,
            leading: const Icon(Icons.edit,color: active,),
            title: const Text('Template Builder'),
            onTap: () {
            Beamer.of(context).beamToNamed('/home/template',replaceRouteInformation: true);
            },
          ),
          ListTile(hoverColor: active,
            leading: const Icon(Icons.dashboard,color: active,),
            title: const Text('Dashboard'),
            onTap: () {
              Beamer.of(context).beamToNamed('/home/dashboard',replaceRouteInformation: true);

            },
          ),
          ListTile(hoverColor: active,
            leading: const Icon(Icons.notifications_active,color: active,),
            title: const Text('Notification'),
            onTap: () {
              Beamer.of(context).beamToNamed('/home/notification',replaceRouteInformation: true);

            },
          ),
          ListTile(hoverColor: active,
            leading: Icon(Icons.feedback,color: active,),
            title: Text('Feedback'),
            onTap: (){
              Beamer.of(context).beamToNamed('/home/feedback',
              replaceRouteInformation: true);
            },
          )
        ],
      ),
    );
  }

}



