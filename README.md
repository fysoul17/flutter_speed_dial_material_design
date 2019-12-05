# Flutter Speed dial of Material Design style

Flutter package which applies Material design Speed dial

## Preview
There are several packages that provide fancy speed dial.
However, as most of those do not work properly on docked FAB using notch, I referenced Andrea Bizzoto and Matt Carroll's idea/code specified [here](https://medium.com/coding-with-flutter/flutter-bottomappbar-navigation-with-fab-8b962bb55013) to make it work fine with notch as well.
Truly appreciate to Andrea and Matt for sharing such an awesome idea and codes.

![](screenshots/sample_screen.gif)

## Useage
```dart
Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

Widget _buildFloatingActionButton() {
    final icons = [
      SpeedDialAction(child: Icon(Icons.mode_edit)),
      SpeedDialAction(child: Icon(Icons.date_range)),
      SpeedDialAction(child: Icon(Icons.list)),
    ];

    return SpeedDialFloatingActionButton(
      actions: icons,
      childOnFold: Icon(Icons.event_note),
      childOnUnfold: Icon(Icons.add),
      useRotateAnimation: true,
      onAction: _onSpeedDialAction,
    );
  }
  
_onSpeedDialAction(int selectedActionIndex) {
  print('$selectedActionIndex Selected');
}
```

## TO-DOs
- Ability to display/hide speed dial when it is needed. (ex. hiding on scroll)
- Unfold function to force close the dial
- Providing option for modal background with color parameter
- Text labels on each action widgets

## Contributing
Any pull requests for implementing To-Do functions are always welcome!
