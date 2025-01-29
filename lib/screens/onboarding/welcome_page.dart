import 'package:activity_guide/providers/template_provider.dart';
import 'package:activity_guide/screens/onboarding/feedback_dialog.dart';
import 'package:activity_guide/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {



  String welcome_note = 'Welcome to Activity Guide. Our app provides essential tools for effective project management,'
      ' from comprehensive activity templates to real-time dashboards, ensuring your corporate planning runs smoothly.';
  String about = 'At Activity Guide, we focus on empowering corporate planning departments with a robust platform for tracking and analyzing work plans. '
      'Our dedicated application offers a seamless experience for monitoring activities and gathering feedback, making your project oversight efficient and effective. Welcome to Activity Guide.';


  @override
    Widget build(BuildContext context) {

    Future.microtask(()async{
    await Provider.of<TemplateProvider>(context,listen: false).currentUser();
    });
    //print(value);
      return Scaffold( backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 40,left: 36,right: 36),
            child: Column(
              children: [
                Container(
                    child: Text(welcome_note,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),
                      textAlign: TextAlign.justify,)
                ),
                SizedBox(height: 24,),
                Text('Features of Activity Guide',style: GoogleFonts.actor(fontSize: 24,color: active,fontWeight: FontWeight.bold),),
                SizedBox(height: 24,),
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: listTitle('Actvity Guide Template'),
                        subtitle: listSubTitle('Leverage our customizable activity templates designed to meet your specific project needs, '
                            'ensuring you have the right structure for effective planning.'),
                      ),
                    )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListTile(
                        title: listTitle('Real-time dashboard'),
                        subtitle: listSubTitle('Our user-friendly dashboard provides real-time updates and insights into your project’s progress,'
                            ' allowing for quick adjustments and informed decision-making.'),
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 24,),
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        title: listTitle('Feedback collection'),
                        subtitle: listSubTitle('We facilitate easy feedback collection from stakeholders,'
                            ' ensuring you gather valuable insights that drive project improvements and success.'),
                      ),
                    )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListTile(
                        title: listTitle('Notification alerts'),
                        subtitle: listSubTitle('Stay informed with our notification system that alerts you to important updates and deadlines, helping you manage your projects proactively.'),
                      ),
                    ))
                  ],
                ),
                SizedBox(height: 50,),
                Text('Powered by'),
                Text('SmarterWay Solutions Ltd',
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 24),),
                SizedBox(height: 20,)



              ],
            ),
          ),
        ),
        floatingActionButton: Visibility(
          visible: context.watch<TemplateProvider>().isAdmin,
          child: Tooltip(
            message: 'Send us a feedback',
            child: FloatingActionButton(onPressed: (){
              showCustomDialog(context);
            },child: Icon(Icons.feedback,color: light,),
              backgroundColor: active,),
          ),),);
    }
  }



Widget listTitle(String title) =>
    Text(title,
      style: GoogleFonts.adamina(fontSize: 18,fontWeight: FontWeight.bold,color: active),);
Widget listSubTitle(String subtitle) =>
    Text(subtitle,
      style: GoogleFonts.roboto(fontSize: 16),textAlign: TextAlign.justify,);