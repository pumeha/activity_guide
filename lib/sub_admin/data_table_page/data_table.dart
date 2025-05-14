import 'dart:convert';
import 'dart:html';
import 'package:activity_guide/shared/utils/downloadExcelFile.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../shared/utils/constants.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

  class _MyTableState extends State<MyTable> {
  late JSONDataGridSource _jsonDataGridSource;
  late List<GridColumn> columns;
  late List<dynamic> data;
final GlobalKey<SfDataGridState> sfKey = GlobalKey<SfDataGridState>();

  Future populateData() async{
    String? response = await MysharedPreference().getPreferencesWithoutEncrpytion(template_data);

        data = json.decode(response!) as List<dynamic>;
      if(data.isNotEmpty){
        columns = generateColumns(data[0]);
        _jsonDataGridSource = JSONDataGridSource(data,columns);
      }
      return data;
   


  }

  List<GridColumn> generateColumns(Map<String,dynamic> data){
    List<GridColumn> columns = [];
    for(var entry in data.entries){
      GridColumn gridColumn = GridColumn(columnName: entry.key,
          label: Container(padding: const EdgeInsets.all(8),color: Colors.white,
          alignment: Alignment.center,
          child: Text(entry.key.replaceAll('_', ' ').toUpperCase(),style: const TextStyle(color: Colors.black,fontSize: 14,
          ),),));
   columns.add(gridColumn);
    }
    return columns;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
final DataGridController controller = DataGridController();


  @override
  Widget build(BuildContext context) {

    return Scaffold( backgroundColor: Colors.white70,
      body: FutureBuilder(
         future: populateData(),builder: (context,snapshot){
         if(snapshot.connectionState == ConnectionState.done){
      
           return  SfDataGrid(
             key: sfKey,
             controller: controller,
             source: _jsonDataGridSource,
             columns: columns,
             gridLinesVisibility: GridLinesVisibility.both,
             headerGridLinesVisibility: GridLinesVisibility.both,
             columnWidthMode: ColumnWidthMode.auto,
             allowFiltering: true,
             allowSorting: true,
             allowMultiColumnSorting: true,
             allowTriStateSorting: true,
             showVerticalScrollbar: true,
             showHorizontalScrollbar: true,
             navigationMode: GridNavigationMode.row,
             selectionMode: SelectionMode.multiple,
           );
         }
         return customCircleIndicator();
       }, ),
      floatingActionButton: FloatingActionButton(onPressed: () async{

      },child: const Icon(Icons.save_alt),),
    );
  }

  Future<void> _exportDataGridToExcel() async {
  
  if (sfKey.currentState == null) {
    print('SfDataGridState is null. The DataGrid might not be built yet.');
    EasyLoading.showError('Data grid is not ready yet!');
    return;
  }

    try {
  final Workbook workbook = sfKey.currentState!.exportToExcelWorkbook();

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();
  
  AnchorElement(href:"data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", "output.csv")
    ..click();
} on Exception catch (e) {
  print(e.toString());
}
  }

}

 
class JSONDataGridSource extends DataGridSource{

  List<DataGridRow> dataGridRows = [];

  JSONDataGridSource(List<dynamic> data,
      List<GridColumn> columns){
    dataGridRows = data.map((value)=>
    DataGridRow(cells: columns.map((column)=>
    DataGridCell(columnName: column.columnName.replaceAll('_', ' ').toUpperCase(),
        value: value[column.columnName])).toList())).toList();
  }


  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
   return DataGridRowAdapter(cells:
   row.getCells().map((cell)=>
   Padding(
     padding: const EdgeInsets.all(8.0),
     child: Center(
       child: Text(cell.value.toString(),
         style: const TextStyle(overflow: TextOverflow.visible,fontSize: 14),
       ),
     ),
   )).toList());
  }
}
