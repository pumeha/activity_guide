import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../json2dart/user_json_dart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'users_page.dart';

class UpdateUserDialog {
  UpdateUserDialog.dialog(
      {required UserJSON2Dart userdata, required BuildContext context}) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController firstNameController =
        TextEditingController(text: userdata.firstname);
    TextEditingController lastNameController =
        TextEditingController(text: userdata.lastname);
    TextEditingController phoneNumberController =
        TextEditingController(text: userdata.phonenumber);
    TextEditingController emailController =
        TextEditingController(text: userdata.email);
    String range = 'sub-admin,user';

    Map<dynamic, String> partialSave = {};
    partialSave['role'] = userdata.role!;
    partialSave['dept'] = userdata.dept!;
    partialSave['unit'] = userdata.unit!;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Update User',
              style: TextStyle(
                  color: Colors.green[900], fontWeight: FontWeight.bold),
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is LoadingState) {
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  } else if (state is SuccessState) {
                    partialSave.clear();
                    EasyLoading.showSuccess(state.message!);
                    Navigator.pop(context);
                  } else if (state is FailureState) {
                    EasyLoading.showInfo(state.message!);
                  }
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButtonFormField<String>(
                          hint: const Text('Select User role'),
                          value: partialSave['role'],
                          items: range
                              .toString()
                              .split(',')
                              .map<DropdownMenuItem<String>>(
                                  (e) => DropdownMenuItem(
                                        value: e,
                                        child: Tooltip(
                                          message: e,
                                          child: Text(
                                            e,
                                          ),
                                        ),
                                      ))
                              .toList(),
                          onChanged: null,
                          isExpanded: true,
                          validator: validatorFunction,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),

                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: userTextField(
                              labelText: 'First name',
                              controller: firstNameController,
                              enabled: false),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: userTextField(
                              labelText: 'Last name',
                              controller: lastNameController,
                              enabled: false),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            enabled: false,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Email address',
                              focusColor: Colors.green[900],
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: active)),
                              errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1)),
                            ),
                            cursorColor: Colors.green[900],
                            validator: isValidEmail,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: userTextField(
                              labelText: 'Phone Number',
                              controller: phoneNumberController,
                              inputTypeNumber: true),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Visibility(
                            visible: partialSave['role'] == 'user',
                            child: Column(
                              children: [
                                DropdownButtonFormField<String>(
                                  hint: Text('Select Dept'),
                                  value: partialSave['dept'],
                                  items: departmentOptions.keys
                                      .map<DropdownMenuItem<String>>(
                                          (e) => DropdownMenuItem(
                                                value: e,
                                                child: Tooltip(
                                                  message: e,
                                                  child: Text(
                                                    e,
                                                  ),
                                                ),
                                              ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      partialSave['dept'] = value!;
                                      partialSave['unit'] = departmentOptions[
                                              partialSave['dept']]!
                                          .first;
                                    });
                                  },
                                  isExpanded: true,
                                  validator: validatorFunction,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                if (partialSave['dept'] != null)
                                  DropdownButtonFormField<String>(
                                    hint: Text('Select Unit'),
                                    value: partialSave['unit'],
                                    items:
                                        departmentOptions[partialSave['dept']]!
                                            .map<DropdownMenuItem<String>>(
                                                (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Tooltip(
                                                        message: e,
                                                        child: Text(
                                                          e,
                                                        ),
                                                      ),
                                                    ))
                                            .toList(),
                                    onChanged: (String? value) {
                                      partialSave['unit'] = value!;
                                    },
                                    isExpanded: true,
                                    validator: validatorFunction,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                  ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  partialSave.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<UserBloc>().add(UpdateUserEvent(
                          userDetails: UserJSON2Dart(
                              role: partialSave['role'],
                              firstname: firstNameController.text,
                              lastname: lastNameController.text,
                              email: emailController.text,
                              dept: partialSave['role'] == 'user'
                                  ? partialSave['dept']
                                  : 'sub-admin',
                              unit: partialSave['role'] == 'user'
                                  ? partialSave['unit']
                                  : 'sub-admin',
                              phonenumber: phoneNumberController.text)));
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.green[900], fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }
}
