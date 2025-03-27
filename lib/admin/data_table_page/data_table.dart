import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../shared/utils/colors.dart';
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
    final response = await http.get(Uri.parse('/rawjson.json'));

    if (response.statusCode == 200) {
    //  print(response.body);

        data = json.decode(response.body) as List<dynamic>;
      if(data.isNotEmpty){
        columns = generateColumns(data[0]);
        _jsonDataGridSource = JSONDataGridSource(data,columns);
      }
      return data;
    } else {
      throw Exception('Failed to load JSON data');
    }


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
final DataGridController controller = DataGridController();
  final List<bool> _selections = [false,true];
  @override
  Widget build(BuildContext context) {

    return Scaffold( backgroundColor: Colors.white70,
      body: Column(children: [
        ToggleButtons(
          isSelected: _selections,
          onPressed: (index) {
            setState(() {
             switch(index){
               case 0:
                 _selections[index] = true;
                 _selections[1] = false;
                 break;
               case 1:
                 _selections[index] = true;
                 _selections[0] = false;
                 break;

               default:
                 _selections[0] = true;
                 _selections[1] = false;
             }
            });
          },
          selectedBorderColor: active,
          selectedColor: Colors.white,
          fillColor: active,
          color: Colors.black,
          borderColor: active,
          borderWidth: 2,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Workplan', style: TextStyle(fontSize: 14)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Monthly Activities', style: TextStyle(fontSize: 14)),
            ),
          ], // Set minimum size for buttons
        ),
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
          return CustomCircleIndicator();
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
     style: const TextStyle(backgroundColor: Colors.white),
   ),
   color: Colors.white,)).toList());
  }
}
