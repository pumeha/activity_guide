
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/text_styles.dart';
import '../../../providers/template_provider.dart';
import '../../../views/widgets/custom_tablecell.dart';

class TemplateBuilder extends StatefulWidget {
  const TemplateBuilder({super.key});

  @override
  State<TemplateBuilder> createState() => _TemplateBuilderState();
}

class _TemplateBuilderState extends State<TemplateBuilder> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body:   Padding(
        padding: const EdgeInsets.only(top: 60,right: 200),
        child: Column(

          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTableCell(size: 50, child: Text('S/N',style: AppTextStyles.tableColumns,)),
                CustomTableCell(size: 330, child: Text('Variable Name', style: AppTextStyles.tableColumns,)),
                CustomTableCell(size: 160, child: Text('Data Type',style: AppTextStyles.tableColumns,),),
                CustomTableCell(size: 310, child: Text('Range',style: AppTextStyles.tableColumns,)),
              ],),
            Expanded(child: Consumer<TemplateProvider>(builder: (BuildContext context, TemplateProvider provider, Widget? child) {
                return ReorderableListView( onReorder: (oldIndex,newIndex){
                        provider.reorderRows(oldIndex, newIndex);
                }, children: List.generate(provider.rows.length, (index)=>
                    CustomTable(key: ValueKey(provider.rows[index].id),
                    rowData: provider.rows[index], index: index,  onRowUpdate: (i,updatedRow)=>provider.updateRow(i, updatedRow),
                   )),);
              }),),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(right: 50,top: MediaQuery.of(context).size.width/12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(' '+context.watch<TemplateProvider>().rows.length.toString(),style: AppTextStyles.tableColumns,),
              )),
          // Add Button
          Positioned( right: 50, top: MediaQuery.of(context).size.height / 2 - 100,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    context.read<TemplateProvider>().addRow();
                  },
                  tooltip: 'Add Row',
                  child: const Icon(Icons.add), heroTag: 'add',
                  backgroundColor: Colors.green[50],
                ),
                const SizedBox(height: 12,),
                // Remove Button
                FloatingActionButton(
                  onPressed: () {
                    context.read<TemplateProvider>().removeRow();
                  },
                  tooltip: 'Remove Row',
                  child: const Icon(Icons.remove,color: light,), heroTag: 'remove',
                  backgroundColor: Colors.red.shade400,
                ),
                const SizedBox(height: 12,),
                FloatingActionButton(onPressed: () async{
                  await  context.read<TemplateProvider>().editTemplate();
                },child: const Icon(Icons.edit),tooltip: 'edit',heroTag: 'edit',
                backgroundColor: Colors.yellow[500],),

              ],
            ),
          ),
          Positioned(right: 50,top: MediaQuery.of(context).size.height/2 + 100,
            child: FloatingActionButton(onPressed: () async {
             await context.read<TemplateProvider>().previewTemplate(context);
          },child: const Icon(Icons.preview,color: Colors.white,),tooltip: 'Preview',
            backgroundColor: Colors.black,),),
          Positioned(
            right: 50, // Distance from the right edge
            top: MediaQuery.of(context).size.height /4, // Below the center
            child: FloatingActionButton(
              onPressed: () {
               context.read<TemplateProvider>().printRowsData();
              },
              tooltip: 'Save',heroTag: 'save',
              child: const Icon(Icons.save,color: light,),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      )

    );
  }
}
