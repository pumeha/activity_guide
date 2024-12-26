import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List<String> _sectionitems = ['admin','receptionist'];
  var selectedfloor = '';
  var selectedSection  = '';
  late bool firstname = false,lastname = false,phonenumber = false,passcode = false,role = false;
  List<dynamic> usersdata = [];
  _addUserDialog() {
    final  _formKey = GlobalKey<FormState>();
    //clear the textfields;
    //context.read<UsersProvider>().clearTextFields();
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Center(child: Text('Add User',style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold),)),
            content: StatefulBuilder(
                builder: (BuildContext context,StateSetter setState){
                  return SingleChildScrollView(child: Column(
                    children: [
                      FormField<String>( initialValue: selectedSection,validator: (val) => selectedSection == null|| selectedSection.isEmpty  ? 'Select an Option' : '',
                        builder: (FormFieldState<dynamic> field) {
                          return Column( crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DropdownMenu<String>(
                                  requestFocusOnTap: true, label: const Text('Select Section',),
                                  onSelected: (String? purpose){
                                    if(purpose != null){
                                      selectedSection = purpose;
                                      field.didChange(purpose);
                                      role = true;
                                    }
                                  },
                                  dropdownMenuEntries: _sectionitems.map<DropdownMenuEntry<String>>((e) => DropdownMenuEntry<String>(value: e, label: e,
                                      style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 75)),
                                          backgroundColor: WidgetStatePropertyAll(Colors.white60)) )).toList(),
                                  inputFormatters: [FilteringTextInputFormatter(RegExp(r'A-Za-z0-9'), allow: true)]),
                              if (field.hasError && (selectedSection.isEmpty))
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    field.errorText ?? '',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),

                            ],
                          );

                        },

                      ),
                      Form( key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [


                            const SizedBox(height: 12,),
                            SizedBox(
                              width: 300,
                              child: TextFormField( //controller: context.watch<UsersProvider>().firstname,
                                decoration: InputDecoration(border: const OutlineInputBorder(),labelText: 'First name',
                                  focusColor: Colors.green[900],focusedBorder: const OutlineInputBorder(),
                                  labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  errorBorder:  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                  focusedErrorBorder:    const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),),
                                cursorColor: Colors.green[900], validator: (value){
                                  if(value!.length < 3){
                                    return  'Invalid First name';
                                  }else{
                                    firstname = true;
                                    return null;
                                  }
                                }, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
                              ),
                            ),
                            const SizedBox(height: 12,),
                            SizedBox(
                              width: 300,
                              child: TextFormField( //controller: context.watch<UsersProvider>().lastname,
                                decoration: InputDecoration(border: const OutlineInputBorder(),labelText: 'Last name',
                                  focusColor: Colors.green[900],focusedBorder: const OutlineInputBorder(),
                                  labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                  errorBorder:  const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                  focusedErrorBorder:    const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),),
                                cursorColor: Colors.green[900], validator: (value){
                                  if(value!.length < 3){
                                    return  'Invalid Last name';
                                  }else{
                                    lastname = true;
                                    return null;
                                  }
                                },
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],
                              ),
                            ),
                            const SizedBox(height: 12,),
                            SizedBox(
                              width: 300,
                              child: TextFormField(//controller: context.watch<UsersProvider>().phonenumber,
                                decoration: InputDecoration(border: const OutlineInputBorder(),labelText: 'Phone Number',
                                    focusColor: Colors.green[900],focusedBorder: const OutlineInputBorder(),
                                    errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                    focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                    labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600) ),
                                cursorColor: Colors.green[900],keyboardType: TextInputType.number,
                                validator: (val){
                                  if(val!.length != 11){
                                    return 'Invalid Phone number';
                                  }else{
                                    phonenumber = true;
                                    return null;
                                  }
                                },maxLength: 11, inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),),
                            const SizedBox(height: 12,),
                            SizedBox(width: 300,
                              child: TextFormField(//controller: context.watch<UsersProvider>().passcode,
                                decoration: InputDecoration(border: const OutlineInputBorder(),labelText: 'Passcode',
                                  focusColor: Colors.green[900],focusedBorder: const OutlineInputBorder(),
                                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                  focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red,width: 2)),
                                  labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600) ),
                                cursorColor: Colors.green[900],validator: (val) {
                                  if(val!.length != 5){
                                    return 'Passcode must be up to 5';
                                  }else{
                                    passcode = true;
                                    return null;
                                  }
                                },maxLength: 5,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              ),),
                            const SizedBox(height: 12,),

                          ],
                        ),
                      ),
                    ],
                  ),);
                }
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(onPressed: (){
                setState(() {
                  Navigator.pop(context);
                });

              }, child: const Text('Cancel',style: TextStyle(color: Colors.red),),),
              TextButton(onPressed: () async{
                // await context.read<UsersProvider>().addUser();
                if(selectedSection.isEmpty && selectedSection != null){
                  EasyLoading.showToast('Kindly Select a role');
                  return;
                }
                if(selectedSection != 'admin' && selectedSection != 'receptionist'){
                  print(selectedSection);
                  EasyLoading.showToast('Invalid role');
                  return;
                }
                if(_formKey.currentState!.validate() && role){
                  print('true');
                  // context.watch<UsersProvider>().role = selectedSection;

                 // await context.read<UsersProvider>().addUser(selectedSection) == 1 ? Navigator.pop(context) : null;
                }

              }, child: Text('Submit',style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold),))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    selectedSection = '';
   // usersdata = context.watch<UsersProvider>().usersdata;

    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 26,
            child: FloatingActionButton(onPressed: (){
             // context.read<UsersProvider>().getUsers();
            },child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/refreshdata.png'),
            ),heroTag: 'refresh',),
          ),
          Positioned(
            bottom: 80,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(onPressed: (){
                _addUserDialog();
              },backgroundColor: Colors.green[900],child:  const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.add),
              ),heroTag: 'add',),
            ),)
        ],
      ),
      body: Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.green)),
          child: usersdata == null || usersdata.isEmpty ? Center(child: Text('No data found'),) : ListView.builder( itemCount: usersdata.length,
              itemBuilder: (context,index){
                final user = usersdata[index];
                String fullname = user['firstname'] + ' ' + user['lastname'];
                return  Center(
                  child: SizedBox(
                    width: 350,
                    child: Card(
                      shadowColor: Colors.black,
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(width: 24,height: 100,color: Colors.green[900],),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(fullname,style: TextStyle(fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(user['role'],style: TextStyle(fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),),
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(user['phonenumber']),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextButton(onPressed: (){
                                        EasyLoading.showToast(user['passcode']);
                                      },child: Text('*****'),),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(onPressed: (){}, icon: const Icon(Icons.delete))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),);
  }
}
