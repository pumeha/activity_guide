import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import 'utils/constants.dart';

AppBar topNavigationBar(BuildContext context,GlobalKey<ScaffoldState> key) =>
    AppBar(elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
        children: [
            Text('  '),
            Text(' ACTIVITY ', style: TextStyle(
                backgroundColor: Colors.green[900], fontSize: 24,
                fontWeight: FontWeight.bold, color: Colors.white),),
            Text('GUIDE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                    color: Colors.green[900]),),
        Expanded(child: Container()),

        ],),

        actions: [
            PopupMenuButton(itemBuilder: (BuildContext context) => [
    // First menu item: User details
    PopupMenuItem(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    Text("Hi! 👋 Ben Otaro", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    SizedBox(height: 8),
    Row(
      children: [
        Text('Your assign dept is ',style: TextStyle(fontStyle: FontStyle.italic),),
          Text('LEGAL',style: TextStyle(fontWeight: FontWeight.bold),)
      ],
    ),
        Row(
          children: [
              Expanded(child: Container()),
            TextButton(onPressed: (){
              Beamer.of(context).beamToReplacementNamed('/login');
              MysharedPreference().setPreferences(admin, '');
            }, child: Text('Log out')),
          ],
        )
    ],)),
],tooltip: 'User',child:  Padding(
  padding: const EdgeInsets.only(left: 12,top: 8,right: 8,bottom: 8),
  child: Icon(
                Icons.person,
                color: Colors.green[800],size: 40,
              ),
),)
            ]);


