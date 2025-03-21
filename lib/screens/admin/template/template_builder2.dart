
import 'package:activity_guide/main.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/text_styles.dart';
import '../../../providers/template_provider.dart';
import '../../../views/widgets/custom_tablecell2.dart';
import 'package:beamer/beamer.dart';

class TemplateBuilder2 extends StatefulWidget {
  const TemplateBuilder2({super.key});

  @override
  State<TemplateBuilder2> createState() => _TemplateBuilder2State();
}

class _TemplateBuilder2State extends State<TemplateBuilder2> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body:   Padding(
          padding: const EdgeInsets.only(right: 100),
          child: Column(

            children: [
              BackButton(onPressed: (){
                context.beamToNamed('/admin/templates');
              },),
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
            Positioned(right: 20,top: MediaQuery.of(context).size.width/10 + 40,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(' '+context.watch<TemplateProvider>().rows.length.toString(),style: AppTextStyles.tableColumns,),
                )),
            // Add Button
            Positioned( right: 20, top: MediaQuery.of(context).size.height / 2 - 100,
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
                  SizedBox(height: 12,),
                  // Remove Button
                  FloatingActionButton(
                    onPressed: () {
                      context.read<TemplateProvider>().removeRow();
                    },
                    tooltip: 'Remove Row',
                    child: const Icon(Icons.remove,color: light,), heroTag: 'remove',
                    backgroundColor: Colors.red.shade400,
                  ),
                //  SizedBox(height: 12,),
                  // FloatingActionButton(onPressed: () async{
                  //   await  context.read<TemplateProvider>().editTemplate();
                  // },child: Icon(Icons.edit),tooltip: 'edit',heroTag: 'edit',
                  //   backgroundColor: Colors.yellow[500],),

                ],
              ),
            ),
            Positioned(
              right: 20, // Distance from the right edge
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
