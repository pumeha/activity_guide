import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/rowdata_model.dart';
import '../../theme/text_styles.dart';

class CustomTableCell2 extends StatelessWidget {
  final double size;
  final Widget child;
  const CustomTableCell2({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {

    return  Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: Center(child: child),
    );
  }
}

class CustomTable extends StatelessWidget {

  final RowData rowData;
  final int index;
  final Function(int, RowData) onRowUpdate;



  CustomTable({super.key, required this.rowData,
    required this.index, required this.onRowUpdate});

  @override
  Widget build(BuildContext context) {

    const  List<String> datatypes = ['Dynamic','Dropdown','Date'];
    const List<String> datepickertypes = ['Single Date','Double Date'];
    List<String> info = ['No default value required','Dropdown items are seperated by comma','Select DatePicker Type'];
    return  Padding(
      padding: const EdgeInsets.only(bottom: 40,right: 50,left: 50),
      child: Column(
        children: [
          CustomTableCell2(size: 50, child: Text((index+1).toString(),style: AppTextStyles.tableColumns,)),
          CustomTableCell2(size: 330, child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(controller: rowData.variableNameController,
              onChanged: (v){
                //  rowData.variableNameController.text = v;
                onRowUpdate(index,rowData);
              },
              decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(),focusColor: Colors.green,
              labelText: 'Variable Name',border: OutlineInputBorder()),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],

            ),
          )),
          CustomTableCell2(size: 160, child: DropdownMenu<String>(
            initialSelection: '',controller: rowData.dataTypeController,
            hintText: 'Data Type',
            onSelected: (value){

              if(value == datatypes[0]){
                rowData.dataTypeController.text = value!;
                rowData.rangeStatus = false;
                rowData.info = info[0];
                rowData.rangeController.text = info[0];
                onRowUpdate(index,rowData);

              }else if(value == datatypes[1]){
                rowData.dataTypeController.text = value!;
                rowData.rangeStatus = true;
                rowData.info = info[1];
                rowData.rangeController.clear();
                onRowUpdate(index,rowData);
              }else{
                rowData.dataTypeController.text = value!;
                rowData.rangeStatus = true;
                rowData.info = info[2];
                rowData.rangeController.clear();
                onRowUpdate(index,rowData);
              }
            },
            dropdownMenuEntries: datatypes.map<DropdownMenuEntry<String>>((e) =>
                DropdownMenuEntry(value: e, label: e)).toList(),inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'.'))],),
          ),
          CustomTableCell2(size: 310, child:
          Tooltip( message: rowData.info,
            child: rowData.dataTypeController.text == 'Date' ?
            Padding(
              padding: const EdgeInsets.only(top: 16,bottom: 16),
              child: DropdownMenu<String>( controller: rowData.rangeController,
                initialSelection: '',
                onSelected: (v){
                  onRowUpdate(index,rowData);
                },
                dropdownMenuEntries: datepickertypes.map<DropdownMenuEntry<String>>((e) =>
                    DropdownMenuEntry(value: e, label: e)).toList(),inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'.'))],),
            ) :
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(controller: rowData.rangeController,enabled: rowData.rangeStatus,
                onChanged: (value){
                  //  rowData.rangeController.text = value;
                  onRowUpdate(index,rowData);
                }, decoration: const InputDecoration(focusedBorder: OutlineInputBorder(),
                    labelText: 'Range',border: OutlineInputBorder()),
              ),
            ),
          )),
        ],
      ),
    );
  }
}