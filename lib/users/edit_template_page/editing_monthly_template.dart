import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:beamer/beamer.dart';

import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';


class EditingMonthlyTemplate extends StatefulWidget {
  const EditingMonthlyTemplate({super.key});

  @override
  State<EditingMonthlyTemplate> createState() => _EditingMonthlyTemplateState();
}

class _EditingMonthlyTemplateState extends State<EditingMonthlyTemplate> {
  late JSONDataGridSource _jsonDataGridSource;
  late List<GridColumn> columns;
  late List<dynamic> data;


  Future populateData() async{
    var response = await http.get(Uri.parse('/rawjson.json'));
    if(response.statusCode == 200) {
      data = json.decode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        columns = generateColumns(data[0]);
        _jsonDataGridSource = JSONDataGridSource(data, columns);
      }
      return data;
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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
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
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height/2 -100,right: 0,
            child: Column(
              children: [
                FloatingActionButton(onPressed: (){

                  EasyLoading.showSuccess('Data Uploaded Successfully!');
                  context.beamBack();
                },
                  tooltip: 'Upload',heroTag: 'upload',backgroundColor: active,child: const Icon(Icons.upload_file_outlined,color: Colors.white,),),
                SizedBox(height: 12,),
                FloatingActionButton(onPressed: (){
                  int index = controller.selectedIndex;
                  if(index == -1) {
                    EasyLoading.showToast('Select a row first');
                    return;
                  }
                  context.beamBack();
                  DataGridRow _selectedRow = controller.selectedRow!;
                  print(_selectedRow);
                },child: Icon(Icons.edit,),
                  backgroundColor: const Color(0xFFFFD000),
                  tooltip: 'Edit',heroTag: 'edit',),
                SizedBox(height: 12,),
                FloatingActionButton(onPressed: (){

                    context.beamBack();
                },child: Icon(Icons.add,color: Colors.white,),
                  tooltip: 'Add',heroTag: 'add',backgroundColor: active,)
              ],),)],),
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
