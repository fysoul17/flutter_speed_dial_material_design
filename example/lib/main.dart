import 'package:flutter/material.dart';
import 'package:flutter_speed_dial_material_design/flutter_speed_dial_material_design.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  SpeedDialController _controller = SpeedDialController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('FAB with Speed dial Sample'),
            RaisedButton(
              child: Text("Unfold FAB"),
              onPressed: () {
                _controller.unfold();
              },
            )
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    final TextStyle customStyle = TextStyle(inherit: false, color: Colors.black);
    final icons = [ 
      SpeedDialAction(
        //backgroundColor: Colors.green, 
        //foregroundColor: Colors.yellow, 
        child: Icon(Icons.mode_edit), 
        label: Text('Edit any item', style: customStyle)),
      SpeedDialAction(child: Icon(Icons.date_range), label: Text('Choose the date', style: customStyle)),
      SpeedDialAction(child: Icon(Icons.list), label: Text('Menu', style: customStyle)),
    ];

    return SpeedDialFloatingActionButton(
      actions: icons,
      childOnFold: Icon(Icons.event_note, key: UniqueKey()),
      screenColor: Colors.black.withOpacity(0.3),
      //childOnUnfold: Icon(Icons.add),
      useRotateAnimation: false,
      onAction: _onSpeedDialAction,
      controller: _controller,
      isDismissible: true,
      //backgroundColor: Colors.yellow,
      //foregroundColor: Colors.blue,
    );
  }

  _onSpeedDialAction(int selectedActionIndex) {
    print('$selectedActionIndex Selected');
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => {},
            ),
            IconButton(
              icon: Icon(Icons.today),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
