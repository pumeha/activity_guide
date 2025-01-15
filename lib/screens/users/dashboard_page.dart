import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});



  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String dashboardurl = 'https://app.powerbi.com/view?r=eyJrIjoiYzlhNDhhZGItYjE5My00MTA3LWI3MjUtMzdjMjg1MmU2OGQ4IiwidCI6IjQ2NTRiNmYxLTBlNDctNDU3OS1hOGExLTAyZmU5ZDk0M2M3YiIsImMiOjl9';

  @override
  Widget build(BuildContext context) {

    return PopScope(
      child: Scaffold(body: Padding(padding: const EdgeInsets.only(top: 60),
      child: InAppWebView(
      initialUrlRequest:
      URLRequest(url: WebUri(dashboardurl)),),),),
    );
  }
}
//pop