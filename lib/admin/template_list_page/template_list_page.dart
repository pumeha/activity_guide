
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import '../../shared/responsiveness.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/constants.dart';

class TemplatesListPage extends StatefulWidget {
  const TemplatesListPage({super.key});

  @override
  State<TemplatesListPage> createState() => _TemplatesListPageState();
}

class _TemplatesListPageState extends State<TemplatesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.white70,
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveWidget.isLargeScreen(context) ? 500 : 100,vertical: 10),
          child: Card( color: Color(0xFFFFFFFF),elevation: 12,
            child: ListTile(
              title: const Row(
                children: [
                  Expanded(child: Center(child: Text('Monthly Template',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),))),
                  Tooltip(message: 'Active Template',child: Icon(Icons.check_circle,color: active,size: 24,),)
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 // Text('Purpose'),
                 const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Purpose of the template',
                      maxLines: 3,
                      style: TextStyle(fontSize: 16,fontStyle: FontStyle.italic),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                      IconButton(onPressed: (){
                        context.beamToNamed('/admin/preview_template');
                      }, icon: const Icon(Icons.preview,color: Colors.green,size: 24) ,
                      tooltip: 'Preview Template',),
                      IconButton(icon: Icon(Icons.edit,color: Colors.yellow[700],size: 24),onPressed: (){
                          context.beamToNamed('/admin/builder');
                      },
                      tooltip: 'Edit Template',),
                      IconButton(icon: const Icon(Icons.delete_forever_rounded,color: Colors.red,size: 24),onPressed: (){},
                      tooltip: 'Delete Template',),
                    ],),
                  )
                ],
              ),
            ),
          ),
        )
      ],),
      floatingActionButton: FloatingActionButton(onPressed: (){
        context.beamToNamed('/admin/builder');
      },heroTag: 'add',tooltip: 'Create template',child: const Icon(Icons.add),),
    );
  }
} 

class TemplatesListLocation extends BeamLocation{
  @override
  List<BeamPage> buildPages(BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [const BeamPage(child: TemplatesListPage(),title: appName,key: ValueKey('templates'))];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/templates'];

}