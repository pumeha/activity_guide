
import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:activity_guide/authentication/cubit/auth_cubit_state.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
  
}

final _formKey = GlobalKey<FormState>();
class _AuthenticationPageState extends State<AuthenticationPage> {
  TextEditingController emailController = TextEditingController(text: 'smarterway2024@gmail.com');
  TextEditingController passwordController = TextEditingController(text: 'Smarter2@');
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthCubitState>(
        listener: (context, state) async{
            if(state is AuthLoading){
        EasyLoading.show(maskType: EasyLoadingMaskType.black);
       }else if(state is AuthSuccess){
        EasyLoading.showSuccess('Success');
        switch (state.message) {
          case 'admin':
            context.beamToReplacementNamed('/super_admin');
            break;
          case subAdmin:
            EasyLoading.showInfo('Glad to see you!');
            context.beamToReplacementNamed('/admin');
            break;  
          case 'user':
              context.beamToReplacementNamed('/home');
          case 'verification':
              context.beamToReplacementNamed('/account_verification');    
          default:
        }
        
       }else if(state is AuthFailure){
        EasyLoading.showError(state.error);
       }},
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('/images/background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.7), ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ' ACTIVITY ',
                            style: TextStyle(
                                backgroundColor: Colors.green[900],
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'GUIDE',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900]),
                          )
                        ],
                      ),
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
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "abc@domain.com",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: active))),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return '*required';
                          } else if (!Constants().isValidEmail(v)) {
                            return '*valid email address required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            labelText: "Password",
                            hintText: "********",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder( 
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: active)),
                                suffixIcon: IconButton(onPressed: (){setState((){
                                  showPassword = !showPassword;
                                 
                                });}, icon: showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off) )
                                ),
                        validator: (v) {
                          String? result = Constants().isValidPassword(v!);
                          if (result == null) {
                            return null;
                          } else {
                            return result;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        
                          TextButton(onPressed: () {
                       context.beamToReplacementNamed('/reset_password');
                            },
                            child: const CustomText(
                                text: "Forgot password?", color: active),
                          )], ),
                      const SizedBox( height: 15,
                      ),
                      InkWell(
                        onTap: () async{
                          if (_formKey.currentState!.validate()) {
                         
                            context.read<AuthCubit>().login(
                                emailController.text.trim(), passwordController.text);
                           
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: active,
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
        ),
      ),
    );
  }
}
