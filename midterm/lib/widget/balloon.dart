import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimatedBalloonWidget extends StatefulWidget {
  @override
  _AnimatedBalloonWidgetState createState() => _AnimatedBalloonWidgetState();
}

class _AnimatedBalloonWidgetState extends State<AnimatedBalloonWidget> with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;

  late AnimationController _controllerFloatUp;
  late AnimationController _controllerSmallInflate;
  late AnimationController _controllerGrowSize;
  late AnimationController _controllerRotate;
  late AnimationController _controllerPulse;
  late AnimationController _controllerBirds;
  late AnimationController _controllerFlyUp;

  late Animation<double> _animationFloatUp;
  late Animation<double> _animationSmallInflate;
  late Animation<double> _animationGrowSize;
  late Animation<double> _animationRotate;
  late Animation<double> _animationPulse;
  late Animation<double> _animationBirds;
  late Animation<double> _animationFlyUp;

  double _balloonTop = 200.0; // Start higher up
  double _balloonLeft = 400.0;

  double _initialTop = 100.0;
  double _initialLeft = 500.0;

  bool _isDragging = false;
  bool _isInflating = false;
  bool _isFullyInflated = false;
  bool _isBursting = false; // Flag to indicate bursting

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _controllerFloatUp = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    _controllerSmallInflate = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerGrowSize = AnimationController(duration: const Duration(seconds: 4), vsync: this);
    _controllerRotate = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    _controllerPulse = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _controllerBirds = AnimationController(duration: const Duration(seconds: 15), vsync: this);
    _controllerFlyUp = AnimationController(duration: const Duration(seconds: 3), vsync: this);

    //(3): Rotation Animation
    _animationRotate = Tween(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _controllerRotate, curve: Curves.easeInOut),
    );

    //(4) Pulse Animation
    _animationPulse = Tween(begin: 2.0, end: 2.01).animate(
      CurvedAnimation(parent: _controllerPulse, curve: Curves.easeInOutSine),
    );

    _animationBirds = Tween(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerBirds, curve: Curves.linear),
    );

    _controllerFloatUp.forward();
    _controllerRotate.repeat(reverse: true);
    _controllerPulse.repeat();
    _controllerBirds.repeat(reverse: true);

    _controllerSmallInflate.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllerGrowSize.forward();
      }
    });

    _controllerGrowSize.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isDragging) {
        _isFullyInflated = true;
        flyUpAndBurst();
      }
    });

    _controllerFlyUp.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await _audioPlayer.play(AssetSource('sounds/balloon_burst.mp3'));
        resetBalloon();
      }
    });
  }

  void resetBalloon() {
    setState(() {
      _isInflating = false;
      _isFullyInflated = false;
      _balloonTop = 200.0; // Start higher up
      _balloonLeft = 400.0;
      _isBursting = false; // Reset bursting state
    });

    _controllerSmallInflate.reset();
    _controllerGrowSize.reset();
    _controllerFlyUp.reset();
  }

  @override
  void dispose() {
    _controllerFloatUp.dispose();
    _controllerSmallInflate.dispose();
    _controllerGrowSize.dispose();
    _controllerRotate.dispose();
    _controllerPulse.dispose();
    _controllerBirds.dispose();
    _controllerFlyUp.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void startInflation() async {
    if (!_isInflating) {
      _isInflating = true;
      await _audioPlayer.play(AssetSource('sounds/balloon_inflate.mp3'));
      _controllerSmallInflate.forward(from: 0);
    }
  }

  void flyUpAndBurst() async {
    setState(() {
      _isBursting = false;
    });

    _controllerFlyUp.forward(from: 0);
    // Wait for the animation to complete
    await Future.delayed(Duration(seconds: 2));
    // Show burst image and play sound
    setState(() {
      _isBursting = true; // Set the bursting state
    });
    await _audioPlayer.play(AssetSource('sounds/balloon_burst.mp3'));

    Future.delayed(Duration(seconds: 60), resetBalloon);
  }

  @override
  Widget build(BuildContext context) {
    double _balloonHeight = MediaQuery.of(context).size.height / 3;
    double _balloonWidth = MediaQuery.of(context).size.height / 3;
    double _balloonBottomLocation = MediaQuery.of(context).size.height - _balloonHeight;

    double maxFloatUp = _balloonBottomLocation * 0.5;

    _animationFloatUp = Tween(begin: _balloonBottomLocation, end: maxFloatUp).animate(
      CurvedAnimation(parent: _controllerFloatUp, curve: Curves.easeInOutCubic),
    );

    _animationSmallInflate = Tween(begin: 100.0, end: 200.0).animate(
      CurvedAnimation(parent: _controllerSmallInflate, curve: Curves.easeInOutCubic),
    );

    _animationGrowSize = Tween(begin: 300.0, end: _balloonWidth).animate(
      CurvedAnimation(
        parent: _controllerGrowSize,
        curve: Curves.easeInOutCubic,
      ),
    );

    _animationFlyUp = Tween(begin: _balloonBottomLocation, end: 0.0).animate(
      CurvedAnimation(parent: _controllerFlyUp, curve: Curves.easeInOut),
    );

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: AnimatedBuilder(
        animation: Listenable.merge([_animationFloatUp, _animationRotate, _animationPulse, _animationBirds, _animationFlyUp]),
        builder: (context, child) {
          // Adjusted shadow size and offset
          double shadowSize = (_isFullyInflated ? _animationGrowSize.value : _animationSmallInflate.value) * 0.3;
          double shadowOffset = (_isFullyInflated ? _animationGrowSize.value : _animationSmallInflate.value) * 0.15;

          //(5): Background Animation
          return Stack(
            children: [
              Positioned(
                top: -60,
                left: (MediaQuery.of(context).size.width - 700) / 2,
                child: SizedBox(
                  width: 500,
                  height: 360,
                  child: Image.asset(
                    'assets/images/cloud.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: (MediaQuery.of(context).size.width + 500) / 2,
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: Image.asset(
                    'assets/images/cloud.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: _animationBirds.value * MediaQuery.of(context).size.width,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/images/cloud.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 250,
                left: _animationBirds.value * MediaQuery.of(context).size.width + 200,
                child: SizedBox(
                  width: 100,
                  height: 200,
                  child: Image.asset(
                    'assets/images/red-balloon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: _isDragging ? _balloonTop : _animationFlyUp.value,
                left: _balloonLeft,
                child: GestureDetector(
                  onPanStart: (details) {
                    _isDragging = true;
                    _initialTop = _balloonTop - details.localPosition.dy;
                    _initialLeft = _balloonLeft - details.localPosition.dx;
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _balloonTop = _initialTop + details.localPosition.dy;
                      _balloonLeft = _initialLeft + details.localPosition.dx;

                      if (_balloonTop < 0) _balloonTop = 0;
                      if (_balloonLeft < 0) _balloonLeft = 0;
                      if (_balloonTop > MediaQuery.of(context).size.height - _balloonHeight)
                        _balloonTop = MediaQuery.of(context).size.height - _balloonHeight;
                      if (_balloonLeft > MediaQuery.of(context).size.width - _balloonWidth)
                        _balloonLeft = MediaQuery.of(context).size.width - _balloonWidth;
                    });
                  },
                  onPanEnd: (_) {
                    _isDragging = false;
                    if (_isInflating && _controllerGrowSize.isCompleted) {
                      flyUpAndBurst();
                    }
                  },
                  onTap: startInflation,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: _isFullyInflated ? _animationGrowSize.value : _animationSmallInflate.value,
                          height: (_isFullyInflated ? _animationGrowSize.value : _animationSmallInflate.value) / 2,
                          margin: EdgeInsets.only(bottom: shadowSize),
                          //(2): Shadow
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: shadowSize,
                                offset: Offset(shadowOffset, shadowOffset),
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _isBursting
                          ? Image.asset(
                        'assets/images/burst.png',
                        height: _animationGrowSize.value,
                        width: _animationGrowSize.value,
                      )
                          : Transform.rotate(
                        angle: _animationRotate.value,
                        child: Transform.scale(
                          scale: _animationPulse.value,
                          child: Image.asset(
                            'assets/images/BeginningGoogleFlutter-Balloon.png',
                            height: _isFullyInflated
                                ? _animationGrowSize.value
                                : _animationSmallInflate.value,
                            width: _isFullyInflated
                                ? _animationGrowSize.value
                                : _animationSmallInflate.value,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
