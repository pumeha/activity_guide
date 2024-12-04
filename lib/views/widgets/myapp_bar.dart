import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
 final String title;
  const MyAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return  AppBar(title:  Center(child: Text(title,
      style: TextStyle(color: Colors.white),)),
      backgroundColor: Colors.blue.shade400,);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
