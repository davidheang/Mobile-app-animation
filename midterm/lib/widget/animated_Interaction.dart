import 'package:flutter/material.dart';

class AnimatedInteraction extends StatefulWidget {
  const AnimatedInteraction({super.key});

  @override
  State<AnimatedInteraction> createState() => _AnimatedInteractionState();
}

class _AnimatedInteractionState extends State<AnimatedInteraction>
    with TickerProviderStateMixin {
  late AnimationController _controllerIntercation;
  Offset _position = Offset(0, 0);
  late Offset _startPosition;
  late Offset _endPosition;

  @override
  void initState() {
    super.initState();
    _controllerIntercation = AnimationController(
        vsync: this,
        lowerBound: double.negativeInfinity,
        upperBound: double.infinity);
  }

  @override
  void dispose() {
    _controllerIntercation.dispose();
    super.dispose();
  }
  
  

  void _onPanStart(DragStartDetails details){
    _controllerIntercation.stop();
    _startPosition = details.globalPosition;
  }
  void _onPanUpdate(DragUpdateDetails details){
    setState(() {
      _position += details.delta;
    });
  }
  void _onPanEnd(DragEndDetails details){

  }



  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
          animation: _controllerIntercation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_position.dx, _position.dy),
              child: Image.asset(
                'assets/images/BeginningGoogleFlutter-Balloon.png',
                height: 120,
                width: 120,
              ),
            );
          }),
    );
  }
}
