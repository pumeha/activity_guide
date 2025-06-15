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

class _UserDashboardPageState extends State<UserDashboardPage> {
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
          _smsKey.currentState?.hideCurrentSnackBar();
        },
      ),
    );

    _smsKey.currentState?.showSnackBar(snackBar);
  }

  void _createIframe() {
    viewId = 'dashboard-iframe-${DateTime.now().millisecondsSinceEpoch}';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (dashboardUrl == 'not-found') {
      final backgroundColor =
          isDarkMode ? '#121212' : Theme.of(context).primaryColor;
      final textColor = isDarkMode ? '#ffffff' : '#333333';

      final notFoundDiv = html.DivElement()..setInnerHtml('''
        <div style="background-color: $backgroundColor; height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; font-family: Arial, sans-serif;">
          <h1 style="color: $textColor; font-size: 32px;">Dashboard not created</h1>
          <p style="color: $textColor; font-size: 18px;">
            The dashboard  has not been set up yet.
          </p>
        </div>
      ''', treeSanitizer: html.NodeTreeSanitizer.trusted);

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry
          .registerViewFactory(viewId, (int viewId) => notFoundDiv);
    } else {
      iframe = html.IFrameElement()
        ..src = dashboardUrl!
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%'
        ..style.height = '100%'
        ..style.width = '100%'
        ..onLoad.listen((event) {
          EasyLoading.dismiss();
          showCustomSnackBar();
        });

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry
          .registerViewFactory(viewId, (int viewId) => iframe!);
      EasyLoading.show(status: 'Loading dashboard...');
    }
  }

  void _refreshIframeFromBloc() {
    if (dashboardUrl != null) {
      _createIframe();
    }
  }

  final GlobalKey<ScaffoldMessengerState> _smsKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
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

        return ScaffoldMessenger(
          key: _smsKey,
          child: Scaffold(
            body: Visibility(
              visible: isVisible,
              child: HtmlElementView(viewType: viewId),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    _smsKey.currentState?.hideCurrentSnackBar();
    super.dispose();
  }
}
