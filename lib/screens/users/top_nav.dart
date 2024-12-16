import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../views/widgets/custom_text.dart';
import 'responsiveness.dart';
AppBar topNavigationBar(BuildContext context,GlobalKey<ScaffoldState> key) =>
    AppBar(elevation: 0,
    backgroundColor: Colors.white,
    title: Row(
        children: [
            Text(' ACTIVITY ', style: TextStyle(
                backgroundColor: Colors.green[900], fontSize: 24,
                fontWeight: FontWeight.bold, color: Colors.white),),
            Text('GUIDE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                    color: Colors.green[900]),),
        Expanded(child: Container()),


            const SizedBox(
                width: 24,
            ),
            const CustomText(
                text: "Hi Jen!",
                color: lightGrey,
            ),
            const SizedBox(
                width: 16,
            ),
            Container(
                decoration: BoxDecoration(
                    color: active.withOpacity(.5),
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.all(2),
                    child: const CircleAvatar(
                        backgroundColor: light,
                        child: Icon(
                            Icons.person_outline,
                            color: dark,
                        ),
                    ),
                ),
            )
        ],),
    leading: !ResponsiveWidget.isSmallScreen(context) ?
    Text('') : IconButton(onPressed: (){
            key.currentState?.openDrawer();
    }, icon: Icon(Icons.menu)),);