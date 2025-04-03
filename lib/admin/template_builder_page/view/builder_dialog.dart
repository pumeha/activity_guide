import 'package:activity_guide/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../bloc/builder_bloc.dart';
import '../bloc/builder_bloc_event.dart';
import '../bloc/builder_bloc_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuilderDialog {
  

Future<void> showBuilderDialog({ required BuildContext? context,int? id,
String? name,String? type,String? Rvalue}){

  
    String range = 'TextField,Dropdown,Date';//change dynamic to textfield

    String? validatorFunction(String? v){
    if(v == null || v.isEmpty){
      return 'required';
    }
    return null;
  }

    final _formKey = GlobalKey<FormState>();
  Map<String,dynamic> partialSave = {};
  String dateType = 'Single Date,Double Date';
  
  //partialSave['date'] = type == 'Date' ? Rvalue : dateType;
   
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    if (id != null) {
      partialSave['colType'] = type;
       context!.read<BuilderBloc>().add(SelectDataTypeEvent(selectDataType:partialSave['colType']));
       nameController = TextEditingController(text: name);
      if (type == 'Dropdown') {
         valueController = TextEditingController(text: Rvalue);
      }else if(type =='Date'){
          partialSave['date'] = Rvalue;
      }
    }

    return showDialog(context: context!,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            
            title: const Center(child: CustomText(text: 'Add Template Columns',weight: FontWeight.bold,)),
            content: StatefulBuilder(
                builder: (BuildContext context,StateSetter setState){
                  return SizedBox(width: 50,
                    child: SingleChildScrollView(child: Form(key: _formKey,
                      child: Column(children: [         
                    Format(title: 'Column Name',child: TextFormField(
                      controller: nameController,
                    minLines: 1, maxLines: 3,
                    onChanged: (value) {
                    },validator: validatorFunction,)),
                                
                    Format(title:'Column Type',
                    child: DropdownButtonFormField<String>(
                      value: partialSave['colType'],
                   items: range
                        .toString().split(',')
                        .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem(value: e,  child: Tooltip(message: e,child: Text(e,),),))
                        .toList(),
                    onChanged: (String? value) {
                      partialSave['colType'] = value!;
                      context.read<BuilderBloc>().add(SelectDataTypeEvent(selectDataType:partialSave['colType']));
                      },
                    isExpanded: true,validator: validatorFunction,
                    decoration: InputDecoration(border: OutlineInputBorder()), )),

                  BlocBuilder<BuilderBloc, BuilderState>(
                    builder: (context, state) {
                      Widget widget = Container();
                      if (state.selectDataType == 'TextField') {
                       widget= Format(child: Text('No default value required'),title: 'Value');
                      }else if(state.selectDataType == 'Dropdown'){
                       widget =   Format(title: 'Value',
                       child: TextFormField(controller: valueController,
                       maxLines: 4,minLines: 4,validator: validatorFunction,));
                      }else if(state.selectDataType == 'Date'){
                        widget =   Format(title: 'Value',
                          child: DropdownButtonFormField<String>(
                          value:  partialSave['date'],items: 
                          dateType.split(',')
                          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e,  child: Tooltip(message: e,child: Text(e,),),))
                          .toList(),
                            onChanged: (String? value) {
                            valueController.text = value!;
                            partialSave['date'] = value;},
                          isExpanded: true,validator: validatorFunction,
                          decoration: const InputDecoration(border: OutlineInputBorder()),),
                        );
                      }
                      return widget;
                    },
                  ) ],)),),
                  );
                }
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(onPressed: (){
              Navigator.of(context).pop();
              partialSave = {};
              valueController.clear();
              nameController.clear();
              context.read<BuilderBloc>().add(SelectDataTypeEvent());
              }, child: const Text('Close',style: TextStyle(color: Colors.red),),),
              TextButton(onPressed: () {
          if (_formKey.currentState!.validate()) {
              context.read<BuilderBloc>().add(AddRowEvent(id: id,columnName: nameController.text,
            dataType: partialSave['colType'],range: valueController.text));
            //clear
            partialSave = {};
            valueController.clear();
            nameController.clear();
            context.read<BuilderBloc>().add(SelectDataTypeEvent());
            if (id != null) {
               Navigator.of(context).pop();
            }
          }
              }, child: Text(id == null ? 'Add to List' : 'Update',
              style: TextStyle(color: Colors.green[900],fontWeight: FontWeight.bold),))
            ],
          );
        });
  
}


Widget Format({String? title, Widget? child}){

    return Card(color: const Color.fromARGB(255, 231, 227, 227),
      child: ListTile(
        title:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title!,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        subtitle: child,
      ),);
  }

  }