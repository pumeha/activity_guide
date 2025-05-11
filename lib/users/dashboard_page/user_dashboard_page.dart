import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:activity_guide/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final String dashboardUrl = defaultDashboard; // Change this
  late String viewId;
  late html.IFrameElement iframe;

  @override
  void initState() {
    super.initState();
    _createIframe(); // Initial iframe setup
  }

  void _createIframe() {
    viewId = 'dashboard-iframe-${DateTime.now().millisecondsSinceEpoch}'; // Unique ID to force reload

    iframe = html.IFrameElement()
      ..src = dashboardUrl
      ..style.border = 'none'
      ..width = '100%'
      ..height = '100%'
      ..onLoad.listen((event) {
        print('✅ Dashboard iframe loaded.');
        EasyLoading.dismiss();
      });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => iframe);

    EasyLoading.show(status: 'Refreshing...');
  }

  void _refreshIframe() {
    setState(() {
      _createIframe(); // Recreate iframe to refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshIframe,
            tooltip: 'Refresh Dashboard',
          )
        ],
      ),
      body: HtmlElementView(viewType: viewId),
    );
  }
}
