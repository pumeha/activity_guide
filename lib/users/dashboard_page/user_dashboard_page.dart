import 'dart:async';
import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/user_dashboard_state.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage>
    with AutomaticKeepAliveClientMixin {
  String? dashboardurl;
  InAppWebViewController? webViewController;
  bool visible = true;
  @override
  void initState() {
    super.initState();
 
    context.read<UserDashboardCubit>().show(true);
  }

  Future<void> getDashboardUrl() async {
    dashboardurl = await MysharedPreference().getPreferences(DashboardKey.link);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
        future: getDashboardUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final bool hasDashboardUrl = dashboardurl != null && dashboardurl!.isNotEmpty;

            return hasDashboardUrl ? BlocBuilder<UserDashboardCubit, UserDashboardState>(
              builder: (context, state) {
                if (state is UserDashboard) {
                  return Visibility(
                    visible: state.show,
                    child: InAppWebView(
                        //display the swipetoRefresh in the InappBrowser
                        initialUrlRequest:
                            URLRequest(url: WebUri(dashboardurl!) ),
                        keepAlive: InAppWebViewKeepAlive(),
                        initialSettings: InAppWebViewSettings(
                            cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
                            javaScriptEnabled: true),
                        onWebViewCreated: (controller) {
                          EasyLoading.show(status: 'Loading');
                        },
                        onLoadStart: (controller, url) {
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
                        }),
                  );
               }else if(state is refreshDashoardState){
                  if (webViewController  != null) {
                      webViewController!.reload();
                    }
                  context.read<UserDashboardCubit>().show(true);
                }else if(state is offlineState){
                    EasyLoading.showInfo('No internet connection');
                }
                return const CustomText(text: ''); },) :
                
                 const Center(child: CustomText(text: 'No Dashboard yet',
                 weight: FontWeight.bold,style: FontStyle.italic,),);
          } else {
            return customCircleIndicator();
          }
        });
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
