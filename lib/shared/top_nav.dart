import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beamer/beamer.dart';

import '../users/dashboard_page/cubit/user_dashboard_state.dart';

AppBar topNavigationBar(
        {required BuildContext context,
        required GlobalKey<ScaffoldState> scaffoldKey}) =>
    AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]),
            ),
            Expanded(child: Container()),
          ],
        ),
        actions: [
         
            BlocBuilder<UserDashboardCubit, UserDashboardState>(
              builder: (context, state) {
                 final currentLocation = Beamer.of(context).currentBeamLocation;

                if (currentLocation.state.routeInformation.uri.toString() == '/home/dashboard') {
                return TextButton(
                  onPressed: () {
                  context.read<UserDashboardCubit>().refreshDashoard();
                  },
                  child: const Text('Refresh\nDashboard'),
                  
                );
              }
              return SizedBox.shrink();},
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
