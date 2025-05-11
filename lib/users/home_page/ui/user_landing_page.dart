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
              EasyLoading.showSuccess('Template Loaded Successful');
              context.beamToNamed('/home/template');
            }
          },
        ),
        BlocListener<UserHomeCubit, UserHomeState>(
          listener: (context, state) {
            if (state is UserHomeLoading) {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
            } else if(state is UserHomeSuccess) {
              EasyLoading.showSuccess('Success');
              context.beamToNamed('/home/database');
            }else if(state is UserHomeFailure){
                EasyLoading.showError(state.message!);
            }
          },
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                  text: 'What do you want to work on?',
                  size: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  weight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      context
                          .read<DataCollectionBloc>()
                          .add(LoadDataCollectionMonthlyTemplateEvent());
                    },
                    color: const Color.fromARGB(203, 4, 89, 68),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: 'Monthly\nTemplate',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  MaterialButton(
                    onPressed: () {
                      context
                          .read<DataCollectionBloc>()
                          .add(LoadDataCollectionWorkplanTemplateEvent());
                    },
                    color: const Color.fromARGB(255, 37, 78, 89),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: 'Workplan\nTemplate',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      context.read<UserHomeCubit>().downloadMonthlyData();
                    },
                    color: const Color.fromARGB(235, 57, 85, 11),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: '  \tView\n Monthly\n \tData',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  MaterialButton(
                    onPressed: () {
                      context.read<UserHomeCubit>().downloadWorkplanData();
                    },
                    color: const Color.fromARGB(255, 224, 173, 20),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: '  \tView\n Workplan\n \tData',
                        color: Colors.white,
                        weight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
