import 'dart:math';

import 'package:activity_guide/users/data_collection_page/bloc/data_collection_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beamer/beamer.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/templateJson.dart';
import 'bloc/data_collection_bloc.dart';
import 'bloc/data_collection_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DataCollectionPage extends StatefulWidget {
  const DataCollectionPage({super.key});

  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage> {
  //values holder
  Map<String, dynamic> partialSave = {};
  Map<String, dynamic> emptyMap = {};
  late List<TextEditingController> _controllers;
  late List<String> labels;
  late List<dynamic> editValues;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    editValues = [];
    return Scaffold(
      backgroundColor: Color(0xF4FAEF),
      body: BlocBuilder<DataCollectionBloc, DataCollectionState>(
        builder: (context, state) {
          List<TemplateJson> data =
              state.data!.map((data) => TemplateJson.fromJson(data)).toList();
            
          _controllers = List.generate(data.length, (index) { return TextEditingController(); });
          labels = List.generate(data.length, (index)=>data[index].name);

          if (state is DataCollectionEditState) {
            editValues = state.editData;
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: List.generate(data.length, (index) {
                  return CustomCard(index, data[index].name, data[index].type,
                      data[index].range, _formKey, editValues, labels);
                }),  ), ), );}, ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 100,
            right: 0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                  
                    if (_formKey.currentState!.validate()) {
                      Map<String, String> data = {};
                        
                      for (var i = 0; i < _controllers.length; i++) {
                        data[labels[i]] = _controllers[i].text;
                      }
                      
                      
                      if (editValues.isNotEmpty && editValues.isNotEmpty) {
                  context.read<DataCollectionBloc>().add(AddDataFromDataCollectionEvent(data: data,
                  updateId: editValues[0]['ID']));
                      } else {
                      context.read<DataCollectionBloc>().add(AddDataFromDataCollectionEvent(data: data));
                      }
                   for (var element in _controllers) {
                     element.clear();
                   }

                   EasyLoading.showSuccess('Success');
                    }
                  },
                  tooltip: 'Save',
                  heroTag: 'save',
                  backgroundColor: active,
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12,),
                BlocBuilder<DataCollectionBloc, DataCollectionState>(
                  builder: (context, state) {
                     
                    if(state is DataCollectionEditState){
                      return FloatingActionButton(onPressed: (){
                        context.read<DataCollectionBloc>().add(LoadSelectedDataCollectionTemplateEvent());
                        setState(() {
                          
                        });
                       },child: const Icon(Icons.delete_forever,color: Colors.red,),
                       backgroundColor: Colors.black,);
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.beamToReplacementNamed('/home/data_entry');
                  },
                  backgroundColor: Color(0xFFFFFFFF),
                  tooltip: 'View',
                  heroTag: 'view',
                  child: const Icon(
                    Icons.description_outlined,color: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String? validatorFunction(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'required';
    }
    return null;
  }

  void singleDateDialog(String title,TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selectedDate != null) {
      String _date =
          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
      partialSave[title] = _date;
     controller.text = partialSave[title];
    }
  }

  void doubleDateDialog(String title,TextEditingController controller) {
    String multipleDateString = '';
    showDateRangePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5),
            initialEntryMode: DatePickerEntryMode.calendarOnly)
        .then((onValue) {
      if (onValue != null) {
        String startDate =
            '${onValue.start.month}/${onValue.start.day}/${onValue.start.year}';
        String endDate =
            '${onValue.end.month}/${onValue.end.day}/${onValue.end.year}';
        multipleDateString = startDate + '-' + endDate;
        partialSave[title] = multipleDateString;
        controller.text = partialSave[title];
      }
    });
  }

  Widget CustomCard(int index, String title, String type, String range,
      Key _key, List<dynamic> editValues, List<dynamic> labels) {
    Widget subtitleWidget = Container();
    // Get the width of the device
    double width = MediaQuery.of(context).size.width;
    double horizontalPadding = width > 1000 ? width / 4 : width / 6;
    if (editValues.isNotEmpty) {
      _controllers[index].text =  editValues[0][labels[index]];
       partialSave[title] = editValues[0][labels[index]] ;
    }
    
   
    switch (type) {
      case 'Dropdown':
        subtitleWidget = DropdownButtonFormField<String>(
          value: partialSave[title],
          items: range
              .toString()
              .split(',').toSet()
              .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
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
            partialSave[title] = value;
            _controllers[index].text = partialSave[title];
          },
          isExpanded: true,
          validator: validatorFunction,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
        break;
      case 'Date':
       
        range == 'Single Date'
            ?
            // Render Date Picker
            subtitleWidget = Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: TextFormField(
                      controller: _controllers[index],
                      validator: validatorFunction,
                      enabled: false,
                      style: TextStyle(color: Colors.black),
                    )),
                    TextButton(
                      child: Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        singleDateDialog(title,_controllers[index]);
                      
                      },
                    ),
                  ],
                ),
              )
            : subtitleWidget = Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _controllers[index],
                      validator: validatorFunction,
                      enabled: false,
                      style: TextStyle(color: Colors.black),
                    )),
                    TextButton(
                      child: Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        doubleDateDialog(title,_controllers[index]);
                      },
                    ),
                  ],
                ),
              );
        break;
      case 'TextField':
        subtitleWidget = TextFormField(
          controller: _controllers[index],
          minLines: 1,
          maxLines: 3,
          onChanged: (value) {
            partialSave[title] = value;
          },
          validator: validatorFunction,
        );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Card(
        elevation: 2,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
            child: subtitleWidget,
          ),
        ),
      ),
    );
  }
}
