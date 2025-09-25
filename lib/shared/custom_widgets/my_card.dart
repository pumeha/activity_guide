import 'package:flutter/material.dart';
class MyCard extends StatelessWidget {
  MyCard({super.key,required this.child});
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(color: Colors.white,elevation: 4,child: child,);
  }
}
