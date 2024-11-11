import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final String imagePath; 
  final Duration duration;
  final double imageWidth;
  final double imageHeight;

  const AnimatedBackground({
    required this.imagePath,
    this.duration = const Duration(seconds: 2),
    this.imageWidth = 100.0,
    this.imageHeight = 100.0,
  });

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  bool isOnRight = false; 

  @override
  void initState() {
    super.initState();
    _startAnimation(); // Start the animation when the widget is loaded
  }

  void _startAnimation() {
    setState(() {
      isOnRight = !isOnRight;
    });

    // Continuously restart the animation
    Future.delayed(widget.duration, _startAnimation);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: widget.duration,
          curve: Curves.easeInOut,
          left: isOnRight ? screenWidth - widget.imageWidth : 0,
          top: MediaQuery.of(context).size.height / 2 - widget.imageHeight / 2,
          child: Image.asset(
            widget.imagePath,
            width: widget.imageWidth,
            height: widget.imageHeight,
          ),
        ),
      ],
    );
  }
}
