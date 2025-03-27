import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/rowdata_model.dart';
import '../../theme/text_styles.dart';

class CustomTableCell extends StatelessWidget {
 final double size;
 final Widget child;
  const CustomTableCell({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {

    return  Container(
      decoration: BoxDecoration(border: Border.all(width: 1)),
      child: SizedBox(width: size,child: Center(child: child),height: 50,),
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
    return  Row( mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTableCell(size: 50, child: Text((index+1).toString(),style: AppTextStyles.tableColumns,)),
        CustomTableCell(size: 330, child: TextField(controller: rowData.variableNameController,
          onChanged: (v){
        //  rowData.variableNameController.text = v;
          onRowUpdate(index,rowData);
          },
         decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(),focusColor: Colors.green),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],)),
        CustomTableCell(size: 160, child: DropdownMenu<String>(
    initialSelection: '',controller: rowData.dataTypeController,
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
 CustomTableCell(size: 310, child:
        Tooltip( message: rowData.info,
          child: rowData.dataTypeController.text == 'Date' ?
          DropdownMenu<String>( controller: rowData.rangeController,
            initialSelection: '',
            onSelected: (v){
            onRowUpdate(index,rowData);
            },
            dropdownMenuEntries: datepickertypes.map<DropdownMenuEntry<String>>((e) =>
                DropdownMenuEntry(value: e, label: e)).toList(),inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'.'))],) :
          TextField(controller: rowData.rangeController,enabled: rowData.rangeStatus,
            onChanged: (value){
          //  rowData.rangeController.text = value;
            onRowUpdate(index,rowData);
            }, decoration: const InputDecoration(focusedBorder: OutlineInputBorder()),),
        )),
      ],);
  }
}