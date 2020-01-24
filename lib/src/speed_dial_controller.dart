import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SpeedDialController extends ChangeNotifier {
  SpeedDialController();

  AnimationController _animationController;

  setAnimator(AnimationController controller) {
    _animationController = controller;
  }

  unfold() {
    if (_animationController.isDismissed == false) {
      _animationController.reverse();
    }
  }
}
