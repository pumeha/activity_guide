import 'dart:convert';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/custom_widgets/template_list_item.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import 'package:activity_guide/sub_admin/template_list_page/view/select_template_dialog.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../../shared/utils/constants.dart';
import '../bloc/template_bloc.dart';
import '../bloc/template_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TemplatesListPage extends StatefulWidget {
  const TemplatesListPage({super.key});

  @override
  State<TemplatesListPage> createState() => _TemplatesListPageState();
}

class _TemplatesListPageState extends State<TemplatesListPage> {




  Future<List<TemplateModel>> loadTemplateFromSharedPreference() async {
    String? templatesJson =
        await MysharedPreference().getPreferences(templateListKeys);

    if (templatesJson != null && templatesJson.isNotEmpty) {
      final List<dynamic> decodedList = jsonDecode(templatesJson);
      final List<TemplateModel> templates = decodedList
          .map((template) => TemplateModel.fromJson(template))
          .toList();
      return templates;
    } else {
      return [];
    }
  }

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
        backgroundColor: Colors.white70,
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
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SelectTemplateDialog.showTransparentDialog(context);
          },
          heroTag: 'add',
          tooltip: 'Create template',
          child: const Icon(Icons.add),
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
