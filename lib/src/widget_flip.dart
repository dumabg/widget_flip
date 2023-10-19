import 'dart:math';

import 'package:flutter/material.dart';

enum FlipWidgetDirection { horizontal, vertical }

class FlipWidget extends StatefulWidget {
  /// Front widget
  final Widget front;

  /// Back widget
  final Widget back;

  // The flip direction: horizontal or vertical.
  final FlipWidgetDirection direction;

  // The animation duration when flip.
  final Duration duration;

  // Starts the animation automatically.
  final bool autoStart;

  // Loop animation.
  final bool loop;

  // Callback for animation status
  final void Function(AnimationStatus)? onAnimationStatus;

  // FlipWidget controller
  final FlipWidgetController controller;

  /// FlipWidget
  FlipWidget(
      {super.key,
      required this.front,
      required this.back,
      this.direction = FlipWidgetDirection.horizontal,
      this.duration = const Duration(milliseconds: 800),
      this.autoStart = false,
      this.loop = false,
      this.onAnimationStatus,
      FlipWidgetController? controller})
      : controller = controller ?? FlipWidgetController();

  @override
  State<FlipWidget> createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with TickerProviderStateMixin {
  // Animation controller
  late AnimationController animationController;
  // Toggle front-back image
  bool isFront = true;
  double anglePlus = 0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: widget.duration, vsync: this); //cSpell: disable-line
    animationController.addStatusListener((AnimationStatus status) {
      widget.onAnimationStatus?.call(status);
      if ((status == AnimationStatus.completed) && (widget.loop)) {
        flip();
      }
    });
    if (widget.autoStart) {
      flip();
    }
    widget.controller._state = this;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> flip() async {
    // To prevent stopping animation by pressing multiple times
    if (animationController.isAnimating) return;
    // Change the showing side of the card
    isFront = !isFront;

    // To set the flipping animation on one direction
    await animationController.forward(from: 0).then((value) => anglePlus = pi);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          // Flipping angle
          double angle = animationController.value * -pi;
          if (isFront) angle += anglePlus;
          final transform = Matrix4.identity()..setEntry(3, 2, 0.001);
          if (widget.direction == FlipWidgetDirection.horizontal) {
            transform.rotateY(angle);
          } else {
            transform.rotateX(angle);
          }
          //Transform the child between front and back images
          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: isFrontImage(angle.abs())
                ? widget.front
                : widget.direction == FlipWidgetDirection.horizontal
                    ? Transform(
                        transform: Matrix4.identity()..rotateY(pi),
                        alignment: Alignment.center,
                        child: widget.back)
                    : Transform(
                        transform: Matrix4.identity()..rotateX(pi),
                        alignment: Alignment.center,
                        child: widget.back),
          );
        });
  }

  bool isFrontImage(double abs) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;
    return (abs <= degrees90) || (abs >= degrees270);
  }
}

class FlipWidgetController {
  _FlipWidgetState? _state;

  Future<void> flip() async {
    _state?.flip();
  }
}
