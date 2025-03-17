import 'dart:convert';
import 'package:activity_guide/utils/templateJson.dart';
import 'package:flutter/material.dart';

class MonthlyTemplate extends StatefulWidget {
  const MonthlyTemplate({super.key});

  @override
  State<MonthlyTemplate> createState() => _MonthlyTemplateState();
}

class _MonthlyTemplateState extends State<MonthlyTemplate> {

  //values holder
  Map<String,dynamic> partialSave = {};
  late List<TextEditingController> _controllers;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String json =
        '[{"ID": 1,"name": "OUTPUT","Type": "Dropdown","Range": "WORK PROGRAMME AND BUDGET,ACTIVITY GUIDE,CONFERENCES AND WORKSHOP"},{"ID": 2,"name": "TYPE OF ACTIVITIES","Type": "Dropdown","Range": "SURVEY,SAS,WORKSHOP"}, {"ID": 3,"name": "FREQUENCY","Type": "Dropdown","Range": "DAILY,WEEKLY, MONTHLY"}, {"ID": 4,"name": "PLANNED  DATE","Type": "Date","Range": "Double Date"}, {"ID": 5,"name": "ACTUAL DATE","Type": "Date","Range": "Double Date"}, {"ID": 6,"name": "TARGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 7,"name": "ACTIVITIES DESCRIPTION","Type": "Dynamic","Range": "No default value required"}, {"ID": 8,"name": "OUTCOME","Type": "Dynamic","Range": "No default value required"}, {"ID": 9,"name": "PERCENTAGE  COMPLETED","Type": "Dynamic","Range": "No default value required"}, {"ID": 10,"name": "MILESTONE","Type": "Dropdown","Range": "N/A,PROPOSAL,PLANNING,EXCUTING,COMPLETION,SUBMISSION"}, {"ID": 11,"name": "BASELINE METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 12,"name": "KPI","Type": "Dynamic","Range": "No default value required"}, {"ID": 13,"name": "ACTUAL ACHIEVED METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 14,"name": "TOTAL BUDGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 15,"name": "APPROPRIATION","Type": "Dynamic","Range": "No default value required"}, {"ID": 16,"name": "DONOR","Type": "Dynamic","Range": "No default value required"}, {"ID": 17,"name": "RELEASED","Type": "Dynamic","Range": "No default value required"}, {"ID": 18,"name": "UTILIZED","Type": "Dynamic","Range": "No default value required"}, {"ID": 19,"name": "BALANCE","Type": "Dynamic","Range": "No default value required"}, {"ID": 20,"name": "MORE FUND","Type": "Dynamic","Range": "No default value required"}, {"ID": 21,"name": "CHALLENGES","Type": "Dropdown","Range": "NO CHALLENGES,FUNDS RELATED,RISKRELATED"}, {"ID": 22,"name": "REMARKS","Type": "Dynamic","Range": "No default value required"}]';

    List<dynamic> rawdata = jsonDecode(json);
    List<TemplateJson> data = rawdata.map((data)=> TemplateJson.fromJson(data)).toList();
    //registering the keys to the partialSave to be able to check if they are empty or not
    for(var item in data){
      partialSave[item.name] = '';
    }
   _controllers = List.generate(data.length, (index) => TextEditingController());


    return Scaffold(
      body: SingleChildScrollView(
        child: Form( key: _formKey,
          child: Column(
            children: List.generate(data.length, (index){
              return CustomCard(index,data[index].name,data[index].type,data[index].range,_formKey);
            }),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
        if(_formKey.currentState!.validate()){
          partialSave.forEach((key,v){
            partialSave[key] == '' ? print('${key} is required') : '';
          });
        }
      },child: Icon(Icons.save),),
    );


  }

  String? validatorFunction(String? v){
    if(v == null || v.isEmpty){
      return 'required';
    }
    return null;
  }
  void singleDateDialog(String title) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime
          .now()
          .year),
      lastDate: DateTime(DateTime
          .now()
          .year + 2),
    );
    if (selectedDate != null) {
      String _date =
          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
      partialSave[title] = _date;
      setState(() {});// to refresh the state in order to update the date
    }
  }

  doubleDateDialog(String title) {
    showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime
            .now()
            .year + 5),
        initialEntryMode: DatePickerEntryMode.calendarOnly)
        .then((onValue) {
      if (onValue != null) {
        String startDate =
            '${onValue.start.month}/${onValue.start.day}/${onValue.start.year}';
        String endDate =
            '${onValue.end.month}/${onValue.end.day}/${onValue.end.year}';
      String  multipleDateString = startDate + '-' + endDate;
            partialSave[title] = multipleDateString;
            setState(() {

            });
       // setCellValue(sn, columnName, multipleDateString);
      }

    });
  }

  Widget CustomCard(int index,String title,String type,String range,Key _key){
    Widget subtitleWidget = Container();
    // Get the width of the device
    double width = MediaQuery.of(context).size.width;
    double horizontalPadding = width >1000 ? width/4 : width/6;

    switch(type){
      case 'Dropdown':
        subtitleWidget = DropdownMenu<String>(
          initialSelection: partialSave[title] ?? '',
          dropdownMenuEntries: range
              .toString()
              .split(',')
              .map<DropdownMenuEntry<String>>(
                  (e) => DropdownMenuEntry(value: e, label: e))
              .toList(),
          inputFormatters: [
          //  FilteringTextInputFormatter.deny(RegExp(r'.'))
          ],
          onSelected: (v) {
          partialSave[title] = v;
          },
        );
        break;
      case 'Date':
        _controllers[index].text = partialSave[title] ?? '';
       range == 'Single Date'
            ?
        // Render Date Picker
      subtitleWidget =  Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Expanded(child: TextFormField(controller: _controllers[index],
                validator: validatorFunction,)),
              TextButton(
                child: Icon(Icons.arrow_drop_down_circle),
                onPressed: () {
                    singleDateDialog(title);
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

              Expanded(child: TextFormField(controller: _controllers[index],
              validator: validatorFunction)),
              TextButton(
                child: Icon(Icons.arrow_drop_down_circle),
                onPressed: () {
                  doubleDateDialog(title);
                  print(partialSave[title]);
                },
              ),
            ],
          ),
        );
        break;
      case 'Dynamic':
        _controllers[index].text = partialSave[title] ?? '';
        subtitleWidget = TextFormField(
          controller: _controllers[index],
  minLines: 1, maxLines: 3,
    onChanged: (value) {
    partialSave[title]= value;
    },validator: validatorFunction,
    );
    }

    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding,vertical: 8),
      child: Card(color: Colors.white,
        child: ListTile(
          title:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 24,top: 8,bottom: 8),
            child: subtitleWidget,
          ),
      ),),
    );
  }
}

