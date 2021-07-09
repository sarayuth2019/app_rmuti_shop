import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinGroupPage extends StatefulWidget {
  JoinGroupPage(this.itemData);

  final itemData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _JoinGroupPage(itemData);
  }
}

class _JoinGroupPage extends State {
  _JoinGroupPage(this.itemData);

  final itemData;

  @override
  Widget build(BuildContext context) {
    print(itemData);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: Text("Join Page")),
    );
  }
}
