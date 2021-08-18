import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget{
  NotifyPage(this.userId, this.token);

  final int userId;
  final token;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyPage(userId,token);
  }
}
class _NotifyPage extends State{
  _NotifyPage(this.userId, this.token);
  final int userId;
  final token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Center(child: Text("Notify Page")),);
  }
}