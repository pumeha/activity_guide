import 'package:flutter/material.dart';
import 'dart:math';

class FlipCardWidget extends StatefulWidget {
  final String frontImage;
  final String backImage;

  const FlipCardWidget({
    Key? key,
    required this.frontImage,
    required this.backImage,
  }) : super(key: key);

  @override
  _FlipCardWidgetState createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and loop it
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Loop the animation indefinitely

    // Define the animation to rotate between 0 and pi
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective effect
            ..rotateY(_animation.value),
          child: _animation.value <= pi / 2
              ? Image.asset(widget.frontImage) // Front image
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(pi),
            child: Image.asset(widget.backImage), // Back image
          ),
        );
      },
    );
  }
}
