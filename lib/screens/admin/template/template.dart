import 'dart:convert';
import 'package:activity_guide/models/myshared_preference.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../providers/template_provider.dart';
import '../../../views/widgets/myapp_bar.dart';
import 'data_grid_source.dart';
import 'package:provider/provider.dart';
import '';


class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {

  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late Map<String, double> columnWidths = {
    'Name': double.nan,
    'Age': double.nan,
    'Job': double.nan,
    'Planned Start': double.nan
  };
  late MyDataSource _dataSource;
  List<Map<String, dynamic>> _jsonColumns =  [];
  List<GridColumn> _columns = [];


  @override
  void initState() {
    super.initState();
    _dataSource = MyDataSource(4,context);
    loadJSONFromPrefs();
  }

  void _addColumnsFromJson() {
    // print(_jsonColumns.length);
    setState(() {

      for (var col in _jsonColumns) {
        _columns.add(_buildGridColumn(
            col['name'],
            col['Type'],
            width: col['name'] == 'S/N' ? 50 : 200
        ));
        _dataSource.addColumn(col['name']);
      }


    });
  }

  GridColumn _buildGridColumn(String columnName, String type,{double width = 200}) {
    return GridColumn(
        columnName: columnName,
        label: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(columnName),
        ),width: width
    );
  }

  Future<void> loadJSONFromPrefs() async{
    String value = '[{"ID": 1,"name": "OUTPUT","Type": "Dropdown","Range": "Power Farm Solution for NBS Headquarters /SOLAR ENERGY, Establishing GIS Lab for  Geo-Spatial Modelling Unit, Building Big Data/Data Science Lab, Implementation of Data Privacy/Data Protection Policy in NBS, Re-construction of NBS HQ Data Warehousing and Network Infrastructure, Provision of Statistical Softwares and Packages for Analysis, Workshop on Further Analysis using various Statistical Packages HQ and Zonal Offices, Capacity Building ,Workshop on Field Data collection Tools  for Surveys Questionnaires design and data collection using various Computer Assisted Personal Interview (CAPI) solutions Survey Solutions CSPro  ODK Kobo SurveyCTO e.t.c, Provision of 2 additional Cloud Server and Exchange, Web Server Platform & Backups Maintenance of HQ network ports Acces Points for Sustainance and Expansion of Internet Connection in the Office. , Provision of Norton EndPoint Server Antivirus for the Year 2024.   ,Quarterly Maintenance of Systems at the Headquarters Zones and States."}, {"ID": 2,"name": "TYPE OF ACTIVITIES","Type": "Dropdown","Range": "SURVEY,SAS,WORKSHOP"}, {"ID": 3,"name": "FREQUENCY","Type": "Dropdown","Range": "DAILY,WEEKLY, MONTHLY"}, {"ID": 4,"name": "PLANNED  DATE","Type": "Date","Range": "Double Date"}, {"ID": 5,"name": "ACTUAL DATE","Type": "Date","Range": "Double Date"}, {"ID": 6,"name": "TARGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 7,"name": "ACTIVITIES DESCRIPTION","Type": "Dynamic","Range": "No default value required"}, {"ID": 8,"name": "OUTCOME","Type": "Dynamic","Range": "No default value required"}, {"ID": 9,"name": "PERCENTAGE  COMPLETED","Type": "Dynamic","Range": "No default value required"}, {"ID": 10,"name": "MILESTONE","Type": "Dropdown","Range": "N/A,PROPOSAL,PLANNING,EXCUTING,COMPLETION,SUBMISSION"}, {"ID": 11,"name": "BASELINE METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 12,"name": "KPI","Type": "Dynamic","Range": "No default value required"}, {"ID": 13,"name": "ACTUAL ACHIEVED METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 14,"name": "TOTAL BUDGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 15,"name": "APPROPRIATION","Type": "Dynamic","Range": "No default value required"}, {"ID": 16,"name": "DONOR","Type": "Dynamic","Range": "No default value required"}, {"ID": 17,"name": "RELEASED","Type": "Dynamic","Range": "No default value required"}, {"ID": 18,"name": "UTILIZED","Type": "Dynamic","Range": "No default value required"}, {"ID": 19,"name": "BALANCE","Type": "Dynamic","Range": "No default value required"}, {"ID": 20,"name": "MORE FUND","Type": "Dynamic","Range": "No default value required"}, {"ID": 21,"name": "CHALLENGES","Type": "Dropdown","Range": "NO CHALLENGES,FUNDS RELATED,RISKRELATED"}, {"ID": 22,"name": "REMARKS","Type": "Dynamic","Range": "No default value required"}]';
    await MysharedPreference().setPreferences('template', value);
    String? template = await MysharedPreference().getPreferences('template');
    _jsonColumns = List<Map<String,dynamic>>.from(jsonDecode('[{"ID": 0,"name": "S/N","Type": "Dynamic","Range": "No default value required"}]'));
    _jsonColumns.addAll(List<Map<String,dynamic>>.from(jsonDecode(template!)));
    _addColumnsFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SfDataGrid(
          key: key,
          source: _dataSource,
          columns: _columns,
          rowHeight: 80,
          isScrollbarAlwaysShown: true,
          frozenColumnsCount: 1,
          allowColumnsResizing: true,
          onColumnResizeStart: (ColumnResizeStartDetails details){
            return true;
          },
          onColumnResizeUpdate:  (ColumnResizeUpdateDetails details){
            setState(() {
              columnWidths[details.column.columnName] = details.width;
            });
            return true;
          },
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnWidthMode: ColumnWidthMode.fill,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          columnResizeMode: ColumnResizeMode.onResize,
          sortingGestureType: SortingGestureType.tap,

          footer: Row( mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(onPressed: (){
                    setState(() {
                      _dataSource.addRow();

                    });
                  },color: Colors.green[50],
                    child: const Text('Add Row',style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold),),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(onPressed: (){
                    setState(() {
                      _dataSource.rows.removeLast();
                      _dataSource.notifyListeners();
                    });
                  },color: Colors.red.shade400,
                    child: const Text('Remove Row',style: TextStyle(color: light,
                        fontWeight: FontWeight.bold),),),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(tooltip: 'Save',onPressed: () {
        // final Workbook workbook = key.currentState!.exportToExcelWorkbook();
        // final List<int> bytes = workbook.saveAsCSV(',');
        // File('Test.csv').writeAsBytes(bytes,flush: true);

      },
        child: const Icon(Icons.save),backgroundColor: Colors.green.shade50,),
    );
  }
}