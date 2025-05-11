import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:html' as html;
class Constants{
 bool isValidEmail(String email) {
    // Regular expression for validating an Email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

   String? isValidPassword(String password) {
    // Password validation criteria
    if (password.length < 8) {
      return "Minimum length";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "At least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return " At least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return " At least one number";
    }
    if (!RegExp(r'[!@#\$%\^&\*\(\)_\+\[\]\{\}\|;:,.<>?]').hasMatch(password)) {
      return "At least one special character";
    }
    return null; // Password is valid
  }
    
}
 String? validatorFunction(String? v){
    if(v == null || v.isEmpty){
      return 'required';
    }
    return null;
  }
  String? isValidEmail(String? email) {
    // Regular expression for validating an Email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if(email == null || email.isEmpty){
      return 'required';
    }else if(!emailRegex.hasMatch(email)){
        return '*valid email address required';
    }else{
    return null;
    }
  }

const appName = 'Activity Guide';
const admin  = 'admin';
const subAdmin = 'sub-admin';
const user = 'user';
const defaultDashboard = "https://1drv.ms/x/c/979292c95e1c918d/IQQ71B29H8udTogIbikm_fajAVnJ8TicsaX8QVwmsc67aS8?em=2&AllowTyping=True&wdHideGridlines=True&wdHideHeaders=True&wdDownloadButton=True&wdInConfigurator=True&wdInConfigurator=True";
const unauthorizedUser = 'Unauthorized User';
const monthlyTemplateKey = 'monthlyTemplate';
const workplanTemplateKey = 'workplanTemplate';
const dataCollectionKey = 'dataCollection';
const selectedTemplate = 'stemplate';
const monthlyTemplateName = 'monthlyTemplateName';
const workplanTemplateName = 'workplanTemplateName';

String templateName(String purpose){
  DateTime dateTime = DateTime.now();
  String value = dateTime.year.toString() + (dateTime.month+1).toString() + dateTime.day.toString() +
                  dateTime.hour.toString() + dateTime.minute.toString() + dateTime.second.toString();
        return  purpose+'_'+value;          
}

Widget customCircleIndicator(){
 return Center(child: CircularProgressIndicator(
    strokeWidth: 8,
    value: 0.24,  // Percentage value between 0.0 and 1.0
    backgroundColor: Colors.black.withOpacity(0.1),  // Lighter background color
    valueColor: const AlwaysStoppedAnimation<Color>(active), // Progress color
  ));
}

bool isDeviceOffline_Return_False() {
 return html.window.navigator.onLine ?? false;
}