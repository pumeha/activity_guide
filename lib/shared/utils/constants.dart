import 'package:flutter/material.dart';

import 'colors.dart';

class Constants{
 bool isValidEmail(String email) {
    // Regular expression for validating an Email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

   bool isValidPassword(String password) {
    // Password validation criteria
    if (password.length < 8) {
      return false; // Minimum length
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return false; // At least one uppercase letter
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return false; // At least one lowercase letter
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return false; // At least one number
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return false; // At least one special character
    }
    return true; // Password is valid
  }

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