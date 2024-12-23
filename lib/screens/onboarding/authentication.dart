import 'package:activity_guide/models/myshared_preference.dart';
import 'package:activity_guide/utils/constants.dart';
import 'package:activity_guide/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../utils/colors.dart';
import '../../views/widgets/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';


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
          image: DecorationImage(image: AssetImage('images/background.jpg'),fit: BoxFit.cover,
              opacity: 0.7),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
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
    );
  }
}

