import 'package:flutter/material.dart';

AppBar topNavigationBar({required BuildContext context,required GlobalKey<ScaffoldState> scaffoldKey}) =>
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
              IconButton(onPressed: (){
               
                  scaffoldKey.currentState!.openEndDrawer();
              }, icon: Icon(
                Icons.person,
                color: Colors.green[800],size: 40,
              ))
          ]);


