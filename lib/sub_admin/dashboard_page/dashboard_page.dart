import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:activity_guide/sub_admin/dashboard_page/cubit/dashboard_cubit.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/constants.dart';
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
  // Timer? _timer;

  InAppWebViewController? webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DashboardCubit>().hideDashboard();
  }

  Future<String> getDashboardUrl() async {
    String? dashboardurl;  dashboardurl = await MysharedPreference().getPreferences(DashboardKey.link);
    return dashboardurl ?? '';
  }

  TextEditingController urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        body: BlocListener<DashboardCubit, DashboardCubitState>(
      listener: (context, state) {
        if (state is DashboardLoading) {
          // print('Loading');
          EasyLoading.show();
        } else if (state is DashboardSuccess) {
          // print(state.message!);
          EasyLoading.showSuccess(state.message!);
        } else if (state is DashboardFailure) {
          EasyLoading.showError(state.errorMessage!);
        }
      },
      child: SafeArea(
        child: FutureBuilder(
            future: getDashboardUrl(),
            builder: (context, snapshot) {
            
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null && snapshot.data!.isEmpty) {
                  EasyLoading.showInfo('No Dashboard found');
                } else {
                  urlController.text = snapshot.data!;
                }
                
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, top: 8, bottom: 8),
                      child: Card(
                        color: Colors.white,
                        elevation: 8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 8, top: 8, bottom: 8),
                                child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: urlController,
                                      validator: validatorFunction,
                                    )),
                              ),
                            ),
                            TextButton(
                                onPressed: () async{
                                  
                                  if (_formKey.currentState!.validate()) {
                                      context.read<DashboardCubit>().showDashboard();
                                    
                                  }
                                },
                                child: const CustomText(
                                  text: 'Test',
                                  weight: FontWeight.bold,
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                              context.read<DashboardCubit>().updateDashboardUrl( dashbordUrl: urlController.text);
                                    }},
                                  child: const CustomText(
                                    text: 'Save',
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  )),)
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<DashboardCubit, DashboardCubitState>(
                      builder: (context, state) {
                        
                        return Visibility( visible: state is DashboardShow && urlController.text.isNotEmpty,
                          child: Expanded(
                            child: InAppWebView(
                              initialUrlRequest: URLRequest(url:  WebUri(urlController.text)),
                              keepAlive: InAppWebViewKeepAlive(),
                              initialSettings: InAppWebViewSettings(
                                  cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                                  javaScriptEnabled: true),
                              onWebViewCreated: (controller) {
                                 EasyLoading.show(status: 'Loading');
                                webViewController = controller;
                              },
                              onLoadStart: (controller, url) {
                                // _timer?.cancel();
                                EasyLoading.dismiss();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Initializing Dashboard...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.green[600],
                                  ),
                                );
                              },
                              onLoadStop: (controller, url) {
                                print(' onLoadStop');
                                //  _timer?.cancel();
                                EasyLoading.dismiss();
                              },
                              onReceivedError: (controller, request, error) {
                                print('onReceivedError');
                                //  _timer?.cancel();
                                EasyLoading.dismiss();
                                EasyLoading.showError(error.description);
                              },
                              onReceivedHttpError:
                                  (controller, request, errorResponse) {
                                print('onReceivedHttpError');
                              },), ),); }, ), ], );
              } else {
                return customCircleIndicator();
              }
            }), ), ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  void showCustomSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green], // Your two colors here
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Row(
          children: [
            Expanded(
                child: Text('Initializing Dashboard...',
                    style: TextStyle(color: Colors.white))),
            CircularProgressIndicator(),
          ],
        ),
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white, // Change text color for the action button
        onPressed: () {
          // Dismiss the SnackBar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
