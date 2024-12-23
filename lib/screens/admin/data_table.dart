import 'package:flutter/material.dart';

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTableState();

}

class _MyTableState extends State<MyTable> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('Dataset'));
  }
}
