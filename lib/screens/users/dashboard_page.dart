import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


String dashboardurl = 'https://app.powerbi.com/view?r=eyJrIjoiYzlhNDhhZGItYjE5My00MTA3LWI3MjUtMzdjMjg1MmU2OGQ4IiwidCI6IjQ2NTRiNmYxLTBlNDctNDU3OS1hOGExLTAyZmU5ZDk0M2M3YiIsImMiOjl9';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});


  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(body:  InAppWebView(
    initialUrlRequest:
    URLRequest(url: WebUri(dashboardurl)),
      keepAlive: InAppWebViewKeepAlive(),
      initialSettings: InAppWebViewSettings(cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,javaScriptEnabled: true),
    ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
//pop