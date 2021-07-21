///Courtesy : Flippable Box package in pub.dev

import 'dart:math';

import 'package:flutter/material.dart';

class FlippableBox extends StatelessWidget {
  final double? clipRadius;
  final double duration;
  final Curve curve;
  final bool flipVt;
  final BoxDecoration? bg;
  final Container? front;
  final Container? back;

  final bool isFlipped;

  const FlippableBox({Key? key, this.isFlipped = false, this.front, this.back, this.bg, this.clipRadius, this.duration = 1, this.curve = Curves.easeOut, this.flipVt = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: (duration * 1000).round()),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0.0, end: isFlipped ? 180.0 : 0.0),
      builder: (BuildContext context, double value, Widget? child) {
        var content = value >= 90 ? back : front;
        return Rotation3d(
          rotationY: !flipVt? value : 0,
          rotationX: flipVt? value : 0,
          child: Rotation3d(
            rotationY: !flipVt? (value > 90 ? 180 : 0) : 0,
            rotationX: flipVt? (value > 90 ? 180 : 0) : 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(clipRadius ?? 0),
              child: AnimatedBackground(
                decoration: bg,
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Rotation3d extends StatelessWidget {
  //Degrees to rads constant
  static const double degrees2Radians = pi / 180;

  final Widget child;
  final double rotationX;
  final double rotationY;
  final double rotationZ;

  const Rotation3d({Key? key, required this.child, this.rotationY = 0, this.rotationZ = 0, this.rotationX = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(rotationX * degrees2Radians)
          ..rotateY(rotationY * degrees2Radians)
          ..rotateZ(rotationZ * degrees2Radians),
        child: child);
  }
}

class AnimatedBackground extends StatelessWidget {
  final Container? child;
  final BoxDecoration? decoration;

  const AnimatedBackground({Key? key, this.child, this.decoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: child?.constraints?.maxWidth,
        height: child?.constraints?.maxHeight,
        decoration: decoration,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeOut,
        child: child);
  }
}

enum FlipDirection {
  VERTICAL,
  HORIZONTAL,
}

class AnimationCard extends StatelessWidget {
  AnimationCard({this.child, required this.animation, this.direction});

  final Widget? child;
  final Animation<double>? animation;
  final FlipDirection? direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        if (direction == FlipDirection.VERTICAL) {
          transform.rotateX(animation!.value);
        } else {
          transform.rotateY(animation!.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

typedef void BoolCallback(bool isFront);

class FlipCard extends StatefulWidget {
  final Widget? front;
  final Widget? back;

  /// The amount of milliseconds a turn animation will take.
  final int speed;
  final FlipDirection direction;
  final VoidCallback? onFlip;
  final BoolCallback? onFlipDone;

  /// When enabled, the card will flip automatically when touched. This behavior
  /// can be disabled if this is not desired. To manually flip a card from your
  /// code, you could do this:
  ///```dart
  /// GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return FlipCard(
  ///     key: cardKey,
  ///     flipOnTouch: false,
  ///     front: Container(
  ///       child: RaisedButton(
  ///         onPressed: () => cardKey.currentState.toggleCard(),
  ///         child: Text('Toggle'),
  ///       ),
  ///     ),
  ///     back: Container(
  ///       child: Text('Back'),
  ///     ),
  ///   );
  /// }
  ///```
  final bool flipOnTouch;

  const FlipCard(
      {Key? key,
      required this.front,
      required this.back,
      this.speed = 500,
      this.onFlip,
      this.onFlipDone,
      this.direction = FlipDirection.HORIZONTAL,
      this.flipOnTouch = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FlipCardState();
  }
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? _frontRotation;
  Animation<double>? _backRotation;

  bool isFront = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.speed), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);
    controller?.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (widget.onFlipDone != null) widget.onFlipDone!(isFront);
      }
    });
  }

  void toggleCard() {
    if (widget.onFlip != null) {
      widget.onFlip!();
    }
    if (isFront) {
      controller?.forward();
    } else {
      controller?.reverse();
    }

    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        _buildContent(front: true),
        _buildContent(front: false),
      ],
    );

    // if we need to flip the card on taps, wrap the content
    if (widget.flipOnTouch) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: toggleCard,
        child: child,
      );
    }
    return child;
  }

  Widget _buildContent({required bool front}) {
    // pointer events that would reach the backside of the card should be
    // ignored
    return IgnorePointer(
      // absorb the front card when the background is active (!isFront),
      // absorb the background when the front is active
      ignoring: front ? !isFront : isFront,
      child: AnimationCard(
        animation: front ? _frontRotation : _backRotation,
        child: front ? widget.front : widget.back,
        direction: widget.direction,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}