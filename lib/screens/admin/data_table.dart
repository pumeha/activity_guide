import 'dart:convert';
import 'package:activity_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


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
    var response = await rootBundle.loadString("/images/rawjson.json");
    data = json.decode(response) as List<dynamic>;
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
          child: Text(entry.key,style: const TextStyle(color: Colors.black,fontSize: 14,
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: populateData(),builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){

          return  SfDataGrid(source: _jsonDataGridSource,
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
          );
          }
          return CustomCircleIndicator();
      },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        
      },child: Icon(Icons.save_alt),),
    );
  }
}

class JSONDataGridSource extends DataGridSource{

  List<DataGridRow> dataGridRows = [];

  JSONDataGridSource(List<dynamic> data,
      List<GridColumn> columns){
    dataGridRows = data.map((value)=>
    DataGridRow(cells: columns.map((column)=>
    DataGridCell(columnName: column.columnName,
        value: value[column.columnName])).toList())).toList();
  }


  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
   return DataGridRowAdapter(cells:
   row.getCells().map((cell)=>
   Container(child: Text(cell.value.toString(),
     style: TextStyle(backgroundColor: Colors.white),
   ),
   color: Colors.white,)).toList());
  }
}
