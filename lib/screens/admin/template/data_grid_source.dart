import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../models/myshared_preference.dart';
class MyDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  List<String> _columnNames = [];

  List<Map<String, dynamic>> _jsonColumns = [];

  MyDataSource(count) {
   _initializeRows(count);
   loadJSONFromPrefs();
   //addRow();
  }

  Future<void> loadJSONFromPrefs() async{
    String? template = await MysharedPreference().getPreferences('template');
    _jsonColumns = List<Map<String,dynamic>>.from(jsonDecode(template!));


  }
  void _initializeRows(int rowCount) {
    _rows = List.generate(
      rowCount,
          (index) => DataGridRow(cells: []),
    );
  }

  void addColumn(String columnName) {
    _columnNames.add(columnName);
    for (var row in _rows) {
      row.getCells().add(DataGridCell(columnName: columnName, value: ''));
    }
    notifyListeners(); // Refresh the grid
  }

  void addRow() {
    var newRow = DataGridRow(
      cells: _columnNames.map((columnName) {
        return DataGridCell(columnName: columnName, value: ''); // Default empty value
      }).toList(),
    );

    _rows.add(newRow); // Add the new row to the list
    notifyListeners(); // Refresh the grid to show the new row
  }


  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

     return DataGridRowAdapter(
        cells: row.getCells().map((cell) {
      final columnName = cell.columnName;
      final columnIndex = _columnNames.indexOf(columnName);
      final columnType = columnIndex >= 0 ? _jsonColumns[columnIndex]['Type'] : 'Dynamic';
      final columnRange = columnIndex >= 0 ? _jsonColumns[columnIndex]['Range'] : '';


      if (columnType == 'Dropdown') {
        // Render Dropdown for Dropdown column
        return Center(
          child: DropdownMenu<String>(
            initialSelection: '',
            dropdownMenuEntries: columnRange.toString().split(',').map<DropdownMenuEntry<String>>((e) =>
                DropdownMenuEntry(value: e, label: e)).toList(),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'.'))],),
        );
      } else {
        // Render text fields for other columns
        return Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const TextField(
           maxLines: 3,
          ),
        );
      }
    }).toList());
  }
}