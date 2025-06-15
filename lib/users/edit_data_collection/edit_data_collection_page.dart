import 'dart:convert';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_event.dart';
import 'package:activity_guide/users/edit_data_collection/bloc/edit_data_collection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';
import '../data_collection_page/bloc/data_collection_bloc.dart';
import 'bloc/edit_data_collection_event.dart';
import 'bloc/edit_data_collection_state.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
    String? saveData = await MysharedPreference()
        .getPreferencesWithoutEncrpytion(dataCollectionKey);
    
    data = json.decode(saveData!) as List<dynamic>;
    if (data.isNotEmpty) {
      columns = generateColumns(data[0]);
      _jsonDataGridSource = JSONDataGridSource(data, columns);
    }
    return data;
  }

  List<GridColumn> generateColumns(Map<String, dynamic> data) {
    List<GridColumn> columns = [];
    for (var entry in data.entries) {
      if (entry.key != 'ID') {
        GridColumn gridColumn = GridColumn(
            columnName: entry.key,
            label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ));
        columns.add(gridColumn);
      }
    }
    return columns;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = [];
  }

  final DataGridController controller = DataGridController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditDataCollectionBloc, EditDataCollectionState>(
      listener: (context, state) {
        if(state is EditLoadingState){
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
        }else if(state is EditSuccessState){
          
            EasyLoading.showSuccess('Data Uploaded Successfully!');
                      context.beamToReplacementNamed('/home/landing_page');
        }else if(state is EditFailureState){
              EasyLoading.showError(state.message);
        }
      },
      child: Scaffold(
        body: FutureBuilder(
          future: populateData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return (_jsonDataGridSource != null)
                  ? SfDataGridTheme(
                    data: const SfDataGridThemeData(gridLineStrokeWidth: 1,gridLineColor: Colors.grey),
                    child: SfDataGrid(
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
                        onCellDoubleTap: (details) {
                          dynamic index = details.rowColumnIndex.rowIndex-1;
                    
                          List<dynamic> editData = [data[index]];
                       
                          context.beamToReplacementNamed('/home/template');
                          context
                              .read<DataCollectionBloc>()
                              .add(DataCollectionEditEvent(data: editData));
                        },
                      ),
                  )
                  : const Center(
                      child: CustomText(text: 'No records Found'),
                    );
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
                     context.read<EditDataCollectionBloc>().add(UploadDataEvent(data: data));
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
                    tooltip: 'Add',
                    heroTag: 'add',
                    backgroundColor: active,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      int selectedRow = controller.selectedIndex;
                      if (selectedRow != -1) {
                        data.removeAt(selectedRow);

                        _jsonDataGridSource!.dataGridRows = data
                            .map((value) => DataGridRow(
                                cells: columns
                                    .map((column) => DataGridCell(
                                        columnName: column.columnName,
                                        value: value[column.columnName]))
                                    .toList()))
                            .toList();
                        _jsonDataGridSource!.notifyListeners();

                        MysharedPreference().setPreferencesWithoutEncrpytion(
                            dataCollectionKey, jsonEncode(data));
                        setState(() {});
                      } else {
                        EasyLoading.showInfo('Select Row');
                      }
                    },
                    tooltip: 'Remove Row',
                    heroTag: 'remove',
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
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
                  child: Center(
                    child: Text(
                      cell.value.toString(),
                    ),
                  ),
                ))
            .toList());
  }
}
