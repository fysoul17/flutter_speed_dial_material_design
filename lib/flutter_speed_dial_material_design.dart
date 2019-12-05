import 'dart:math';

import 'package:flutter/material.dart';

import 'layout.dart';

// Special Thanks to Andrea Bizzotto and Matt Carroll!
//
// Goal: https://material.io/components/buttons-floating-action-button/#types-of-transitions
// Influenced by: https://medium.com/coding-with-flutter/flutter-adding-animated-overlays-to-your-app-e0bb049eff39
//                https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
// Codes from: https://github.com/bizz84/bottom_bar_fab_flutter
//             https://github.com/matthew-carroll/fluttery/blob/master/lib/src/layout_overlays.dart

class SpeedDialFloatingActionButton extends StatelessWidget {
  /// Creates Floating action button with speed dial attached.
  ///
  /// [childOnFold] is default widget attched to Floating action button.
  /// [useRotateAnimation] makes more fancy when using with Icons.add or with unfold child.
  ///
  /// The [childOnFold] must not be null. Additionally,
  /// if [childOnUnfold] is specified, two widgets([childOnFold] and [childOnUnfold]) will be switched with animation when speed dial is opened/closed.

  /// NOTE: In order to apply fade transition between [childOnFold] and [childOnUnfold], make sure one of those has Key field. (eg. ValueKey<int>(value) or UniqueKey()).
  ///       As we using AnimatedSwitcher for transition animation, no key with same type of child will perform no animation. It is AnimatedSwitcher's behaviour.
  SpeedDialFloatingActionButton({
    @required this.actions,
    this.onAction,
    @required this.childOnFold,
    this.childOnUnfold,
    this.useRotateAnimation = false,
    this.animationDuration = 250,
  });

  final List<SpeedDialAction> actions;
  final ValueChanged<int> onAction;
  final Widget childOnFold;
  final Widget childOnUnfold;
  final int animationDuration;
  final bool useRotateAnimation;

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - actions.length * 35.0),
          child: SpeedDial(
            actions: actions,
            onAction: onAction,
            childOnFold: childOnFold,
            childOnUnfold: childOnUnfold,
            animationDuration: animationDuration,
            useRotateAnimation: useRotateAnimation,
          ),
        );
      },
      child: FloatingActionButton(onPressed: () {}),
    );
  }
}

class SpeedDialAction extends StatelessWidget {
  SpeedDialAction({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class SpeedDial extends StatefulWidget {
  SpeedDial({
    @required this.actions,
    this.onAction,
    @required this.childOnFold,
    this.childOnUnfold,
    this.animationDuration,
    this.useRotateAnimation,
  });

  final List<SpeedDialAction> actions;
  final ValueChanged<int> onAction;
  final Widget childOnFold;
  final Widget childOnUnfold;
  final int animationDuration;
  final bool useRotateAnimation;

  @override
  State createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildActions();
  }

  Widget _buildActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.actions.length, (int index) {
        return _buildChild(index);
      }).reversed.toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, (index + 1) / widget.actions.length, curve: Curves.linear),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          mini: true,
          child: widget.actions[index],
          onPressed: () => _onAction(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: toggle,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (widget.childOnUnfold == null) {
              return _buildRotation(widget.childOnFold);
            } else {
              return widget.useRotateAnimation ? _buildRotation(_buildAnimatedSwitcher()) : _buildAnimatedSwitcher();
            }
          }),
      elevation: 2.0,
    );
  }

  void toggle() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget _buildRotation(Widget child) {
    return Transform.rotate(
      angle: _controller.value * pi / 4,
      child: child,
    );
  }

  Widget _buildAnimatedSwitcher() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.animationDuration),
      child: _controller.value < 0.5 ? widget.childOnFold : widget.childOnUnfold,
    );
  }

  void _onAction(int index) {
    _controller.reverse();
    widget.onAction(index);
  }
}
