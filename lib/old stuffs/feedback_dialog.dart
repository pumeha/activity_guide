
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../custom_widgets/custom_text.dart';
import '../shared/utils/colors.dart';

void showCustomDialog(BuildContext context) {
  showDialog(context: context,
      barrierDismissible: false,
      builder: (context){

    return AlertDialog( backgroundColor: Colors.white,
      title: Column(
        children: [
         CustomText(text: 'Send a Feedback',size: 24,color: Colors.black,weight: FontWeight.bold,),
         CustomText(text: 'We love to hear you mind',style: FontStyle.italic,)
        ],
      ),
      content: SizedBox(width: 100,
        child: const TextField(maxLines: 8,expands: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: active))
          )),
      ),
      actions: [
          TextButton(onPressed: (){Navigator.pop(context);},
              child: Text('Cancel',style: TextStyle(color: Colors.red),),
          style: ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.2))
          ),),
          TextButton(onPressed: (){
            EasyLoading.showSuccess('Submitted');
            Navigator.pop(context);
          }, child: Text('Submit',style: TextStyle(color: light),),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(active)),)
      ],
    );
  });
}
