import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc_event.dart';
import 'package:activity_guide/sub_admin/template_builder_page/view/builder_dialog.dart';
import 'package:activity_guide/shared/utils/rowdata_model.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc_state.dart';

import '../../../shared/theme/text_styles.dart';
import '../../../shared/utils/colors.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../shared/utils/http_helper/storage_keys.dart';
import '../../../shared/utils/myshared_preference.dart';
import '../../template_list_page/bloc/template_event.dart';
import '../../template_list_page/bloc/template_state.dart';

class TemplateBuilderUpdate extends StatefulWidget {
  const TemplateBuilderUpdate({super.key});

  @override
  State<TemplateBuilderUpdate> createState() => _TemplateBuilderUpdateState();
}

class _TemplateBuilderUpdateState extends State<TemplateBuilderUpdate> {
  List<RowData>? rows;
  TextEditingController controller = TextEditingController();
  final displayKey = GlobalKey<FormState>();
  String? title,initailDisplayName;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double horizontalPadding = width > 1000 ? width / 4 : width / 4;
    return MultiBlocListener(
      listeners: [
        BlocListener<BuilderBloc, BuilderState>(
          listener: (context, state) {
            rows = state.rows;
          },
        ),
        BlocListener<TemplateBloc, TemplateState>(
          listener: (context, state) {
            if (state is TemplateLoadingState) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
            } else if (state is TemplateSuccessState) {
              EasyLoading.showSuccess('Success');
              context.read<BuilderBloc>().add(ClearBuilderDataEvent());
              context.beamToNamed('/admin/templates');
            } else if (state is TemplateFailureState) {
              EasyLoading.showError(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
          body: BlocBuilder<BuilderBloc, BuilderState>(
            builder: (context, state) {
              return Column(
                children: [
                  FutureBuilder<String?>(
                    future: MysharedPreference()
                        .getPreferencesWithoutEncrpytion(
                            BuilderKeys.workingtemplate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(''); // or a placeholder
                      } else if (snapshot.hasError) {
                        return Text('');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('');
                      } else {
                        if (!snapshot.data!.contains('Additional')) {
                          controller.text = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data!,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          title = 'add';
                          initailDisplayName = snapshot.data!.split('_')[1];
                          controller.text = snapshot.data!.split('_')[1];
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Editing Additional Template',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 500,
                                  child: Divider(
                                    color: ThemeMode.system == ThemeMode.light ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 500,
                                child: Form(
                                  key: displayKey,
                                  child: TextFormField(
                                    controller: controller,
                                    maxLines:2,
                                    decoration: const InputDecoration(
                                        labelText: 'Display Name'),
                                    validator: validatorFunction,
                                  ),
                                ),
                              ),

                            ],
                          );
                        }
                      }
                    },
                  ),
                  Expanded(
                    child: ReorderableListView(
                      padding: EdgeInsets.only(right: horizontalPadding),
                      onReorder: (oldIndex, newIndex) {
                        context.read<BuilderBloc>().add(ReorderEvent(
                            oldIndex: oldIndex, newIndex: newIndex));
                      },
                      children: List.generate(state.rows.length, (index) {
                        List<RowData> data = state.rows;
                        return customCard(
                          key: ValueKey(state.rows[index].id),
                          title: data[index].columnName,
                          type: data[index].dataType,
                          range: data[index].range,
                          index: index,
                          removeRow: (i) => context
                              .read<BuilderBloc>()
                              .add(RemoveRowEvent(index: i)),
                          editData: (i) => BuilderDialog().showBuilderDialog(
                              context: context,
                              id: i,
                              name: data[i].columnName,
                              type: data[i].dataType,
                              Rvalue: data[i].range),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: Stack(
            children: [
              Positioned(
                  right: 0,
                  top: MediaQuery.of(context).size.width / 12,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<BuilderBloc, BuilderState>(
                      builder: (context, state) {
                        return Text(
                          '${state.rows.length}',
                          style: AppTextStyles.tableColumns,
                        );
                      },
                    ),
                  )),
              // Add Button
              Positioned(
                right: 0,
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        BuilderDialog().showBuilderDialog(context: context);
                      },
                      tooltip: 'Add Row',
                      heroTag: 'add',
                      backgroundColor: Colors.black,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0, // Distance from the right edge
                top: MediaQuery.of(context).size.height / 4, // Below the center
                child: FloatingActionButton(
                  onPressed: () {
                    if (title != null && title!.isNotEmpty) {
                      if (displayKey.currentState!.validate()) {
                        context.read<TemplateBloc>().add(UpdateEvent(
                            rows: rows ?? [], displayName: controller.text));
                      }
                    } else {
                      context
                          .read<TemplateBloc>()
                          .add(UpdateEvent(rows: rows ?? []));
                    }
                  },
                  tooltip: 'Update',
                  heroTag: 'update',
                  backgroundColor: Colors.green,
                  child: const Icon(
                    Icons.upload_file_outlined,
                    color: light,
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget customCard(
      {Key? key,
      int? index,
      title,
      String? type,
      String? range,
      Function(int index)? removeRow,
      Function(int index)? editData}) {
    Widget subtitleWidget = Container();
    // Get the width of the device
    double width = MediaQuery.of(context).size.width;
    double horizontalPadding = width > 1000 ? width / 4 : width / 8;

    switch (type) {
      case 'Dropdown':
        subtitleWidget = DropdownButtonFormField<String>(
          key: key,
          items: range
              .toString()
              .split(',')
              .toSet()
              .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                    key: key,
                    value: e,
                    child: Tooltip(
                      message: e,
                      child: Text(
                        e,
                        key: key,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (String? value) {},
          isExpanded: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        );
        break;
      case 'Date':
        range == 'Single Date'
            ?
            // Render Date Picker
            subtitleWidget = Align(
                key: key,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Text(key: key, '')),
                    TextButton(
                      key: key,
                      child: const Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        singleDateDialog(title!);
                      },
                    ),
                  ],
                ),
              )
            : subtitleWidget = Align(
                key: key,
                alignment: Alignment.centerRight,
                child: Row(
                  key: key,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        key: key,
                        child: TextFormField(
                          key: key,
                          enabled: false,
                          style: const TextStyle(color: Colors.black),
                        )),
                    TextButton(
                      child: Icon(key: key, Icons.arrow_drop_down_circle),
                      onPressed: () {
                        doubleDateDialog(title!);
                      },
                    ),
                  ],
                ),
              );
        break;
      case 'TextField':
        subtitleWidget = TextFormField(
          key: key,
          minLines: 1,
          maxLines: 3,
          onChanged: (value) {},
        );
        break;
      case 'Dropdown using active workplan columns':
        subtitleWidget = Text(
            'Data from ${range} column in active workplan will be use for the Dropdown list');
        break;
    }
    //here
    return Padding(
      key: key,
      padding: width > 1000
          ? EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: horizontalPadding,
              right: horizontalPadding / 2)
          : EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: horizontalPadding / 2,
              right: horizontalPadding / 2),
      child: Card(
        key: key,
        shape: Border.all(color: active),
        child: ListTile(
          key: key,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                key: key,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  key: key,
                  title!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.yellow)),
                      onPressed: () {
                        editData!(index!);
                      },
                      tooltip: 'Edit',
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Remove Button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red)),
                      onPressed: () {
                        removeRow!(index!);
                      },
                      tooltip: 'Remove Row',
                      icon: const Icon(
                        Icons.remove,
                        color: light,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            key: key,
            padding: const EdgeInsets.only(left: 24, top: 8, bottom: 8),
            child: subtitleWidget,
          ),
        ),
      ),
    );
  }

  void singleDateDialog(String title) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selectedDate != null) {
      String _date =
          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
      // partialSave[title] = _date;
      setState(() {}); // to refresh the state in order to update the date
    }
  }

  void doubleDateDialog(String title) {
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
        //partialSave[title] = multipleDateString;
        setState(() {});
      }
    });
  }
}
