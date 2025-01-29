import 'dart:async';
import 'dart:convert';
import 'package:activity_guide/models/myshared_preference.dart';
import 'package:activity_guide/screens/admin/template/downloadExcelFile.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class Template extends StatefulWidget {
  const Template({super.key});


  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late MyDataSource _dataSource;
  List<Map<String, dynamic>> _jsonColumns = [];
  List<GridColumn> _columns = [];
  String mysaveddata = '';
  String jsonColumnvalue =
      '[{"ID": 1,"name": "OUTPUT","Type": "Dropdown","Range": "A,B,C"},{"ID": 2,"name": "TYPE OF ACTIVITIES","Type": "Dropdown","Range": "SURVEY,SAS,WORKSHOP"}, {"ID": 3,"name": "FREQUENCY","Type": "Dropdown","Range": "DAILY,WEEKLY, MONTHLY"}, {"ID": 4,"name": "PLANNED  DATE","Type": "Date","Range": "Double Date"}, {"ID": 5,"name": "ACTUAL DATE","Type": "Date","Range": "Double Date"}, {"ID": 6,"name": "TARGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 7,"name": "ACTIVITIES DESCRIPTION","Type": "Dynamic","Range": "No default value required"}, {"ID": 8,"name": "OUTCOME","Type": "Dynamic","Range": "No default value required"}, {"ID": 9,"name": "PERCENTAGE  COMPLETED","Type": "Dynamic","Range": "No default value required"}, {"ID": 10,"name": "MILESTONE","Type": "Dropdown","Range": "N/A,PROPOSAL,PLANNING,EXCUTING,COMPLETION,SUBMISSION"}, {"ID": 11,"name": "BASELINE METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 12,"name": "KPI","Type": "Dynamic","Range": "No default value required"}, {"ID": 13,"name": "ACTUAL ACHIEVED METRICS","Type": "Dynamic","Range": "No default value required"}, {"ID": 14,"name": "TOTAL BUDGET","Type": "Dynamic","Range": "No default value required"}, {"ID": 15,"name": "APPROPRIATION","Type": "Dynamic","Range": "No default value required"}, {"ID": 16,"name": "DONOR","Type": "Dynamic","Range": "No default value required"}, {"ID": 17,"name": "RELEASED","Type": "Dynamic","Range": "No default value required"}, {"ID": 18,"name": "UTILIZED","Type": "Dynamic","Range": "No default value required"}, {"ID": 19,"name": "BALANCE","Type": "Dynamic","Range": "No default value required"}, {"ID": 20,"name": "MORE FUND","Type": "Dynamic","Range": "No default value required"}, {"ID": 21,"name": "CHALLENGES","Type": "Dropdown","Range": "NO CHALLENGES,FUNDS RELATED,RISKRELATED"}, {"ID": 22,"name": "REMARKS","Type": "Dynamic","Range": "No default value required"}]';
  List<dynamic> previousData = [];
  //Timer? _timer;

  @override
  void initState() {
    super.initState();
    // EasyLoading.addStatusCallback((status){
    //   if(status == EasyLoadingStatus.dismiss){
    //     _timer?.cancel();
    //   }
    // });
  }

  Future<void> loadPartiallySaveData() async {
    String? saveData = await MysharedPreference().getPreferences('savedata');
    mysaveddata = saveData!;
  }


  void _addColumnsFromJson(String value) {
    _jsonColumns = List<Map<String, dynamic>>.from(jsonDecode(
        '[{"ID": 0,"name": "S/N","Type": "Dynamic","Range": "No default value required"}]'));
    _jsonColumns.addAll(List<Map<String, dynamic>>.from(jsonDecode(value)));
      for (var col in _jsonColumns) {
        _columns.add(_buildGridColumn(col['name'],width: col['name'] == 'S/N' ? 50 : 200));
      }
  }

  GridColumn _buildGridColumn(String columnName, {double width = 200}) {
    return GridColumn(
        columnName: columnName,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(columnName),
        ),
        width: width);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(future: loadPartiallySaveData(), builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          _addColumnsFromJson(jsonColumnvalue);
          _dataSource = MyDataSource(context, key,mysaveddata,_jsonColumns);

          return  SfDataGrid(
              key: key,
              source: _dataSource,
              columns: _columns,
              rowHeight: 80,
              isScrollbarAlwaysShown: true,
              frozenColumnsCount: 1,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.auto,
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              //columnResizeMode: ColumnResizeMode.onResize,

              footer: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          _dataSource.addRow();

                        },
                        color: Colors.green[50],
                        child: const Text(
                          'Add Row',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () {
                          _dataSource.rows.removeLast();
                          _dataSource.notifyListeners();
                        },
                        color: Colors.red.shade400,
                        child: const Text(
                          'Remove Row',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
        }else{

          return Center(child: CircularProgressIndicator(
            strokeWidth: 8,
            value: 0.24,  // Percentage value between 0.0 and 1.0
            backgroundColor: Colors.black.withOpacity(0.1),  // Lighter background color
            valueColor: const AlwaysStoppedAnimation<Color>(active), // Progress color
          ));
        }
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        onPressed: () {
          downloadExcelFile().createExcel(key);

        },
        backgroundColor: Colors.green.shade50,
        child: const Icon(Icons.save),
      ),
    );
  }
}

class MyDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  List<String> _columnNames = [];
  BuildContext context;
  late String multipleDateString = 'test';
  final Map<String, TextEditingController> _controllers = {};
  final List<Map<String, dynamic>> _jsonColumns;
  GlobalKey<SfDataGridState> key;

  MyDataSource(this.context, this.key, String previousData, this._jsonColumns) {
    if(previousData != '') {
      List<dynamic> previousRecords = jsonDecode(previousData);
      _rows = List.generate(
        previousRecords.length,
            (index){
          final data = previousRecords[index];
          List<DataGridCell> cells = [];
          for(var key in data.keys){
            cells.add(DataGridCell(columnName: key, value: data[key]));
          }
          return DataGridRow(cells: cells);
            },
      );
      for (var col in _jsonColumns) {
        _columnNames.add(col['name']);
      }

    }else{
      _initializeRows(4);
      for (var col in _jsonColumns) {
        addColumn(col['name'],'');
      }
    }
  }


  void _initializeRows(int rowCount) {
    _rows = List.generate(
      rowCount,
          (index) => DataGridRow(cells: []),
    );
  }

  void addColumn(String columnName,String value ) {
    _columnNames.add(columnName);
    if (columnName == 'S/N') {
      for (int i = 0; i < _rows.length; i++) {
        _rows[i].getCells().add(
            DataGridCell(columnName: columnName, value: (i + 1).toString()));
      }
    } else {
      for (var row in _rows) {
        row.getCells().add(DataGridCell(columnName: columnName, value: value));
      }
    }

    notifyListeners(); // Refresh the grid
  }

  void addRow() {
    var newRow = DataGridRow(
      cells: _columnNames.map((columnName) {
        if (columnName == 'S/N') {
          return DataGridCell<String>(
              columnName: columnName, value: (_rows.length + 1).toString());
        }
        return DataGridCell<String>(
            columnName: columnName, value: ''); // Default empty value
      }).toList(),
    );
    _rows.add(newRow); // Add the new row to the list
    notifyListeners(); // Refresh the grid to show the new row
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

    dynamic sn;
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        final columnName = cell.columnName;
        // Unique key for the cell.
        final cellKey = '${row
            .getCells()
            .first
            .value}_$columnName';

        final columnIndex = _columnNames.indexOf(columnName);
        final columnType =
        columnIndex >= 0 ? _jsonColumns[columnIndex]['Type'] : 'Dynamic';
        final columnRange =
        columnIndex >= 0 ? _jsonColumns[columnIndex]['Range'] : '';
        if (columnName == 'S/N') {
          sn = cell.value;
        }
        switch (columnType) {
          case 'Dropdown':
          // Store the dropdown value in your data source
            String currentValue = cell.value ?? '';
            // Render Dropdown for Dropdown column
            return Center(
              child: DropdownMenu<String>(
                key: ValueKey(cellKey),
                initialSelection: currentValue,
                dropdownMenuEntries: columnRange
                    .toString()
                    .split(',')
                    .map<DropdownMenuEntry<String>>(
                        (e) => DropdownMenuEntry(value: e, label: e))
                    .toList(),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'.'))
                ],
                onSelected: (v) {
                  setCellValue(sn, columnName, v.toString());
                  downloadExcelFile().partialSave(key);
                },
              ),
            );

          case 'Date':
            return columnRange == 'Single Date'
                ?
            // Render Date Picker
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(cell.value)),
                  TextButton(
                    child: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      singleDateDialog(sn, columnName);
                      downloadExcelFile().partialSave(key);
                    },
                  ),
                ],
              ),
            )
                : Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(cell.value ?? 'Pick Date')),
                  TextButton(
                    child: Icon(Icons.arrow_drop_down_circle),
                    onPressed: () {
                      doubleDateDialog(sn, columnName);
                      downloadExcelFile().partialSave(key);
                    },
                  ),
                ],
              ),
            );

          case 'Dynamic':
          // Render TextField for Dynamic columns
          // Ensure controller exists for the cell
            if (!_controllers.containsKey(cellKey)) {
              _controllers[cellKey] = TextEditingController(text: cell.value);
            }
            final controller = _controllers[cellKey]!;
            return Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: columnName == 'S/N'
                  ? Text(cell.value.toString())
                  : TextField(
                controller: controller,
                maxLines: 3,
                onChanged: (value) {
                  setCellValue(sn, columnName, value);
                  downloadExcelFile().partialSave(key);
                },
              ),
            );

          default:
          // Handle unexpected column types (fallback to TextField)
          // Ensure controller exists for the cell
            if (!_controllers.containsKey(cellKey)) {
              _controllers[cellKey] = TextEditingController(text: cell.value);
            }
            final controller = _controllers[cellKey]!;
            return Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                maxLines: 3,
                onChanged: (value) =>
                {
                  // setCellValue(sn, columnName, value)
                  print(sn + ' ' + columnName + ' ' + value)
                },
              ),
            );
        }
      }).toList(),
    );

  }

  void singleDateDialog(String sn, String columnName) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime
          .now()
          .year),
      lastDate: DateTime(DateTime
          .now()
          .year + 2),
    );
    if (selectedDate != null) {
      String _date =
          '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
      setCellValue(sn, columnName, _date);
    }
  }

  doubleDateDialog(sn, String columnName) {
    showDateRangePicker(
        context: context,
        firstDate: DateTime(2024, 03, 01),
        lastDate: DateTime(DateTime
            .now()
            .year + 5),
        initialEntryMode: DatePickerEntryMode.calendarOnly)
        .then((onValue) {
      if (onValue != null) {
        String startDate =
            '${onValue.start.month}/${onValue.start.day}/${onValue.start.year}';
        String endDate =
            '${onValue.end.month}/${onValue.end.day}/${onValue.end.year}';
        multipleDateString = startDate + '-' + endDate;
        setCellValue(sn, columnName, multipleDateString);
      }
      // notifyListeners();
    });
  }

  void setCellValue(String sn, String columnName, String newValue) {
    int rowIndex = int.parse(sn) - 1;
    if (rowIndex >= 0 && rowIndex < _rows.length) {
      final row = _rows[rowIndex];
      final cellIndex =
      row.getCells().indexWhere((cell) => cell.columnName == columnName);
      if (cellIndex != -1) {
        row.getCells()[cellIndex] =
            DataGridCell<String>(columnName: columnName, value: newValue);
        notifyListeners(); // Refresh the grid
      }
    }
  }
}