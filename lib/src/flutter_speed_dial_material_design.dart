import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial_material_design/src/layout.dart';
import 'package:flutter_speed_dial_material_design/src/speed_dial_controller.dart';

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
  ///
  /// NOTE: In order to apply fade transition between [childOnFold] and [childOnUnfold], make sure one of those has Key field. (eg. ValueKey<int>(value) or UniqueKey()).
  ///       As we using AnimatedSwitcher for transition animation, no key with same type of child will perform no animation. It is AnimatedSwitcher's behaviour.
  SpeedDialFloatingActionButton(
      {@required this.actions,
      this.onAction,
      @required this.childOnFold,
      this.childOnUnfold,
      this.useRotateAnimation = false,
      this.backgroundColor,
      this.foregroundColor,
      this.screenColor,
      this.animationDuration = 250,
      this.controller,
      this.isDismissible = false,
      this.labelPosition});

  final List<SpeedDialAction> actions;
  final ValueChanged<int> onAction;
  final Widget childOnFold;
  final Widget childOnUnfold;
  final int animationDuration;
  final bool useRotateAnimation;
  final SpeedDialController controller;
  final bool isDismissible;

  /// The floating button's background color.
  ///
  /// If this property is null, then the [Theme]'s
  /// [ThemeData.floatingActionButtonTheme.backgroundColor] is used. If that
  /// property is also null, then the [Theme]'s
  /// [ThemeData.colorScheme.secondary] color is used.
  final Color backgroundColor;

  /// The floating button's foreground color.
  ///
  /// If this property is null, then the [Theme]'s
  /// [ThemeData.floatingActionButtonTheme.foregroundColor] is used. If that
  /// property is also null, then the [Theme]'s
  /// [ThemeData.colorScheme.onSecondary] color is used.
  final Color foregroundColor;

  /// The screen background color when the speed dial is unfolded.
  ///
  /// If this property is null, then the background will be transparent.
  /// Tip: use the opacity property to create semi-transparent backgrounds. Example:
  /// ```dart
  /// screenColor: Colors.black.withOpacity(0.2)
  /// ```
  final Color screenColor;

  /// Define if the action's labels will be at the left or at the right of their action button.
  ///
  /// If this property is null, then the label position will obey the following rule:
  /// when the floating button is positioned before the middle of the display (on the x axis), the label will be at the right of the action button,
  /// otherwise the label will be at the left of the action button.
  final LabelPosition labelPosition;

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return SpeedDial(
          controller: controller,
          actions: actions,
          onAction: onAction,
          childOnFold: childOnFold,
          childOnUnfold: childOnUnfold,
          animationDuration: animationDuration,
          useRotateAnimation: useRotateAnimation,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          screenColor: screenColor,
          isDismissible: isDismissible,
          offset: Offset(offset.dx, offset.dy),
          labelPosition: labelPosition,
        );
      },
      child: FloatingActionButton(onPressed: () {}),
    );
  }
}

class SpeedDialAction {
  SpeedDialAction(
      {this.child, this.label, this.backgroundColor, this.foregroundColor});

  final Widget child;
  final Widget label;

  /// The action button's background color.
  ///
  /// If this property is null, then the [Theme]'s
  /// [ThemeData.cardColor] is used.
  final Color backgroundColor;

  /// The action button's foreground color.
  ///
  /// If this property is null, then the [Theme]'s
  /// [ThemeData.accentColor] is used.
  final Color foregroundColor;
}

class SpeedDial extends StatefulWidget {
  SpeedDial({
    @required this.actions,
    this.onAction,
    @required this.childOnFold,
    this.childOnUnfold,
    this.animationDuration,
    this.useRotateAnimation,
    this.backgroundColor,
    this.foregroundColor,
    this.screenColor,
    this.controller,
    this.isDismissible,
    this.offset,
    this.labelPosition,
  });

  final SpeedDialController controller;
  final List<SpeedDialAction> actions;
  final ValueChanged<int> onAction;
  final Widget childOnFold;
  final Widget childOnUnfold;
  final int animationDuration;
  final bool useRotateAnimation;
  final Color screenColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isDismissible;
  final Offset offset;
  final LabelPosition labelPosition;

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

    widget.controller ?? SpeedDialController()
      ..setAnimator(_controller);

    if (widget.isDismissible) {
      _controller.addStatusListener(_onDismissible);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildActions();
  }

  Widget _buildActions() {
    final Size fullsize = MediaQuery.of(context).size; // device size
    final double wButton = 28; // button width
    final double hButtom = 28; // button height

    double start;
    LabelPosition labelPosition = widget.labelPosition;
    if (labelPosition == null) {
      labelPosition = widget.offset.dx > (fullsize.width / 2)
          ? LabelPosition.Left
          : LabelPosition.Right;
    }
    if (labelPosition == LabelPosition.Right) {
      start = widget.offset.dx - wButton;
    } else {
      start = fullsize.width - widget.offset.dx - wButton;
    }

    double bottom;
    if (widget.offset.dy > (fullsize.height / 2)) {
      bottom = fullsize.height - widget.offset.dy - hButtom;
    } else {
      bottom = fullsize.height + (widget.offset.dy.abs() - hButtom);
    }

    return widget.screenColor != null
        ? _buildActionsWithOverlay(bottom, start, labelPosition)
        : _buildActionsWithoutOverlay(bottom, start, labelPosition);
  }

  Widget _buildActionsWithOverlay(
      [double bottom, double start, LabelPosition labelPosition]) {
    var screenColorSequence = TweenSequence<Color>([
      TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
              begin: Color.fromARGB(0, 0, 0, 0), end: widget.screenColor))
    ]);

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isDismissed == false)
            return GestureDetector(
                onTap: toggle,
                child: Container(
                    color: screenColorSequence
                        .evaluate(AlwaysStoppedAnimation(_controller.value)),
                    child: _buildActionsWithoutOverlay(
                        bottom, start, labelPosition)));
          else
            return _buildActionsWithoutOverlay(bottom, start, labelPosition);
        });
  }

  Widget _buildActionsWithoutOverlay(
      [double bottom, double start, LabelPosition labelPosition]) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.directional(
          textDirection: labelPosition == LabelPosition.Left
              ? TextDirection.rtl
              : TextDirection.ltr,
          bottom: bottom,
          start: start,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: labelPosition == LabelPosition.Left
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.actions.length, (int index) {
              return _buildChild(index, labelPosition);
            }).reversed.toList()
              ..add(
                _buildFab(),
              ),
          ),
        ),
      ],
    );
  }

  Widget _buildChild(int index, LabelPosition labelPosition) {
    List<Widget> rowChildren = [
      _buildLabelAction(index),
      _buildChildAction(index),
    ];

    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: labelPosition == LabelPosition.Left
            ? rowChildren
            : rowChildren.reversed.toList());
  }

  Widget _buildLabelAction(int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(_controller),
      child: widget.actions[index].label != null
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              margin: EdgeInsets.only(right: 5.0, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    offset: Offset(0.8, 0.8),
                    blurRadius: 2.4,
                  )
                ],
              ),
              child: widget.actions[index].label,
            )
          : Container(),
    );
  }

  Widget _buildChildAction(int index) {
    Color backgroundColor =
        widget.actions[index].backgroundColor ?? Theme.of(context).cardColor;
    Color foregroundColor =
        widget.actions[index].foregroundColor ?? Theme.of(context).accentColor;

    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, (index + 1) / widget.actions.length,
              curve: Curves.linear),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          mini: true,
          child: widget.actions[index].child,
          onPressed: () => _onAction(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: toggle,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (widget.childOnUnfold == null) {
              return widget.useRotateAnimation
                  ? _buildRotation(widget.childOnFold)
                  : widget.childOnFold;
            } else {
              return widget.useRotateAnimation
                  ? _buildRotation(_buildAnimatedSwitcher())
                  : _buildAnimatedSwitcher();
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
      child:
          _controller.value < 0.5 ? widget.childOnFold : widget.childOnUnfold,
    );
  }

  void _onAction(int index) {
    _controller.reverse();
    widget.onAction(index);
  }

  void _onDismissible(AnimationStatus status) {
    Future<bool> _onReturn() async {
      _controller.reverse();
      return false;
    }

    if (status == AnimationStatus.forward) {
      Navigator.of(context).push(
        PageRouteBuilder(
          fullscreenDialog: true,
          opaque: false,
          barrierDismissible: true,
          transitionDuration: Duration(milliseconds: 100),
          barrierColor: Colors.black54,
          pageBuilder: (BuildContext context, _, __) {
            return WillPopScope(
              child: Container(),
              onWillPop: _onReturn,
            );
          },
        ),
      );
    }
    if (status == AnimationStatus.reverse) {
      Navigator.pop(context);
    }
  }
}

enum LabelPosition { Left, Right }
