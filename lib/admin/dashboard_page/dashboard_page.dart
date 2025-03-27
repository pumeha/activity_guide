import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


String dashboardurl = "https://1drv.ms/x/c/979292c95e1c918d/IQQ71B29H8udTogIbikm_fajAVnJ8TicsaX8QVwmsc67aS8?em=2&AllowTyping=True&ActiveCell='Monthly%20Report'!D10&wdHideGridlines=True&wdHideHeaders=True&wdInConfigurator=True&wdInConfigurator=True";

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});


  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin{
    Timer? _timer;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EasyLoading.addStatusCallback((status){
      if(status == EasyLoadingStatus.dismiss){
        _timer?.cancel();
      }
    });

    //Add a fab for the admin for entering the new powerBi link

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body:  InAppWebView(
      //display the swipetoRefresh in the InappBrowser
    initialUrlRequest:
    URLRequest(url: WebUri(dashboardurl)),
      keepAlive: InAppWebViewKeepAlive(),
      initialSettings: InAppWebViewSettings(cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,javaScriptEnabled: true),

      onWebViewCreated: (controller)   {
        _timer?.cancel();
          EasyLoading.show(
            status: 'Loading'
        );
      },
      onLoadStart: (controller,url) {
        _timer?.cancel();
        EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
        Expanded(child: Text('Initializing Dashboard...',
          style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),)),
        CircularProgressIndicator(color: Colors.white,),
      ],),
      backgroundColor: Colors.green[600],),
      );
      },
    onLoadStop: (controller,url){

    },),);
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green], // Your two colors here
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text('Initializing Dashboard...', style: TextStyle(color: Colors.white))),
              CircularProgressIndicator(),
            ],
          ),
        ),
        duration: Duration(seconds: 5),
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