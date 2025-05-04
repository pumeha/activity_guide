import 'dart:convert';

import 'package:activity_guide/admin/view/update_user_dialog.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../json2dart/user_json_dart.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String range = 'sub-admin,user';

  Map<dynamic, String?> partialSave = {};
  List<UserJSON2Dart> usersdata = [];
   List<UserJSON2Dart> subadmindata = [];
  
  _addUserDialog() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Add User',
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
                    _addUserDialog();
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
                          hint: Text('Select User role'),
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
                          onChanged: (String? value) {
                            partialSave['role'] = value!;
                    
                          },
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
                              controller: firstNameController),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: userTextField(
                              labelText: 'Last name',
                              controller: lastNameController),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
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
                          partialSave['unit'] = departmentOptions[partialSave['dept']]!.first;
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
                        if(partialSave['dept'] != null)
                        
                        DropdownButtonFormField<String>(
                          hint: Text('Select Unit'),
                          value: partialSave['unit'],
                          items: departmentOptions[partialSave['dept']]!
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
                    ),
                  ),
                ),
              );
            }),
            backgroundColor: Colors.white,
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
                      context.read<UserBloc>().add(AddUserEvent(
                          userDetails: UserJSON2Dart(
                              role: partialSave['role'],
                              firstname: firstNameController.text,
                              lastname: lastNameController.text,
                              email: emailController.text,
                              dept: partialSave['dept'],
                              unit: partialSave['unit'],
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

  @override
  void initState() {
    super.initState();

  }

    Future<List<UserJSON2Dart>> listUsers() async{
        String? users = await MysharedPreference().getPreferences(usersLists);
        if (users != null && users.isNotEmpty) {
          List<dynamic> decodedList = jsonDecode(users);
          List<UserJSON2Dart> list = decodedList.map((user)=> UserJSON2Dart.fromJson(user)).toList();
          return list;
        } else {
          return [];
        }
    } 

    Future<List<UserJSON2Dart>> listSubAdmin() async{
      String? subadmin = await MysharedPreference().getPreferences(subAdminLists);
      if (subadmin != null && subadmin.isNotEmpty) {
        List<dynamic> decodedList = jsonDecode(subadmin);
        List<UserJSON2Dart> list = decodedList.map((user)=> UserJSON2Dart.fromJson(user)).toList();
        return list;
      } else {
        return [];
      }
    }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController( length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const TabBar(tabs: [Tab(text: 'Sub-Admins',),Tab(text: 'Users',)],),
        floatingActionButton:   FloatingActionButton(
          onPressed: () {
           _addUserDialog();
          },
          backgroundColor: Colors.green[900],
          heroTag: 'add',
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon( Icons.add,color: Colors.white, ), ),
        ),
        body: BlocListener<UserBloc, UserState>(listener: (context, state) {
          if (state is LoadingState) {
            EasyLoading.show(maskType: EasyLoadingMaskType.black);
          } else if (state is SuccessState) {
            setState(() {
              
            });
             EasyLoading.showSuccess(state.message!);
          } else if (state is FailureState) {
            setState(() {
              
            });
            EasyLoading.showInfo(state.message!);
          }
        }, child: TabBarView(
          children: [
            FutureBuilder(future: listSubAdmin(), builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return customCircleIndicator();
                }else if(snapshot.hasError){
                    return Center(child: CustomText(text: 'Error ${snapshot.error}'),);
                } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return const Center(child: CustomText(text: 'No SubAdmin records',weight: FontWeight.bold,),);
                }else{
                  return ListView.builder(itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                     final user = snapshot.data![index];
                   
                    return UserListItem(user: user,
                    suspendUser: ()=> context.read<UserBloc>().add(SuspendUserEvent(email: user.email!)),
                    deleteUser: ()=> context.read<UserBloc>().add(DeleteUserEvent(email: user.email!)),
                    activeUser: ()=>context.read<UserBloc>().add(ActiveUserEvent(email:user.email!)));
                  });
                }
            }),
          FutureBuilder(future: listUsers(), builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return customCircleIndicator();
            }else if(snapshot.hasError){
              return Center(child: CustomText(text: snapshot.error.toString()),);
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Center(child: CustomText(text: 'No User records',weight: FontWeight.bold,),);
            }else{
           return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];
                   
                    return UserListItem(user: user,
                    suspendUser: ()=> context.read<UserBloc>().add(SuspendUserEvent(email: user.email!)),
                    deleteUser: ()=> context.read<UserBloc>().add(DeleteUserEvent(email: user.email!)),
                    activeUser: ()=>context.read<UserBloc>().add(ActiveUserEvent(email:user.email!)));
                  });
  }})],
        )),
      ),
    );
  }
   
    Widget UserListItem({required UserJSON2Dart user,required  Function suspendUser,
                  required Function deleteUser, required Function activeUser}){
                    getStatusColor({required String status}){
                     switch (status) {
                       case 'active':
                         return active;
                       case 'suspend':
                          return Colors.red[900];  
                       default:
                        return const Color.fromARGB(255, 241, 220, 35);
                     }
                    }
                return Center(
                      child: SizedBox(
                        width: 350,
                        child: Card(
                          shadowColor: Colors.black,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 100,
                                color: getStatusColor(status: user.status!),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            user.firstname! + ' '+ user.lastname!,
                                            style: const TextStyle(fontWeight: FontWeight.bold),), ),
                                        user.status == 'active' ?
                                       PopupMenuButton(itemBuilder: (BuildContext context)=>[
                                       const PopupMenuItem(value: 'edit',child: Text('Edit'),),
                                       const PopupMenuItem(value: 'suspend',child: Text('Suspend'),),
                                       const PopupMenuItem(value: 'delete',child: Text('Delete'),)
                                       ],icon: const Icon(Icons.more_vert),
                                       onSelected: (v){
                                          switch (v) {
                                            case 'edit':
                                            UpdateUserDialog.dialog(userdata: user, context: context);
                                            break;
                                            case 'suspend':
                                              suspendUser();
                                              break;
                                            case 'delete':
                                              deleteUser();  
                                            default:
                                          }
                                       },) :(user.status == 'inactive' ?
                                       PopupMenuButton(itemBuilder: (BuildContext context)=>[
                                       const PopupMenuItem(value: 'edit',child: Text('Edit'),),
                                       const PopupMenuItem(value: 'delete',child: Text('Delete'),)
                                       ],icon: const Icon(Icons.more_vert),
                                       onSelected: (v){
                                          switch (v) {
                                            case 'edit':
                                           
                                            UpdateUserDialog.dialog(userdata: user, context: context);
                                            break;
                                            case 'delete':
                                              deleteUser();  
                                            default:
                                          }
                                       },) :
                                       PopupMenuButton(itemBuilder: (BuildContext context)=>[
                                       const PopupMenuItem(value: 'active',child: Text('Active'),),
                                       const PopupMenuItem(value: 'edit',child: Text('Edit'),),
                                       const PopupMenuItem(value: 'delete',child: Text('Delete'),)
                                       ],icon: const Icon(Icons.more_vert),
                                       onSelected: (v){
                                          switch (v) {
                                            case 'edit':
                                            UpdateUserDialog.dialog(userdata: user, context: context);
                                            break;
                                            case 'active':
                                              activeUser();
                                              break;
                                            case 'delete':
                                              deleteUser();  
                                            default:
                                          }
                                       },)) 
                                        
                                      ],),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(user.phonenumber!),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CustomText(text: user.dept!+'-'+user.unit!),
                                        ),
                                      ],
                                    ),
                                    CustomText(text: user.email!,style: FontStyle.italic,)
                                  ],
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                    );
    }
  
}

Widget userTextField(
      {required String labelText,
      required TextEditingController controller,
      bool? inputTypeNumber,
      bool? emailValidate,bool? enabled = true}) {
    return TextFormField(
      maxLength: inputTypeNumber == true ? 11 : null,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        focusColor: Colors.green[900],
        focusedBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: active)),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1)),
      ),
      cursorColor: Colors.green[900],
      validator: emailValidate == true ? isValidEmail : validatorFunction,
      inputFormatters: inputTypeNumber == true
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))]
          : [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
      enabled: enabled,    
    );
      }

  final Map<String, List<String>> departmentOptions = {
     'ICT': ['SP&MD', 'DP&AD', 'H&NWD'],
     'PTSD': ['TSD', 'PSD'],
     'GSD': ['GENERAL SERVICES', 'MAINTENANCE'],
     'FAAC': ['BUDGET', 'EXPENDITURE', 'REVENUE', 'FINANCIAL & FISCAL'],
     'ABESD':['ASD','BED'],
     'ISDD' : ['LEGAL SERVICES','BOARD AFFAIRS'] ,
     'HRM':['APD','T&SWD'],
     'CPRD': ['CD','PRD'],
     'FSM': ['FSD','MD'],
     'PROC': ['PROCUREMENT','TENDER ADVERTISEMENT'],
     'SGSD':['SSD','GSID'],
     'DSHD': ['DSD','HSD'],
     'CPSCD': ['CPD','SCD'],
     'NAEED': ['NAD','EESD'],
     'OFFICE OF THE SG': ['SIU','AUDIT'],
     'RSCD': ['RCD','SDID']
  };
