import 'dart:convert';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/custom_widgets/template_list_item.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/shared/utils/rowdata_model.dart';
import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../../shared/utils/constants.dart';
import '../../template_builder_page/bloc/builder_bloc.dart';
import '../../template_builder_page/bloc/builder_bloc_event.dart';
import '../bloc/template_bloc.dart';
import '../bloc/template_event.dart';
import '../bloc/template_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TemplatesListPage extends StatefulWidget {
  const TemplatesListPage({super.key});

  @override
  State<TemplatesListPage> createState() => _TemplatesListPageState();
}

class _TemplatesListPageState extends State<TemplatesListPage>   with SingleTickerProviderStateMixin {

  Future<List<TemplateModel>> loadTemplateFromSharedPreference() async {
    String? templatesJson =
        await MysharedPreference().getPreferences(templateListKeys);

    if (templatesJson != null && templatesJson.isNotEmpty) {

      final List<dynamic> decodedList = jsonDecode(templatesJson);
      final List<TemplateModel> templates = decodedList
          .map((template) {
            
            TemplateModel model = TemplateModel.fromJson(template);
            
            if (model.purpose == 'wtemplate' && model.status == 'active') {
            
              List<RowData> columns = model.values;
              String names = columns.map((column) => column.columnName).join(',');
            
           Future.wait([
               MysharedPreference().setPreferencesWithoutEncrpytion('activeWorkplan','true'),
              MysharedPreference().setPreferencesWithoutEncrpytion('activeWorkplanColumns', names)
            ]);

            }else if(model.purpose == 'wtemplate' && model.status == 'inactive'){
            
            Future.wait([
                MysharedPreference().clearPreference('activeWorkplan'),
                MysharedPreference().clearPreference('activeWorkplanColumns')
            ]);
            }
            
            return  model;
          }).toList();

      return templates;
    } else {
      return [];
    }
  }

    bool isDialOpen = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<TemplateBloc, TemplateState>(
      listener: (context, state) {
        if (state is TemplateLoadingState) {
         EasyLoading.show(maskType: EasyLoadingMaskType.black); 
        }else if(state is TemplateSuccessState){
          if (state.message == 'data') {
            context.beamToNamed('/admin/database');
          }
            setState(() {
         
            });
            EasyLoading.showSuccess(state.message);
        }else if(state is TemplateFailureState){
          EasyLoading.showError(state.message);
        }
      },
      child: Scaffold(
        body: FutureBuilder(
            future: loadTemplateFromSharedPreference(),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return customCircleIndicator();
              } else if (snapShot.hasError) {
                return Center(
                  child: Text('Error: ${snapShot.error}'),
                );
              } else if (!snapShot.hasData || snapShot.data!.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: 'No records of template yet \n Create one',
                    style: FontStyle.italic,
                    color: active,
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return TemplateListItem(
                        model: snapShot.data![index], context: context);
                  },
                  itemCount: snapShot.data!.length,
                ); }}),

        floatingActionButton: SpeedDial( backgroundColor: active,
      //animatedIcon: AnimatedIcons.menu_close,
      label: Text('Create Template',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
       overlayOpacity: 0.4, // Scrim opacity
    //   overlayColor: Colors.black, // Scrim color
        openCloseDial: ValueNotifier<bool>(isDialOpen),
        spacing: 30,
        children: [
          SpeedDialChild(
            label: 'Additional Template', labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: (){
                    //   context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'atemplate'));
                    //      Navigator.pop(context);
                    //      context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                    //  context.beamToNamed('/admin/builder');
            },
          ),
          SpeedDialChild(
            label: 'Workplan Template', labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: (){
                   context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'wtemplate'));
                         Navigator.pop(context);
                         context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                         context.beamToNamed('/admin/builder');
            },
          ),
          SpeedDialChild(
            label: 'Monthly Template', labelStyle: TextStyle(fontWeight: FontWeight.bold),
            onTap: ()async{
              String? activeWorkplan = await MysharedPreference().getPreferencesWithoutEncrpytion('activeWorkplan');
                        
                        if (activeWorkplan != null && activeWorkplan.isNotEmpty) {
                          context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'mtemplate'));
                        Navigator.pop(context);
                        context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                        context.beamToNamed('/admin/builder');
                        }else{
                          EasyLoading.showError('Active Workplan required');
                        }
            },
          ),
          
        ],
      ),
      ),
    );
  }
}

class TemplatesListLocation extends BeamLocation {
  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable<dynamic> state) {
    return [
      const BeamPage(
          child: TemplatesListPage(),
          title: appName,
          key: ValueKey('templates'))
    ];
  }

  @override
  // TODO: implement pathPatterns
  List<Pattern> get pathPatterns => ['/admin/templates'];
}
