import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget{
  NotifyPage(this.accountID);

  final int accountID;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyPage(accountID);
  }
}
class _NotifyPage extends State{
  _NotifyPage(this.accountID);
  final int accountID;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Center(child: Text("Notify Page")),);
  }
}