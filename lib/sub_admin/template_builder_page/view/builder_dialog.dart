import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import '../../../shared/utils/http_helper/storage_keys.dart';
import '../../../shared/utils/myshared_preference.dart';
import '../bloc/builder_bloc.dart';
import '../bloc/builder_bloc_event.dart';
import '../bloc/builder_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuilderDialog {
  Future<void> showBuilderDialog(
      {required BuildContext? context,
      int? id,
      String? name,
      String? type,
      String? Rvalue}) async {
    String? range;
    String? activeWorkplanColumns;
    String? templatePurpose =
        await MysharedPreference().getPreferences(BuilderKeys.purpose);

    if (templatePurpose != null && templatePurpose == 'mtemplate') {
      activeWorkplanColumns = await MysharedPreference()
          .getPreferencesWithoutEncrpytion('activeWorkplanColumns');

      if (activeWorkplanColumns != null && activeWorkplanColumns.isNotEmpty) {
        range =
            'TextField,Dropdown,Dropdown using active workplan columns,Date';
      }
      // range = 'TextField,Dropdown,Dropdown using active workplan columns,Date';
    } else {
      range = 'TextField,Dropdown,Date';
    }

    String? validatorFunction(String? v) {
      if (v == null || v.isEmpty) {
        return 'required';
      }
      return null;
    }

    final _formKey = GlobalKey<FormState>();
    Map<String, dynamic> partialSave = {};
    String dateType = 'Single Date,Double Date';

    //partialSave['date'] = type == 'Date' ? Rvalue : dateType;

    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    if (id != null) {
      partialSave['colType'] = type;
      context!
          .read<BuilderBloc>()
          .add(SelectDataTypeEvent(selectDataType: partialSave['colType']));
      nameController = TextEditingController(text: name);
      if (type == 'Dropdown') {
        valueController = TextEditingController(text: Rvalue);
      } else if (type == 'Date') {
        partialSave['date'] = Rvalue;
      } else if (type == 'Dropdown using active workplan columns') {
        partialSave['columnFromWorkplan'] = Rvalue;
      }
    }

    return showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: CustomText(
              text: id == null
                  ? 'Add Template Columns'
                  : 'Update Template Column',
              weight: FontWeight.bold,
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: 50,
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Format(
                              title: 'Column Name',
                              child: TextFormField(
                                controller: nameController,
                                minLines: 1,
                                maxLines: 3,
                                onChanged: (value) {},
                                validator: validatorFunction,
                              )),
                          Format(
                              title: 'Column Type',
                              child: DropdownButtonFormField<String>(
                                value: partialSave['colType'],
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
                                  partialSave['colType'] = value!;
                                  context.read<BuilderBloc>().add(
                                      SelectDataTypeEvent(
                                          selectDataType:
                                              partialSave['colType']));
                                },
                                isExpanded: true,
                                validator: validatorFunction,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              )),
                          BlocBuilder<BuilderBloc, BuilderState>(
                            builder: (context, state) {
                              Widget widget = Container();
                              if (state.selectDataType == 'TextField') {
                                widget = Format(
                                    child:
                                        const Text('No default value required'),
                                    title: 'Value');
                              } else if (state.selectDataType == 'Dropdown') {
                                widget = Format(
                                    title: 'Value',
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: valueController,
                                          maxLines: 4,
                                          minLines: 4,
                                          validator: validatorFunction,
                                        ),
                                        const Text(
                                            'Dropdown items are seperated by comma')
                                      ],
                                    ));
                              } else if (state.selectDataType ==
                                  'Dropdown using active workplan columns') {
                                //--------------------------------------------------------------------
                                widget = Format(
                                    title: 'Active workplan Columns',
                                    child: DropdownButtonFormField<String>(
                                      value: partialSave['columnFromWorkplan'],
                                      items: activeWorkplanColumns
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
                                        partialSave['columnFromWorkplan'] =
                                            value;
                                        valueController.text = value!;
                                      },
                                      isExpanded: true,
                                      validator: validatorFunction,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()),
                                    ));
                                //----------------------------------------------------------------------
                              } else if (state.selectDataType == 'Date') {
                                widget = Format(
                                  title: 'Value',
                                  child: DropdownButtonFormField<String>(
                                    value: partialSave['date'],
                                    items: dateType
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
                                      valueController.text = value!;
                                      partialSave['date'] = value;
                                    },
                                    isExpanded: true,
                                    validator: validatorFunction,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                  ),
                                );
                              }
                              return widget;
                            },
                          )
                        ],
                      )),
                ),
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  partialSave = {};
                  valueController.clear();
                  nameController.clear();
                  context.read<BuilderBloc>().add(SelectDataTypeEvent());
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<BuilderBloc>().add(AddRowEvent(
                          id: id,
                          columnName: nameController.text.trim(),
                          dataType: partialSave['colType'],
                          range: valueController.text.trim()));
                      //clear
                      partialSave = {};
                      valueController.clear();
                      nameController.clear();
                      context.read<BuilderBloc>().add(SelectDataTypeEvent());
                      if (id != null) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        BuilderDialog().showBuilderDialog(context: context);
                      }
                    }
                  },
                  child: Text(
                    id == null ? 'Add to List' : 'Update',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  Widget Format({String? title, Widget? child}) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: child,
      ),
    );
  }
}
