import 'dart:async';
import 'package:activity_guide/authentication/cubit/auth_cubit.dart';
import 'package:activity_guide/shared/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit_state.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

TextEditingController tokenController = TextEditingController();
TextEditingController newPasswordController = TextEditingController();
bool showPassword = true;
bool showTimer = false;
int remainingTime = 60;

final _formKey = GlobalKey<FormState>();

Timer? timer;

class _NewPasswordPageState extends State<NewPasswordPage> {
  void startTimer() {
    setState(() {
      showTimer = true;
      remainingTime = 60; // Reset if needed
    });

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime <= 1) {
          t.cancel();
          showTimer = false;
        }
        remainingTime--;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: ThemeData.light(),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthCubitState>(
          listener: (context, state) {
            
           if (state is AuthLoading) {
             EasyLoading.show(maskType: EasyLoadingMaskType.black);
           }else if(state is AuthSuccess){
      
            if (state.message == 'Sent') {
              EasyLoading.showSuccess(state.message);
              startTimer();
            } else {
                EasyLoading.showSuccess(state.message);
            context.beamToReplacementNamed('/login');
            }
          
           }else if(state is AuthFailure){
             EasyLoading.showError(state.error);
           }
          },
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
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Text("Set a new password",
                              style: GoogleFonts.roboto(
                                  fontSize: 24, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const CustomText(
                          text:
                              'Hi Firstname,a reset code has been set to your email for password reset,If you didn\'t see it in inbox kindly check your spam'),
                      // Align(alignment: Alignment.bottomLeft,child: TextButton(onPressed: (){},
                      // child: const Text('Request another token'),),),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tokenController,
                              keyboardType: TextInputType.text,
                              maxLength: 6,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: "Reset token",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(color: active)),
                                  suffixIcon: showTimer
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${remainingTime}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 16),
                                          ),)
                                      : TextButton(
                                          onPressed: () {
                                          context.read<AuthCubit>().requestTokenAgain();
                                          },
                                          child: Text('Request another token'))),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'required';
                                } else if (v.length != 6) {
                                  return 'token must be up to 6';
                                }else{
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: newPasswordController,
                              obscureText: showPassword,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: "New Password",
                                  hintText: "********",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: active)),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                      icon: showPassword
                                          ? const Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off))),
                              validator: (v) {
                               String? result = Constants().isValidPassword(v!);
                            if (result == null) {
                              return null;
                            } else {
                              return result;
                            }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox( height: 30, ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().resetPassword(tokenController.text.trim(),
                             newPasswordController.text.trim());
                          }
                        },child: Container(
                          decoration: BoxDecoration(
                              color: active,
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const CustomText(
                            text: "Update Password",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox( height: 40,),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              context.beamToReplacementNamed('/login');
                            },
                            child: CustomText(
                              text: 'Return to Login Page',
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.black54)),
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
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tokenController.clear();
    newPasswordController.clear();
    timer!.cancel();
  }
  
}
