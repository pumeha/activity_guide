import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc_event.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_bloc.dart';
import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import 'package:flutter/material.dart';

import 'package:beamer/beamer.dart';
import '../responsiveness.dart';

class TemplateListItem extends StatelessWidget {
  final TemplateModel model;
  final BuildContext context;
  const TemplateListItem({super.key,required this.model, required this.context});

  @override
  Widget build(BuildContext context) {
    bool isActive = model.status == 'active' ? true : false;
    return  Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        ResponsiveWidget.isLargeScreen(context) ? 300 : 80,
                    vertical: 10),
                child: Card(
                  color: const Color(0xFFFFFFFF),
                  elevation: 12,
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          model.purpose == 'mtemplate' ? 'Monthly Template' :'Workplan Template' ,
                          style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 18),
                        ))),
                        Tooltip(
                          message: model.status == 'active' ? 'Active Template' : 'Inactive Template',
                          child: Checkbox(value: isActive, onChanged: (v){
                           context.read<TemplateBloc>().add(TemplateActiveOrInactiveEvent(templateName: model.templateName,
                            status: model.status!));
                          }),)
                      ],),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      const  SizedBox(height: 12,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                          context.read<TemplateBloc>().add(TemplateSelectedEvent(model: model));
                          context.beamToNamed('/admin/preview_template');
                                },
                                icon: const Icon(Icons.preview,
                                    color: Colors.green, size: 24),
                                tooltip: 'Preview Template',
                              ),
                              IconButton(
                                onPressed: () {
                         context.read<TemplateBloc>().add(TemplateFetchDataEvent(templateName: model.templateName));
                                },
                                icon: const Icon(Icons.dataset,
                                    color: Colors.black, size: 24),
                                tooltip: 'Template Database',
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Color.fromARGB(255, 251, 180, 0), size: 24),
                                onPressed: () {
                                  context.read<BuilderBloc>().add(EditTemplateEvent(rows: model.values,templateName: model.templateName));
                                  context.beamToNamed('/admin/update_template');
                                },
                                tooltip: 'Edit Template',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever_rounded,
                                    color: Colors.red, size: 24),
                                onPressed: () {
                                  context.read<TemplateBloc>().add(TemplateDeleteEvent(templateName: model.templateName));
                                },
                                tooltip: 'Delete Template',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            
  }
}