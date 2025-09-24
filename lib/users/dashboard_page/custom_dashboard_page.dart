import 'package:activity_guide/shared/custom_widgets/app_text.dart';
import 'package:activity_guide/shared/custom_widgets/custom_button.dart';
import 'package:activity_guide/shared/custom_widgets/reuseable_dropdown.dart';
import 'package:activity_guide/shared/theme/text_styles.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/my_barchart.dart';

class CustomDashboardPage extends StatefulWidget {
  const CustomDashboardPage({super.key});

  @override
  State<CustomDashboardPage> createState() => _CustomDashboardPageState();
}

class _CustomDashboardPageState extends State<CustomDashboardPage> {
  TextEditingController dateRangeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          filterDialog(context: context, onPressed: () {});
        },
        backgroundColor: active,
        child: const Icon(
          Icons.filter_alt,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _title(),
          Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: _filters(context: context, onPressed: () {})),
              Expanded(
                  flex: 5,
                  child: Row(spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    _widget(
                                        title: 'Total Activities',
                                        value: '12',
                                        titleBackground: Colors.lightBlue),
                                    _widget(
                                        title: 'Active Activities',
                                        value: '4',
                                        titleBackground: active),
                                    _widget(
                                        title: 'Inactive Activities',
                                        value: '8',
                                        titleBackground: Colors.red),
                                  ],
                                  mainAxisSize: MainAxisSize.min,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              HorizontalColumnChart(
                                barColor: Colors.teal,
                                title: 'Top 3 Activities',
                              ),
                              HorizontalColumnChart(
                                barColor: Colors.orange,
                                title: 'Bottom 3 Activities',
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          DoughnutChart(),
                          SizedBox(child: QualitativeSpeedometer(),height: 300,),
                          SizedBox(height: 12,),
                        ],
                      )

                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 32, right: 50, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    '/images/nbs.png',
                    width: 60,
                    height: 60,
                  ),
                  const Text(
                    'Activity Guide Monthly Report',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Image.asset('/images/dashboard.gif')
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Refresh',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.green[800])),
          )
        ],
      ),
    );
  }

  Widget _filters(
      {required BuildContext context, required VoidCallback onPressed}) {
    String? selectedDept, selectedUnit;
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.white,
          child: Column(
           mainAxisSize: MainAxisSize.min,
            children: [
              const AppText(
                text: 'Filters',
                fontSize: 24,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                    labelText: 'Select Year',
                    selectedItem: '2025',
                    items: const ['2025'],
                    onChanged: (v) {}),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                    labelText: 'Select Dept',
                    selectedItem: selectedDept,
                    items: const ['CPSCD', 'LEGAL'],
                    onChanged: (v) {}),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                    labelText: 'Select Unit',
                    selectedItem: selectedUnit,
                    items: const ['CPSCD', 'LEGAL'],
                    onChanged: (v) {}),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Date Range'),
                    CustomButton(
                      text: 'Select',
                      onPressed: () {
                        doubleDateDialog(dateRangeController);
                      },
                      type: ButtonType.outlined,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  controller: dateRangeController,
                  validator: validatorFunction,
                  readOnly: true,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     spacing: 12,
              //     children: [
              //       Expanded(
              //         child: CustomButton(
              //           text: 'Cancel',
              //           onPressed: () => Navigator.pop(context),
              //           type: ButtonType.text,
              //           textColor: Colors.red,
              //         ),
              //       ),
              //       Expanded(
              //         child: CustomButton(
              //           text: 'Proceed',
              //           onPressed: onPressed,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _widget(
      {required String title,
      required String value,
      required Color titleBackground}) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AppText(
              text: title,
              color: Colors.white,
              bold: true,
            ),
          ),
          color: titleBackground,
        ),
        Container(
          child: AppText(
            text: value,
            fontSize: 32,
            bold: true,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        )
      ],
    );
  }

  filterDialog(
      {required BuildContext context, required VoidCallback onPressed}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filter Dialog',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Align(
            alignment: Alignment.center, // Positions dialog at the bottom
            child: Material(
              color: Colors.transparent,
              child: _filters(context: context, onPressed: onPressed),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  void doubleDateDialog(TextEditingController controller) {
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
        controller.text = multipleDateString;
      }
    });
  }
}
