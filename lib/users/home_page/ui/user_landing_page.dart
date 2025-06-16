import 'dart:convert';

import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/sub_admin/template_list_page/template_model.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_bloc.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_event.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../shared/utils/constants.dart';
import '../../data_collection_page/bloc/data_collection_state.dart';
import '../cubit/user_home_cubit.dart';
import '../cubit/user_home_state.dart';

class UserLandingPage extends StatefulWidget {
  const UserLandingPage({super.key});

  @override
  State<UserLandingPage> createState() => _UserLandingPageState();
}

class _UserLandingPageState extends State<UserLandingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserDashboardCubit>().show(false);
  }

  Template template = Template.Monthly;

  String? range;
  String? selectedAdditionalTemplate;
  List<TemplateModel>? additionalTemplateModelList;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DataCollectionBloc, DataCollectionState>(
          listener: (context, state) {
            if (state is DataCollectionStateLoading) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
            } else if (state is DataCollectionStateFailure) {
              EasyLoading.showError(state.errorMessage);
            } else {
              EasyLoading.dismiss();
              context.beamToNamed('/home/template');
            }
          },
        ),
        BlocListener<UserHomeCubit, UserHomeState>(
          listener: (context, state) {
            if (state is UserHomeLoading) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
            } else if (state is UserHomeSuccess) {
              EasyLoading.showSuccess('Success');
              context.beamToNamed('/home/database');
            } else if (state is UserHomeFailure) {
              EasyLoading.showError(state.message!);
            }
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CustomText(
                    text: 'Warm Welcome',
                    size: 24,
                    color: active,
                    weight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                    text: 'Which template do you want to work on?',
                    size: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SegmentedButton<Template>(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return active;
                      }
                      return Colors.white;
                    }),
                    foregroundColor:
                        WidgetStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                  ),
                  segments: const <ButtonSegment<Template>>[
                    ButtonSegment<Template>(
                        value: Template.Monthly,
                        label: Text(
                          'Monthly',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    ButtonSegment<Template>(
                        value: Template.Workplan,
                        label: Text('Workplan',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    ButtonSegment<Template>(
                        value: Template.Additional,
                        label: Text('Additional',
                            style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                  selected: <Template>{template},
                  onSelectionChanged: (Set<Template> newTemplate) async {
                    setState(() {
                      template = newTemplate.first;
                      selectedAdditionalTemplate = null;
                    });
                    if (template.name == 'Additional') {
                      String? additionalTemplates = await MysharedPreference()
                          .getPreferencesWithoutEncrpytion(
                              additionalTemplateList);

                      if (additionalTemplates != null &&
                          additionalTemplates.isNotEmpty) {
                        List<dynamic> decodedList =
                            jsonDecode(additionalTemplates);

                        additionalTemplateModelList =
                            decodedList.map((template) {
                          if (template['values'] is String) {
                            template['values'] = jsonDecode(template['values']);
                          }

                          return TemplateModel.fromJson(template);
                        }).toList();

                        range = additionalTemplateModelList!.map((template) {
                          return template.displayName;
                        }).join(',');
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: template.name == 'Additional',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      range == null
                          ? const SizedBox.shrink()
                          : const Text(
                              'Select Template',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(
                        width: 8,
                      ),
                      range == null
                          ? const Text('No additional Template')
                          : SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<String>(
                                value: selectedAdditionalTemplate,
                                items: range
                                    .toString()
                                    .split(',')
                                    .toSet()
                                    .map<DropdownMenuItem<String>>(
                                        (e) => DropdownMenuItem(
                                              value: e,
                                              child: Tooltip(
                                                message: e,
                                                child: Text(
                                                  e,
                                                ),
                                              ),
                                            ))
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedAdditionalTemplate = value;

                                  });
                                },
                                isExpanded: true,
                                validator: validatorFunction,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Visibility(
                  visible: template.name != 'Additional' ||
                      (template.name == 'Additional' &&
                          selectedAdditionalTemplate != null),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          if (template.name == 'Monthly') {
                            context
                                .read<DataCollectionBloc>()
                                .add(LoadDataCollectionMonthlyTemplateEvent());
                          } else if (template.name == 'Workplan') {
                            context
                                .read<DataCollectionBloc>()
                                .add(LoadDataCollectionWorkplanTemplateEvent());
                          } else if (template.name == 'Additional') {
                            dynamic data =
                                additionalTemplateModelList!.where((template) {
                              return template.displayName ==
                                  selectedAdditionalTemplate!;
                            }).map((template) {
                              return jsonEncode(template.toJson()['values']);
                            }).join();

                            context.read<DataCollectionBloc>().add(
                                LoadDataCollectionAdditionalTemplateEvent(
                                    data: jsonDecode(data) as List,
                                    displayName: selectedAdditionalTemplate!));
                          }
                        },
                        color: const Color.fromARGB(255, 6, 115, 41),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            template.name == 'Additional'
                                ? '\n Template \n'
                                : '\t ${template.name}\n\t Template',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (template.name == 'Monthly') {
                            context
                                .read<UserHomeCubit>()
                                .downloadData(templateType: 'Monthly');
                          } else if (template.name == 'Workplan') {
                            context
                                .read<UserHomeCubit>()
                                .downloadData(templateType: template.name);
                          } else if (template.name == 'Additional') {
                            String data = additionalTemplateModelList!
                                .where((template) =>
                                    template.displayName ==
                                    selectedAdditionalTemplate)
                                .map((template) => template.templateName)
                                .join();

                            context
                                .read<UserHomeCubit>()
                                .downloadData(templateType: data);
                          }
                        },
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            template.name == 'Additional'
                                ? '\n \t Data \t \n'
                                : '${template.name} \n\t Data',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO data Download for additional Template
enum Template { Monthly, Workplan, Additional }
