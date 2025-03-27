import 'package:flutter/material.dart';

class GridLabel extends StatelessWidget {
  String title;
  GridLabel({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return  Container(color: Colors.green.shade600,child: Text(title, overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
    ),alignment: Alignment.centerLeft,);
  }
}
