import 'dart:convert';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../shared/utils/constants.dart';


class MyTable extends StatefulWidget {
  const MyTable({super.key});

  @override
  State<MyTable> createState() => _MyTableState();
}

  class _MyTableState extends State<MyTable> {
  late JSONDataGridSource _jsonDataGridSource;
  late List<GridColumn> columns;
  late List<dynamic> data;


  Future populateData() async{
    String? response = await MysharedPreference().getPreferences(template_data);

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
      body: Column(children: [
       Expanded(child: FutureBuilder(
          future: populateData(),builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){

            return  SfDataGrid(
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
        },
        ),)
      ],),
      floatingActionButton: FloatingActionButton(onPressed: (){

      },child: const Icon(Icons.save_alt),),
    );
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
     child: Text(cell.value.toString(),
       style: const TextStyle(overflow: TextOverflow.visible,fontSize: 14),
     ),
   )).toList());
  }
}
