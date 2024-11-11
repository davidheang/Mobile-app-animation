import 'package:flutter/material.dart';
// import 'pages/home.dart';
// import 'pages/animation.dart';
// import 'widget/balloon.dart';
import 'widget/animated_rotation.dart';
import 'widget/animated_Interaction.dart';
import 'widget/animated_pulse.dart';
import 'widget/animation_controller.dart';
import 'widget/animated_balloon.dart';
import 'widget/animated_background.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Widget Tree',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: Colors.lightBlue[50],
          body: Stack(children: [
            Positioned(
                top: -60,
                left: 300,
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width + 300),
                  height: (MediaQuery.of(context).size.width - 300) / 2,
                  child: Image.asset(
                    '../assets/images/clouds1.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Positioned(child: AnimatedBackground(imagePath: "../assets/images/cloudcompute.png")),
            Positioned(top: 200, right: 100, child: AnimatedBalloonWidgetRotate(),),
            const Positioned(top: 100, right: 400, child: AnimatedInteraction()),
            Positioned(top: 100, left: 100, child: AnimatedBalloonWidgetPulse()),
            Positioned(top: 100, left: 300, child: AnimatedBalloonWidget()),
            Center(child: Positioned(child: BalloonAnimation())),
          ]),
        ));
  }
}
