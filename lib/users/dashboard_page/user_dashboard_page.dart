import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:activity_guide/shared/custom_widgets/custom_text.dart';
import 'package:activity_guide/shared/utils/http_helper/storage_keys.dart';
import 'package:activity_guide/shared/utils/myshared_preference.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_cubit.dart';
import 'package:activity_guide/users/dashboard_page/cubit/user_dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage>
    with AutomaticKeepAliveClientMixin {
  String? dashboardUrl;
  late String viewId;
  html.IFrameElement? iframe;

  @override
  void initState() {
    super.initState();
    context.read<UserDashboardCubit>().show(true);
    _loadDashboardUrl();
  }

  Future<void> _loadDashboardUrl() async {
    final url = await MysharedPreference().getPreferences(DashboardKey.link);
    if (url != null && url.isNotEmpty) {
      setState(() {
        dashboardUrl = url;
        _createIframe();
      });
    }
  }

  void showCustomSnackBar() {
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
      duration: const Duration(seconds: 10),
      backgroundColor: Colors.green[600],
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

  void _createIframe() {
    viewId = 'dashboard-iframe-${DateTime.now().millisecondsSinceEpoch}';

    iframe = html.IFrameElement()
      ..src = dashboardUrl!
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..onLoad.listen((event) {
        print('✅ Iframe loaded');
        EasyLoading.dismiss();
        showCustomSnackBar();
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => iframe!);
    EasyLoading.show(status: 'Loading dashboard...');
  }

  void _refreshIframeFromBloc() {
    if (dashboardUrl != null) {
      _createIframe();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (dashboardUrl == null) {
      return const Center(
        child: CustomText(
          text: 'No Dashboard yet',
          weight: FontWeight.bold,
          style: FontStyle.italic,
        ),
      );
    }

    return BlocBuilder<UserDashboardCubit, UserDashboardState>(
      builder: (context, state) {
        if (state is refreshDashoardState) {
          _refreshIframeFromBloc();
          context.read<UserDashboardCubit>().show(true);
        } else if (state is offlineState) {
          EasyLoading.showInfo('No internet connection');
        }

        final isVisible = state is UserDashboard ? state.show : true;

        return Scaffold(
         
          body: Visibility(
            visible: isVisible,
            child: HtmlElementView(viewType: viewId),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }
}
