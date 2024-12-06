import 'dart:convert';
import 'package:activity_guide/models/myshared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../views/widgets/myapp_bar.dart';
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
    _dataSource = MyDataSource(4);
    loadJSONFromPrefs();
  }

  void _addColumnsFromJson() {
    setState(() {
      for (var col in _jsonColumns) {
        _columns.add(_buildGridColumn(
          col['name'],
          col['Type'],
          range: col['Range'],
        ));
        _dataSource.addColumn(col['name']);
      }
    });
  }

  GridColumn _buildGridColumn(String columnName, String type, {String? range}) {
    return GridColumn(
      columnName: columnName,
      label: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(columnName),
      ),width: 200
    );
  }

  Future<void> loadJSONFromPrefs() async{
    String? template = await MysharedPreference().getPreferences('template');
    _jsonColumns = List<Map<String,dynamic>>.from(jsonDecode(template!));
    _addColumnsFromJson();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const MyAppBar(title: 'Preview Template'),
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

          footer: MaterialButton(onPressed: (){
            setState(() {
           //   _dataSource.rows.add(DataGridRow(cells: _dataSource.rows[0].getCells()));
             // _dataSource.notifyListeners();
              print('add row');
              _dataSource.addRow();
            });
          },color: Colors.green,
            child: const Text('Add Row',style: TextStyle(color: Colors.black),),),
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