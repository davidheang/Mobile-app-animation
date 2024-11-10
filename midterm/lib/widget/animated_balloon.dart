import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BalloonAnimation extends StatefulWidget {
  @override
  _BalloonAnimationState createState() => _BalloonAnimationState();
}

class _BalloonAnimationState extends State<BalloonAnimation> {
  bool isCentered = false;
  bool isScaled = false;
  bool isOffScreen = false;

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startBalloonAnimation();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startBalloonAnimation() {
    setState(() {
      isCentered = false;
      isScaled = false;
      isOffScreen = false;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isCentered = true;
      });
    });
  }

  void _onBalloonTap() async {
    // Play the sound when the balloon is tapped
    await _audioPlayer
        .play(AssetSource('../assets/sounds/balloon_inflate.mp3'));

    setState(() {
      isScaled = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isOffScreen = true;
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          isCentered = false;
          isScaled = false;
          isOffScreen = false;
        });

        Future.delayed(Duration(milliseconds: 500), () {
          _startBalloonAnimation();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          bottom: isOffScreen
              ? screenHeight * 1.5
              : isCentered
                  ? screenHeight / 2 - 50
                  : -100,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: GestureDetector(
            onTap: _onBalloonTap,
            child: AnimatedScale(
              duration: Duration(milliseconds: 500),
              scale: isScaled ? 2.0 : 1.0,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), 
                    blurRadius: 50, 
                    spreadRadius: 2, 
                    offset: Offset(1, 1), 
                  ),
                ]),
                child: Image.asset(
                  'assets/images/red-balloon.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
