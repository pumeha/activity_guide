import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit_state.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

TextEditingController emailController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthCubitState>(
        listener: (context, state) {
          
         if (state is AuthLoading) {
           EasyLoading.show(maskType: EasyLoadingMaskType.black);
         }else if(state is AuthSuccess){
          EasyLoading.showSuccess('Success');
          context.beamToReplacementNamed('/new_password');
         }else if(state is AuthFailure){

          if (state.error == 'inactive') {
          EasyLoading.showInfo('Account yet to be verified.\n Kindly Login with the welcome details sent to your email or \n Check your spam',
          duration: const Duration(seconds: 5));
          context.beamToReplacementNamed('/login');
          }else if(state.error == 'suspend'){
            EasyLoading.showInfo('Account suspended.',
          duration: const Duration(seconds: 5));
          }else{
            EasyLoading.showError(state.error);
          }
          }},
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('/images/background.jpg'),
                fit: BoxFit.cover,
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
                    const SizedBox(height: 60,),
                    Row(
                      children: [
                        Text("Reset Password",
                            style: GoogleFonts.roboto(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(  height: 20,  ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
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
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                   context.read<AuthCubit>().forgotPassword(emailController.text.trim());
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
                          text: "Proceed",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox( height: 40, ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.beamToReplacementNamed('/login');
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.black54)),
                          child: const CustomText(
                            text: 'Return to Login Page',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.clear();
  }
}
