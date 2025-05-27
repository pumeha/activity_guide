import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beamer/beamer.dart';

import '../users/dashboard_page/cubit/user_dashboard_state.dart';
import 'theme_mode_bloc/theme_bloc.dart';
import 'theme_mode_bloc/theme_event_et_state.dart';

AppBar topNavigationBar(
        {required BuildContext context,
        required GlobalKey<ScaffoldState> scaffoldKey}) =>
    AppBar(
        elevation: 0,
        title: Row(
          children: [
            Text('  '),
            Text(
              ' ACTIVITY ',
              style: TextStyle(
                  backgroundColor: Colors.green[900],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              'GUIDE',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.light ? active : Colors.white

                 ),
            ),
            Expanded(child: Container()),
          ],
        ),
        actions: [
         
            BlocBuilder<UserDashboardCubit, UserDashboardState>(
              builder: (c, state) {
                 final currentLocation = Beamer.of(c).currentBeamLocation;

                if (currentLocation.state.routeInformation.uri.toString() == '/home/dashboard') {
                return TextButton(
                  onPressed: () {
                  c.read<UserDashboardCubit>().refreshDashoard();
                  },
                  child: const Text('Refresh\nDashboard'),
                  
                );
              }else{
               return  IconButton(onPressed: (){
                     context.read<ThemeBloc>().add(ToggleTheme());
              }, icon:  Icon(Icons.brightness_6_sharp,size: 20,
              color: const Color.fromARGB(255, 255, 200, 0),));
              }
              },
            ),
           
          IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(
                Icons.person,
                color: Colors.green[800],
                size: 40,
              ))
        ]);
