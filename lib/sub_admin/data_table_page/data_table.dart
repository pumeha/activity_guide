import 'dart:convert';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../shared/utils/constants.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
// for mobile

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

  Future populateData() async {
    String? response = await MysharedPreference()
        .getPreferencesWithoutEncrpytion(template_data);

    data = json.decode(response!) as List<dynamic>;

    if (data.isNotEmpty) {
      columns = generateColumns(data[0]);
      _jsonDataGridSource = JSONDataGridSource(data, columns);
    }
    return data;
  }


  Future<void> exportListToExcelCrossPlatform({String fileName = 'data.xlsx'}) async {
    if (data.isEmpty) return;

    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    final headers = data.first.keys.toList();

    // Write headers
    for (int j = 0; j < headers.length; j++) {
      sheet.getRangeByIndex(1, j + 1).setText(headers[j]);
    }

    // Write data
    for (int i = 0; i < data.length; i++) {
      final row = data[i];
      for (int j = 0; j < headers.length; j++) {
        final value = row[headers[j]]?.toString() ?? '';
        sheet.getRangeByIndex(i + 2, j + 1).setText(value);
      }
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    final Uint8List fileData = Uint8List.fromList(bytes);
    downloadFileWeb(fileData, fileName);

  }
  void downloadFileWeb(Uint8List fileData, String fileName) {
    final base64Data = base64Encode(fileData);
    final anchor = html.AnchorElement(
      href:
      'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,$base64Data',
    )
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
  }
  List<GridColumn> generateColumns(Map<String, dynamic> data) {
    List<GridColumn> columns = [];
    for (var entry in data.entries) {
      GridColumn gridColumn = GridColumn(
          columnName: entry.key,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              entry.key.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
  void viewData(BuildContext context){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(actions: [

      ],);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: populateData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SfDataGridTheme(
              data: const SfDataGridThemeData(
                  gridLineStrokeWidth: 1, gridLineColor: Colors.grey),
              child: SfDataGrid(
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
                selectionMode: SelectionMode.single,
                onCellDoubleTap: (v){
                  dynamic index = v.rowColumnIndex.rowIndex-1;

                  List<dynamic> editData = [data[index]];

                },
              ),
            );
          }
          return customCircleIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          exportListToExcelCrossPlatform();
        },
        child: const Icon(Icons.save_alt),
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
                    columnName:
                        column.columnName.replaceAll('_', ' ').toUpperCase(),
                    value: value[column.columnName]))
                .toList()))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((cell) {
      if (cell.columnName == 'CREATED AT' || cell.columnName == 'UPDATED AT') {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              cell.value.toString() == 'null'
                  ? ''
                  : formatDateTime(cell.value.toString()),
              style:
                  const TextStyle(overflow: TextOverflow.visible, fontSize: 14),
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              cell.value.toString() == 'null' ? '' : cell.value.toString(),
              style:
                  const TextStyle(overflow: TextOverflow.visible, fontSize: 14),
            ),
          ),
        );
      }
    }).toList());
  }
}
