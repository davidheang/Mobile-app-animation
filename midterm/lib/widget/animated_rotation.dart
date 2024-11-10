import 'package:flutter/material.dart';

class AnimatedBalloonWidgetRotate extends StatefulWidget {
  @override
  _AnimatedBalloonWidgetRotateState createState() => _AnimatedBalloonWidgetRotateState();
}

class _AnimatedBalloonWidgetRotateState extends State<AnimatedBalloonWidgetRotate> with TickerProviderStateMixin {
  
  late AnimationController _controllerRotate;
  late Animation<double> _animationRotate;

  
  @override
  void initState() {
    super.initState();
    _controllerRotate = AnimationController(duration: Duration(seconds: 10), vsync: this);
  }

  @override
  void dispose() {
    _controllerRotate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _animationRotate = Tween(begin: -0.08, end: 0.08).animate(CurvedAnimation(parent: _controllerRotate, curve: Curves.easeIn));

    _controllerRotate.repeat(reverse: true);

    return RotationTransition(
      turns: _animationRotate,
      child: Image.asset(
        '../assets/images/BeginningGoogleFlutter-Balloon.png',
        height: 200,
        width: 100,
      ),
    );
  }
}