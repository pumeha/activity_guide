import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/colors.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_bloc.dart';
import 'package:activity_guide/users/data_collection_page/bloc/data_collection_event.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states){
                        if(states.contains(WidgetState.selected)){
                          return active;
                        }return Colors.white;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states){
                        if(states.contains(WidgetState.selected)){
                          return Colors.white;
                        } return Colors.black;
                      }),),
                  segments: const <ButtonSegment<Template>>[
                    ButtonSegment<Template>(
                        value: Template.Monthly, label: Text('Monthly',style: TextStyle(fontWeight: FontWeight.bold),)),
                    ButtonSegment<Template>(
                        value: Template.Workplan, label: Text('Workplan',style: TextStyle(fontWeight: FontWeight.bold))),
                    ButtonSegment<Template>(
                        value: Template.Additional, label: Text('Additional',style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                  selected: <Template>{template},
                  onSelectionChanged: (Set<Template> newTemplate) {
                    setState(() {
                      template = newTemplate.first;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
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
                        }
                      },
                      color: Color.fromARGB(255, 6, 115, 41),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          '\t ${template.name}\n\t Template',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (template.name == 'Monthly') {
                          context.read<UserHomeCubit>().downloadMonthlyData();
                        } else if (template.name == 'Workplan') {
                          context.read<UserHomeCubit>().downloadWorkplanData();
                        }
                      },
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '${template.name} \n\t Data',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Template { Monthly, Workplan, Additional }
