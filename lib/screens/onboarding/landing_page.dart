
import 'package:activity_guide/views/widgets/flip_image.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../users/responsiveness.dart';
import 'authentication.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();


}

class _LandingPageState extends State<LandingPage> {


  @override
  void initState() {
    super.initState();
    // TODO: implement initState
      Future.delayed(Duration(seconds: 8),(){
       Beamer.of(context).beamToNamed('/login',replaceRouteInformation: true);
      //   Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context)=> AuthenticationPage()));
      });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlipCardWidget(frontImage: 'images/nbs.png', backImage: 'images/nbs.png'),
          SizedBox(height: 24,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(' ACTIVITY ', style: TextStyle(
                  backgroundColor: Colors.green[900], fontSize: ResponsiveWidget.isSmallScreen(context) == true ? 36 :48,
                  fontWeight: FontWeight.bold, color: Colors.white),),
              Text('GUIDE',
                style: TextStyle(fontSize: ResponsiveWidget.isSmallScreen(context) == true ? 36 :48, fontWeight: FontWeight.bold,
                    color: Colors.green[900]),)],),
          SizedBox(height: 12,),
          Text('MONITORING AND EVALUTING WORKPLANS OF 16 DEPTS/UNITS',
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
          SizedBox(height: 80,),
          Text('Powered by'),
          Text('SmarterWay Solutions Ltd',
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 24),)
        ],),
    );
  }
}

