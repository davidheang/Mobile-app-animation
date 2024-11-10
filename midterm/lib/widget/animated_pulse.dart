import 'package:flutter/material.dart';

class AnimatedBalloonWidgetPulse extends StatefulWidget {
  @override
  _AnimatedBalloonWidgetPulseState createState() =>
      _AnimatedBalloonWidgetPulseState();
}

class _AnimatedBalloonWidgetPulseState extends State<AnimatedBalloonWidgetPulse>
    with TickerProviderStateMixin {
  late AnimationController _controllerPulse;

  late Animation<double> _animationPulse;

  @override
  void initState() {
    super.initState();
    _controllerPulse =AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animationPulse = Tween(begin: 0.9, end: 1.1).animate(
        _controllerPulse);
    _controllerPulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controllerPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return ScaleTransition(
      scale: _animationPulse,
      child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), 
              blurRadius: 1000, 
              spreadRadius: 1, 
              offset: Offset(1, 1),
            ),
          ],
            image: DecorationImage(
              image: AssetImage('assets/images/Multi_Balloon.png'), 
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
  }
}
