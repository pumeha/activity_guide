import 'package:flutter/material.dart';

class CustomHVScrollBar extends StatelessWidget {
  final Widget child;
  const CustomHVScrollBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ScrollController v = ScrollController();
    ScrollController h = ScrollController();

    return Scrollbar( controller: h, thumbVisibility: true,
      child: SingleChildScrollView( controller: h, scrollDirection: Axis.horizontal,
        child: Scrollbar( controller: v, thumbVisibility: true,
          child: SingleChildScrollView( controller: v, scrollDirection: Axis.vertical,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}