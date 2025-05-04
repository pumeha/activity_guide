import 'dart:convert';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_event.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import '../data_collection_page/bloc/data_collection_bloc.dart';

class EditDataCollectionPage extends StatefulWidget {
  const EditDataCollectionPage({super.key});

  @override
  State<EditDataCollectionPage> createState() => _EditDataCollectionPageState();
}

class _EditDataCollectionPageState extends State<EditDataCollectionPage> {
  JSONDataGridSource? _jsonDataGridSource;
  late List<GridColumn> columns;
  late List<dynamic> data;

  Future populateData() async {
     String? saveData = await MysharedPreference().getPreferencesWithoutEncrpytion(dataCollectionKey);
       
      data = json.decode(saveData!) as List<dynamic>;
      //  data = [{"Firstname":"dfg","Lastname":"dg","Phonenumber":"dg","Home Address":"dfg","Resident Address":"","Level Of Education":"","Martial Status":"","Next Of Kin":"gdf"},
      //           {"Firstname":"dfg","Lastname":"dg","Phonenumber":"dg","Home Address":"dfg","Resident Address":"","Level Of Education":"","Martial Status":"","Next Of Kin":"gdf"}];
     
      if (data.isNotEmpty) {
        columns = generateColumns(data[0]);
        _jsonDataGridSource = JSONDataGridSource(data, columns);
      }
      return data;
    
  }

  List<GridColumn> generateColumns(Map<String, dynamic> data) {
    List<GridColumn> columns = [];
    for (var entry in data.entries) {
      GridColumn gridColumn = GridColumn(
          columnName: entry.key,
          label: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              entry.key,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ));
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
        future: populateData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return (_jsonDataGridSource != null) ? SfDataGrid(
              controller: controller,
              source: _jsonDataGridSource!,
              columns: columns,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.auto,
              // allowFiltering: true,
              // allowSorting: true,
              // allowMultiColumnSorting: true,
              // allowTriStateSorting: true,
              showVerticalScrollbar: true,
              showHorizontalScrollbar: true,
              navigationMode: GridNavigationMode.row,
              selectionMode: SelectionMode.multiple,
              onCellDoubleTap: (details){
              dynamic index  = details.rowColumnIndex.rowIndex-1;
              
               List<dynamic> editData = [data[index]];
               context.beamToReplacementNamed('/home/template');
              context.read<DataCollectionBloc>().add(EditDataCollectionEvent(data: editData));
             
                
              },
            ) : const Center(child: CustomText(text: 'No records Found'),);
          }
          return customCircleIndicator();
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 100,
            right: 0,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    EasyLoading.showSuccess('Data Uploaded Successfully!');
                    context.beamToReplacementNamed('/home/landing_page');
                  },
                  tooltip: 'Upload',
                  heroTag: 'upload',
                  backgroundColor: active,
                  child: const Icon(
                    Icons.upload_file_outlined,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(
                  height: 12,
                ),
                FloatingActionButton(
                  onPressed: () {
                    context.beamToReplacementNamed('/home/template');
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  tooltip: 'Add',
                  heroTag: 'add',
                  backgroundColor: active,
                ),
                const SizedBox(
                  height: 12,
                ),
                FloatingActionButton(
                  onPressed: () {
                  
                  },
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  tooltip: 'Delete',
                  heroTag: 'del',
                  backgroundColor: Colors.red,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class JSONDataGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  JSONDataGridSource(List<dynamic> data, List<GridColumn> columns) {
    dataGridRows = data
        .map((value) => DataGridRow(
            cells: columns
                .map((column) => DataGridCell(
                    columnName: column.columnName,
                    value: value[column.columnName]))
                .toList()))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row
            .getCells()
            .map((cell) => Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      cell.value.toString(),
                      style: TextStyle(backgroundColor: Colors.white),
                    ),
                  ),
                ))
            .toList());
  }
}
