import 'package:activity_guide/sub_admin/template_builder_page/bloc/builder_bloc.dart';
import 'package:activity_guide/sub_admin/template_list_page/bloc/template_bloc.dart';
import 'package:flutter/material.dart';
import '../../../shared/custom_widgets/custom_text.dart';
import '../../../shared/responsiveness.dart';
import '../../../shared/utils/colors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../template_builder_page/bloc/builder_bloc_event.dart';
import '../bloc/template_event.dart';


class SelectTemplateDialog {
  SelectTemplateDialog.showTransparentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Make the background transparent
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Make the dialog background transparent
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // Semi-transparent inner background
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add,size: 50,color: Color.fromARGB(255, 7, 35, 16),weight: 12,),
                const SizedBox(height: 20,),
                ResponsiveWidget.isSmallScreen(context) ? 
                const CustomText(text: 'What type of template \ndo you want to create',color: active,
                weight: FontWeight.bold,size: 21,) :
                const CustomText(text: 'What type of template do you want to create',color: active,
                weight: FontWeight.bold,size: 21,),
                const SizedBox(height: 40),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(active)),
                      onPressed: (){
                        context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'mtemplate'));
                        Navigator.pop(context);
                        context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                        context.beamToNamed('/admin/builder');
                         },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(text: "Monthly\nTemplate",color: Colors.white,weight: FontWeight.bold,),
                      ),
                    ),
                     ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 26, 23, 16))),
                      onPressed:(){
                         context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'wtemplate'));
                         Navigator.pop(context);
                         context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                         context.beamToNamed('/admin/builder');
                       },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(text: "Workplan\nTemplate",color: Colors.white,weight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),const SizedBox(height: 8,),
                ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 255, 64, 80),)),
                      onPressed:(){
                         context.read<TemplateBloc>().add(TemplatePurposeEvent(purpose: 'atemplate'));
                         Navigator.pop(context);
                         context.read<BuilderBloc>().add(ClearBuilderDataEvent());
                      //   context.beamToNamed('/admin/builder');
                       },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(text: "Additional\nTemplate",color: Colors.white,weight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12,),
              IconButton(onPressed: ()=>Navigator.pop(context),
               icon: const Icon(Icons.close,size: 36,color: Colors.red,))
              ],

            
            ),
          ),
        );
      });
  }
}
