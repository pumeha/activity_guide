import 'package:activity_guide/shared/utils/rowdata_model.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../template_list_page/bloc/template_bloc.dart';
import '../template_list_page/bloc/template_state.dart';

class PreviewTemplate extends StatefulWidget {
  const PreviewTemplate({super.key});

  @override
  State<PreviewTemplate> createState() => _PreviewTemplateState();
}

class _PreviewTemplateState extends State<PreviewTemplate> {
  @override
  void initState() {
    super.initState();
  }

  //values holder
  Map<String, dynamic> partialSave = {};
  late List<TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Preview Template',
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BackButton(
            onPressed: () {
              context.beamToNamed('/admin/templates');
            },
            style: const ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(Color.fromARGB(255, 38, 32, 1)),
                iconColor: WidgetStatePropertyAll(Colors.white)),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Scaffold(
        body: BlocBuilder<TemplateBloc, TemplateState>(
          builder: (context, state) {
            if (state is TemplateSelectedState) {
              List<RowData> data = state.model.values;
              //registering the keys to the partialSave to be able to check if they are empty or not
              _controllers = List.generate(
                  data.length, (index) => TextEditingController());
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: List.generate(data.length, (index) {
                      return CustomCard(index, data[index].columnName,
                          data[index].dataType, data[index].range, _formKey);
                    }),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  String? validatorFunction(String? v) {
    if (v == null || v.isEmpty) {
      return 'required';
    }
    return null;
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
      partialSave[title] = _date;
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
        multipleDateString = '$startDate-$endDate';
        partialSave[title] = multipleDateString;
        setState(() {});
      }
    });
  }

  Widget CustomCard(
      int index, String title, String type, String range, Key _key) {
    Widget subtitleWidget = Container();
    // Get the width of the device
    double width = MediaQuery.of(context).size.width;
    double horizontalPadding = width > 1000 ? width / 4 : width / 6;

    switch (type) {
      case 'Dropdown':
        subtitleWidget = DropdownButtonFormField<String>(
          value: partialSave[title],
          items: range
              .toString()
              .split(',')
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
          },
          isExpanded: true,
          validator: validatorFunction,
          decoration: InputDecoration(border: OutlineInputBorder()),
        );
        break;
      case 'Date':
        _controllers[index].text = partialSave[title] ?? '';
        range == 'Single Date'
            ?
            // Render Date Picker
            subtitleWidget = Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(child: Text(partialSave[title] ?? '')),
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
                    Expanded(
                        child: TextFormField(
                      controller: _controllers[index],
                      validator: validatorFunction,
                      readOnly: true,
                    )),
                    TextButton(
                      child: const Icon(Icons.arrow_drop_down_circle),
                      onPressed: () {
                        doubleDateDialog(title);
                      },
                    ),
                  ],
                ),
              );
        break;
      case 'TextField':
        _controllers[index].text = partialSave[title] ?? '';
        subtitleWidget = TextFormField(
          controller: _controllers[index],
          minLines: 1,
          maxLines: 3,
          onChanged: (value) {
            partialSave[title] = value;
          },
          validator: validatorFunction,
        );
        break;
      case 'Dropdown using active workplan columns':
        subtitleWidget = Text(
            'Data from ${range} column in active workplan will be use for the Dropdown list');
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Card(
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
