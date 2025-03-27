import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../custom_widgets/custom_text.dart';
import '../shared/utils/colors.dart';
import '../shared/utils/constants.dart';


class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('/images/background.jpg'),fit: BoxFit.cover,
              opacity: 0.7),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' ACTIVITY ', style: TextStyle(
                          backgroundColor: Colors.green[900], fontSize: 36,
                          fontWeight: FontWeight.bold, color: Colors.white),),
                      Text('GUIDE',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,
                            color: Colors.green[900]),)],),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text("Login",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ],
                  ),
              
                  const SizedBox(
                    height: 15,
                  ),
                  TextField( controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "abc@domain.com",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: active))),
              
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "123",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: active))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (value){}),
                          const CustomText(text: "Remember Me",),
                        ],
                      ),
              
                      const CustomText(
                          text: "Forgot password?",
                          color: active
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: (){
                      String role = emailController.text;
                      if(role == 'admin') {
                        String json =
                            '[{"ID": 1,"name": "OUTPUT","Type": "Dropdown","Range": "WORK PROGRAMME AND BUDGET,ACTIVITY GUIDE,CONFERENCES AND WORKSHOP"},{"ID": 2,"name": "TYPE OF ACTIVITIES","Type": "Dropdown","Range": "SURVEY,SAS,WORKSHOP"}, {"ID": 3,"name": "FREQUENCY","Type": "Dropdown","Range": "DAILY,WEEKLY, MONTHLY"}, {"ID": 4,"name": "PLANNED  DATE","Type": "Date","Range": "Double Date"}, {"ID": 5,"name": "ACTUAL DATE","Type": "Date","Range": "Double Date"}, {"ID": 6,"name": "TARGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 7,"name": "ACTIVITIES DESCRIPTION","Type": "Dynamic","Range": "No default value required"}, {"ID": 8,"name": "OUTCOME","Type": "Dynamic","Range": "No default value required"}, {"ID": 9,"name": "PERCENTAGE  COMPLETED","Type": "Dynamic","Range": "No default value required"}, {"ID": 10,"name": "MILESTONE","Type": "Dropdown","Range": "N/A,PROPOSAL,PLANNING,EXCUTING,COMPLETION,SUBMISSION"}, {"ID": 11,"name": "BASELINE METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 12,"name": "KPI","Type": "Dynamic","Range": "No default value required"}, {"ID": 13,"name": "ACTUAL ACHIEVED METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 14,"name": "TOTAL BUDGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 15,"name": "APPROPRIATION","Type": "Dynamic","Range": "No default value required"}, {"ID": 16,"name": "DONOR","Type": "Dynamic","Range": "No default value required"}, {"ID": 17,"name": "RELEASED","Type": "Dynamic","Range": "No default value required"}, {"ID": 18,"name": "UTILIZED","Type": "Dynamic","Range": "No default value required"}, {"ID": 19,"name": "BALANCE","Type": "Dynamic","Range": "No default value required"}, {"ID": 20,"name": "MORE FUND","Type": "Dynamic","Range": "No default value required"}, {"ID": 21,"name": "CHALLENGES","Type": "Dropdown","Range": "NO CHALLENGES,FUNDS RELATED,RISKRELATED"}, {"ID": 22,"name": "REMARKS","Type": "Dynamic","Range": "No default value required"}]';
                        MysharedPreference().setPreferences('template', json);
                        MysharedPreference().setPreferences(admin,'true' );
                       Beamer.of(context).beamToNamed('/admin', replaceRouteInformation: true);
                      }else{
                        MysharedPreference().setPreferences(admin, 'false');
                    Beamer.of(context).beamToNamed('/home', replaceRouteInformation: true);
                      }
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context)=> HomePage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(color: active,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const CustomText(
                        text: "Login",
                        color: Colors.white,
                      ),
                    ),
                  ),
              
              
              
              
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

