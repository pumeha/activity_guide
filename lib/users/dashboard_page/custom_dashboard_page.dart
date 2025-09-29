import 'package:activity_guide/shared/custom_widgets/app_text.dart';
import 'package:activity_guide/shared/custom_widgets/custom_button.dart';
import 'package:activity_guide/shared/custom_widgets/custom_hv_scrollbar.dart';
import 'package:activity_guide/shared/custom_widgets/my_card.dart';
import 'package:activity_guide/shared/custom_widgets/reuseable_dropdown.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/users/dashboard_page/dashboard_helper.dart';
import 'package:activity_guide/users/dashboard_page/monthly_j2d.dart';
import 'package:activity_guide/users/dashboard_page/piechart.dart';
import 'package:activity_guide/users/home_page/cubit/user_home_cubit.dart';
import 'package:activity_guide/users/home_page/cubit/user_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/utils/my_barchart.dart';
import 'package:intl/intl.dart';
import 'dashboard_output_metric.dart';

class CustomDashboardPage extends StatefulWidget {
  const CustomDashboardPage({super.key});

  @override
  State<CustomDashboardPage> createState() => _CustomDashboardPageState();
}

class _CustomDashboardPageState extends State<CustomDashboardPage> {
  TextEditingController dateRangeController = TextEditingController();
  List<String> myData = [];
  List<MonthlyJ2D> allMonthlyData = [];
  List<DashboardOutputMetric> allOutputMetric = [];
  List<String> listOfAvaliableDepts = [];
  List<MonthlyJ2D> filteredMonthlyData = [];
  List<DashboardOutputMetric> filteredOutputMetric = [];
  List<String> listOfUnits = [];
  List<ActivityAndValues> top3Activities = [];
  List<ActivityAndValues> bottom3Activities = [];
  String? selectedDept, selectedUnit,selectedActivity,selectedActivityTargetAndAchieved;
  double selectedActivityTarget = 0,selectedActivityAchieved = 0;
  int? totalSelectedDateRangeActivity = 0;
  String selectedActivityTargetKey = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserHomeCubit,UserHomeState>(
      listener: (BuildContext context, UserHomeState state) {
        if (state is UserHomeLoading) {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
        } else if (state is UserHomeSuccess) {
          EasyLoading.showSuccess('Success');
          allMonthlyData = state.data[0];
          allOutputMetric = state.data[1];
          allOutputMetric.map((e)=>print(e.dept+'-'+e.unit+'-'+e.output+'-'+e.months.toString())).toList();

         listOfAvaliableDepts = allOutputMetric.map((e)=>e.dept).toSet().toList();
        // totalSelectedDateRangeActivity
          refresh();
        } else if (state is UserHomeFailure) {
          EasyLoading.showError(state.message!);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomHVScrollBar(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _title(),
              Row(
                spacing: 4,
                children: [
                  _filters(context: context, onPressed: () {
                    List<String> rangeParts = dateRangeController.text.split('-');
                    DateTime startDate = DateFormat('d/M/yyyy').parse(rangeParts[0]);
                    DateTime endDate = DateFormat('d/M/yyyy').parse(rangeParts[1]);

                    filteredMonthlyData = allMonthlyData.where((e){
                      return e.dept == selectedDept && e.unit == selectedUnit && e.createdAt.isAfter(startDate.subtract(Duration(days: 1))) &&
                          e.createdAt.isBefore(endDate.add(Duration(days: 1)));
                    }).toList();
                    List<String> selectedMonths = getMonthsInRange(dateRangeController.text);
                    filteredOutputMetric = allOutputMetric.where((e){
                      return e.dept == selectedDept && e.unit == selectedUnit && e.months.any((month) => selectedMonths.contains(month));
                    }).toList();

                    totalSelectedDateRangeActivity = filteredOutputMetric.length;
                    List data = allOutputMetric.map((e)=>e.values).toList();

                    data.map((e)=>print(e)).toList();
                    data = allOutputMetric.map((e)=>e.months).toList();

                    data.map((e)=>print(e)).toList();

                    myData.clear();
                    selectedActivityTarget = 0;
                    selectedActivityAchieved = 0;
                    // Step 1: Sort the data

                    List<dynamic> sortedData = List.from(filteredMonthlyData)
                      ..sort((a, b) => b.percentCompleted.compareTo(a.percentCompleted)); // Descending

                    // Step 2: Take top and bottom 3
                    top3Activities = sortedData.take(3).map((e) {
                      return ActivityAndValues(
                        output: e.output,
                        percentCompleted: e.percentCompleted, // or e.value if applicable
                      );
                    }).toList();

                    bottom3Activities = sortedData.reversed.take(3).map((e) {
                      return ActivityAndValues(
                        output: e.output,
                        percentCompleted: e.percentCompleted,
                      );
                    }).toList();


                    refresh();

                  }),
                  Column(
                    children: [
                      Card(elevation: 4,
                        color: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _widget(
                                title: 'Total Activities',
                                value: totalSelectedDateRangeActivity.toString(),
                                titleBackground: Colors.lightBlue),
                            _widget(
                                title: 'Active Activities',
                                value: filteredMonthlyData.length.toString(),
                                titleBackground: active),
                            _widget(
                                title: 'Inactive Activities',
                                value:  totalSelectedDateRangeActivity == 0?'0':'${totalSelectedDateRangeActivity!-filteredMonthlyData.length}',
                                titleBackground: Colors.red),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      MyCard(
                        child: Row(
                          children: [
                            HorizontalColumnChart(
                              barColor: Colors.teal,
                              title: 'Top 3 Activities', data: top3Activities,
                            ),
                            HorizontalColumnChart(
                              barColor: Colors.orange,
                              title: 'Bottom 3 Activities',data: bottom3Activities,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  MyCard(
                    child: Column(mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: DoughnutChart(),
                          height: 200,
                        ),
                        SizedBox(
                          child: QualitativeSpeedometer(),
                          width: 300,
                        height: 300,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  SizedBox(
                    width: 500,
                    child: MyCard(
                      child: Column(
                        children: [
                          CustomDropdown(
                              labelText: '',
                              selectedItem: selectedActivity,
                              items: const [
                                'All Activities',
                                'Active Activities',
                                'Inactive Activities'
                              ],
                              onChanged: (v) {
                                selectedActivity = v;
                                List<String> all = filteredOutputMetric.map((e)=>e.output).toList();
                                List<String> activeActivities = filteredMonthlyData.map((e)=>e.output).toList();
                                if(selectedActivity == 'All Activities'){
                                  myData = all;
                                }else if(selectedActivity == 'Active Activities'){
                                  myData = activeActivities;
                                }else if(selectedActivity == 'Inactive Activities'){
                                  myData = all.where((e) => !activeActivities.contains(e)).toList();
                                }
                             refresh();
                              }),
                          DataTableWidget(
                            detailsList: myData,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      SizedBox(width: 400,
                        child: MyCard(
                          child: Column(
                            children: [
                              CustomDropdown(
                                  labelText: '',
                                  selectedItem: selectedActivityTargetAndAchieved,
                                  items: filteredMonthlyData.map((e)=>e.output).toList(),
                                  onChanged: (v) {
                                    selectedActivityTargetAndAchieved = v;
                                  MonthlyJ2D d =  filteredMonthlyData.firstWhere((e)=>e.output==selectedActivityTargetAndAchieved,
                                    );
                                    selectedActivityTargetKey = extractLetters(d.actualTargetMetrics)!;
                                  selectedActivityTarget = extractFirstNumberAsDouble(d.actualTargetMetrics) ?? 0;
                                    selectedActivityAchieved = extractFirstNumberAsDouble(d.actualAchievedMetrics) ?? 0;
                                    refresh();
                                  }),
                              ColumnChart(
                                barColor: Colors.teal,target: selectedActivityTarget,achieved: selectedActivityAchieved,
                                title: selectedActivityTargetKey!.isNotEmpty ?'Target vs Achieved[${selectedActivityTargetKey ?? ''}]':'Target vs Achieved',
                              ),
                            ],
                          ),
                        ),
                      ),
                      PieChartWithPercentages(),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context
                .read<UserHomeCubit>()
                .downloadDashboardData(templateType: 'Monthly');
          },
          backgroundColor: active,
          child: const Icon(
            Icons.update,size: 24,
            color: Colors.white,
          ),
        ),
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
        ],
      ),
    );
  }

  Widget _filters({required BuildContext context, required VoidCallback onPressed}) {

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
                    items: listOfAvaliableDepts,
                    onChanged: (v) {
                      selectedDept = v;
                      listOfUnits = allOutputMetric.map((e)=>e.unit).toSet().toList();
                      setState(() {

                      });
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomDropdown(
                    labelText: 'Select Unit',
                    selectedItem: selectedUnit,
                    items: listOfUnits,
                    onChanged: (v) {
                      selectedUnit = v;
                    }),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text: 'Filter',
                  onPressed: onPressed,
                  fullWidth: true,
                  trailing: Icon(
                    Icons.filter_alt,
                    color: Colors.white,
                  ),
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
            '${onValue.start.day}/${onValue.start.month}/${onValue.start.year}';
        String endDate =
            '${onValue.end.day}/${onValue.end.month}/${onValue.end.year}';
        multipleDateString = startDate + '-' + endDate;

        setState(() {
          controller.text = multipleDateString;
        });
      }
    });
  }

  void refresh() {
    setState(() {

    });
  }
}

class ActivityAndValues {
  final String output;
  final int percentCompleted;

  ActivityAndValues({
    required this.output,
    required this.percentCompleted,
  });

  @override
  String toString() => 'ActivityAndValues(output: $output, value: $percentCompleted)';
}