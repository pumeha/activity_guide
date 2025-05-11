import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:activity_guide/sub_admin/dashboard_page/cubit/dashboard_cubit.dart';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'cubit/dashboard_cubit_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController urlController = TextEditingController();

  late final String viewId;
  html.IFrameElement? iframe;

  @override
  void initState() {
    super.initState();
    viewId = 'dashboard-view-${DateTime.now().millisecondsSinceEpoch}';
    _initializeIframe();
    context.read<DashboardCubit>().hideDashboard();
    _loadDashboardUrl();
  }

  void _initializeIframe() {
    iframe = html.IFrameElement()
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..onLoad.listen((event) {
        EasyLoading.dismiss();
        _showCustomSnackBar();
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int _) => iframe!);
  }

  Future<void> _loadDashboardUrl() async {
    final url = await MysharedPreference().getPreferences(DashboardKey.link);
    if (url != null && url.isNotEmpty) {
      setState(() {
        urlController.text = url;
        iframe?.src = url;
      });
    } else {
      EasyLoading.showInfo('No Dashboard found');
    }
  }

  void _showCustomSnackBar() {
    final snackBar = SnackBar(
      content: const Row(
        children: [
          Expanded(
            child: Text(
              'Initializing Dashboard...',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          CircularProgressIndicator(color: Colors.white),
        ],
      ),
      backgroundColor: Colors.green[600],
      duration: const Duration(seconds: 10),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: BlocListener<DashboardCubit, DashboardCubitState>(
        listener: (context, state) {
          if (state is DashboardLoading) {
            EasyLoading.show();
          } else if (state is DashboardSuccess) {
            EasyLoading.showSuccess(state.message ?? 'Updated');
            _loadDashboardUrl();
          } else if (state is DashboardFailure) {
            EasyLoading.showError(state.errorMessage ?? 'Error');
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                child: Card(
                  elevation: 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: urlController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Enter a valid URL';
                                }
                                if (!val.startsWith('http')) {
                                  return 'URL must start with http or https';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter Dashboard URL',
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            iframe?.src = urlController.text;
                            EasyLoading.show(status: 'Testing dashboard...');
                            context.read<DashboardCubit>().showDashboard();
                          }
                        },
                        child: const CustomText(
                          text: 'Test',
                          weight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<DashboardCubit>().updateDashboardUrl(
                                    dashbordUrl: urlController.text,
                                  );
                            }
                          },
                          child: const CustomText(
                            text: 'Save',
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<DashboardCubit, DashboardCubitState>(
                builder: (context, state) {
                  final isVisible =
                      state is DashboardShow && urlController.text.isNotEmpty;
                  return Visibility(
                    visible: isVisible,
                    child: Expanded(
                      child: HtmlElementView(viewType: viewId),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    EasyLoading.dismiss();
    iframe = null;
    super.dispose();
  }
}
