import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../../views/widgets/grid_label.dart';
import '../../../views/widgets/myapp_bar.dart';


class RData {
  String name;
  String age;
  String job;
  String planned_start;

  RData(this.name, this.age, this.job,this.planned_start);
}


class MyDataSource extends DataGridSource {
  List<DataGridRow> _dataGridRows = [];
  List<RData> _rows;

  MyDataSource(this._rows) {
    _dataGridRows = _rows.map((row) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Name', value: row.name),
        DataGridCell<String>(columnName: 'Age', value: row.age),
        DataGridCell<String>(columnName: 'Job', value: row.job),
        DataGridCell<String>(columnName: 'Planned Start', value: row.planned_start),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      TextFormField(
        initialValue: row.getCells()[0].value,
        onChanged: (value) {
          _rows[rows.indexOf(row)].name = value; // Update model
        },maxLines: 3,
      ),
      DropdownButton<String>(
        value: row.getCells()[1].value,
        items: ['25', '30', '35'].map((age) {
          return DropdownMenuItem(value: age, child: Text(age));
        }).toList(),
        onChanged: (value) {
          _rows[rows.indexOf(row)].age = value!;
        },
      ),
      TextFormField( maxLines: 4,
        initialValue: row.getCells()[2].value,
        onChanged: (value) {
          _rows[rows.indexOf(row)].job = value; // Update model
        },
      ),
      Text('')
    ]);
  }
}


class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  final List<RData> rows = [
    RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),
    RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),
    RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),
    RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),RData("Alice", "25", "Engineer",''),
    RData("Bob", "30", "Designer",''),
  ];
  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  late Map<String, double> columnWidths = {
    'Name': double.nan,
    'Age': double.nan,
    'Job': double.nan,
    'Planned Start': double.nan
  };
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const MyAppBar(title: 'Preview Template'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SfDataGrid(
          key: key,
          source: MyDataSource(rows),
          columns: <GridColumn>[
            GridColumn(columnName: 'Name', label: GridLabel(title: 'Name'),width: columnWidths['Name']!),
            GridColumn(columnName: 'Age', label: GridLabel(title: 'Age',),width: columnWidths['Age']!),
            GridColumn(columnName: 'Job', label: GridLabel(title: 'Job',),width: columnWidths['Job']!),
            GridColumn(columnName: 'Planned Start', label: GridLabel(title: 'Planned Start',),
            width: columnWidths['Planned Start']!)
          ],
          rowHeight: 80,
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
          frozenColumnsCount: 2,
          footer: MaterialButton(onPressed: (){},color: Colors.green,
            child: Text('Add Row',style: TextStyle(color: Colors.black),),),
        ),
      ),
      floatingActionButton: FloatingActionButton(tooltip: 'Save',onPressed: () {
          final Workbook workbook = key.currentState!.exportToExcelWorkbook();
          final List<int> bytes = workbook.saveAsCSV(',');
          File('Test.csv').writeAsBytes(bytes,flush: true);
      },
        child: Icon(Icons.save),backgroundColor: Colors.green.shade50,),
    );
  }
}