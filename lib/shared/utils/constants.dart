import 'package:flutter/material.dart';

import 'colors.dart';

class Constants{

}

const appName = 'Activity Guide';
const admin  = 'admin';

Widget CustomCircleIndicator(){
 return Center(child: CircularProgressIndicator(
    strokeWidth: 8,
    value: 0.24,  // Percentage value between 0.0 and 1.0
    backgroundColor: Colors.black.withOpacity(0.1),  // Lighter background color
    valueColor: const AlwaysStoppedAnimation<Color>(active), // Progress color
  ));
}