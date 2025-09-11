import 'dart:convert';
import 'dart:math';
import 'package:activity_guide/shared/custom_widgets/custom_metric.dart';
import 'package:activity_guide/shared/utils/output_metric_json.dart';
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
import 'package:intl/intl.dart';

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
  late List<String> _labels;
  List<dynamic> _editValues = [];
  int plannedEnd = 0,actualEnd = 0,actualTarget = 0;
  List<OutputMetricJson> _outputMetric = [];
  final DateFormat format = DateFormat('M/d/yyyy');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocBuilder<DataCollectionBloc, DataCollectionState>(
        builder: (context, state) {
          List<TemplateJson> data = state.data!.map((data) => TemplateJson.fromJson(data)).toList();
          data.forEach((e) {
            if (e.name.toLowerCase() == 'output') {
              e.range = state.outputMetric!.map((e) => e.output).join(',');
            }
          });
          _outputMetric = state.outputMetric!;

          _controllers = List.generate(data.length, (index) {
            return TextEditingController();
          });
          _labels = List.generate(data.length, (index) => data[index].name);

          if (state is DataCollectionEditState) {
            _editValues = state.editData;
            for (int i = 0; i < _controllers.length; i++) {
              _controllers[i].text = _editValues[0][_labels[i]] ?? '';
              partialSave[_labels[i]] = _editValues[0][_labels[i]] ?? null;
            }
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.templateType!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: List.generate(data.length, (index) {

                        if(data[index].name.contains('PLANNED END')){
                          plannedEnd = index;
                        }else if(data[index].name.contains('ACTUAL END')){
                          actualEnd = index;
                        }else if(data[index].name.contains('ACTUAL TARGET')){
                          actualTarget = index;

                        }
                        return CustomCard(
                            index,
                            data[index].name,
                            data[index].type,
                            data[index].range,
                            _formKey,
                            _editValues,
                            _labels);
                      }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
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
                        data[_labels[i]] = _controllers[i].text;
                      }

                      if (_editValues.isNotEmpty) {
                        context.read<DataCollectionBloc>().add(
                            AddDataFromDataCollectionEvent(
                                data: data, updateId: _editValues[0]['ID']));
                      } else {
                        context
                            .read<DataCollectionBloc>()
                            .add(AddDataFromDataCollectionEvent(data: data));
                      }
                      for (var element in _controllers) {
                        element.clear();
                      }
                      for (int i = 0; i < data.length; i++) {
                        partialSave[_labels[i]] = null;
                      }
                      EasyLoading.showSuccess('Success');

                      refreshPage();
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
                const SizedBox(
                  height: 12,
                ),
                BlocBuilder<DataCollectionBloc, DataCollectionState>(
                  builder: (context, state) {
                    if (state is DataCollectionEditState) {
                      return FloatingActionButton(
                        onPressed: () {
                          context
                              .read<DataCollectionBloc>()
                              .add(LoadSelectedDataCollectionTemplateEvent());
                          for (int i = 0; i < _labels.length; i++) {
                            partialSave[_labels[i]] = null;
                          }
                          _editValues.clear();
                        },
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      return Container();
                    }
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
                    Icons.description_outlined,
                    color: Colors.black,
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

  void refreshPage() {
    setState(() {});
  }

  void singleDateDialog(String title, TextEditingController controller) async {
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

  void doubleDateDialog(String title, TextEditingController controller) {
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
      _controllers[index].text = editValues[0][labels[index]];
      partialSave[title] =
          editValues[0][labels[index]]; //editValues[0]['Output']
    }

    switch (type) {
      case 'Dropdown':
        subtitleWidget = DropdownButtonFormField<String>(
          value: partialSave[title],
          items: range
              .toString()
              .split(',')
              .toSet()
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
            _controllers[index].text = value!;
            _controllers[actualTarget].text = _outputMetric.firstWhere((e)=> e.output == value).monthValue!;
            partialSave[_labels[actualTarget]] = _outputMetric.firstWhere((e)=> e.output == value).monthValue!;
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
                    Expanded(
                        child: TextFormField(
                      controller: _controllers[index],
                      validator: validatorFunction,
                      readOnly: true,
                    )),
                    TextButton(
                      child: Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        singleDateDialog(title, _controllers[index]);
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
                      readOnly: true,
                    )),
                    TextButton(
                      child: Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        doubleDateDialog(title, _controllers[index]);
                      },
                    ),
                  ],
                ),
              );
        break;
      case 'TextField':
        final match = RegExp(r'Q(\d+)').firstMatch(title);

        if (match != null) {
          subtitleWidget = CustomMetric(
            quarter: int.parse(match.group(1)!),
            onChanged: (Map<String, String> data) {
              _controllers[index].text = jsonEncode(data);
              partialSave[title] = jsonEncode(data);

            },
          );
        }else if(title.contains('END') || title.contains('ACTUAL TARGET(METRICS)')){
          subtitleWidget = TextFormField(
            controller: _controllers[index],
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {
              partialSave[title] = value;
            },
            validator: validatorFunction,
            readOnly: true,
          );
        }else if(title.contains('DURATION')){
          subtitleWidget = TextFormField(
            controller: _controllers[index],
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {

              partialSave[title] = value;
              if(title.contains('ACTUAL DURATION')){

                _controllers[actualEnd].text = format.format(addBusinessDays(
                  format.parse(partialSave['ACTUAL START']!),
                  int.tryParse(value) ?? 0,
                ));
              }else if(title.contains('PLANNED DURATION')){

                _controllers[plannedEnd].text = format.format(addBusinessDays(
                  format.parse(partialSave['PLANNED START']!),
                  int.tryParse(value) ?? 0,
                ));

              }
            },
            validator: validatorFunction,

          );
        }else {
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  DateTime addBusinessDays(DateTime startDate, int businessDays) {
    int addedDays = 0;
    DateTime date = startDate;

    while (addedDays < businessDays) {
      date = date.add(Duration(days: 1));
      // Skip Saturday (6) and Sunday (7)
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return date;
  }
}
