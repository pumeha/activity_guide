import 'dart:convert';
import 'package:activity_guide/models/myshared_preference.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'data_grid_source.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {

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
    String? template = await MysharedPreference().getPreferences('template');
    _jsonColumns = List<Map<String,dynamic>>.from(jsonDecode('[{"ID": 0,"name": "S/N","Type": "Dynamic","Range": "No default value required"}]'));
    _jsonColumns.addAll(List<Map<String,dynamic>>.from(jsonDecode(template!)));
    _addColumnsFromJson();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Preview Template'),),
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
      floatingActionButton: FloatingActionButton(tooltip: 'Download Sample Data',onPressed: () {
          // final Workbook workbook = key.currentState!.exportToExcelWorkbook();
          // final List<int> bytes = workbook.saveAsCSV(',');
          // File('Test.csv').writeAsBytes(bytes,flush: true);
      },
        child: const Icon(Icons.save_alt),backgroundColor: Colors.green.shade50,),
    );
  }
}
