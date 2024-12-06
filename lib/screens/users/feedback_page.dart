import 'package:activity_guide/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const CustomText(text: 'Feedback'));
  }
}
