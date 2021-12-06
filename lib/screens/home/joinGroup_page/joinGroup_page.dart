
import 'package:app_rmuti_shop/screens/home/joinGroup_page/showListImageItem.dart';
import 'package:app_rmuti_shop/screens/home/joinGroup_page/showListItemData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class JoinGroupPage extends StatefulWidget {
  JoinGroupPage(this.itemData, this.token, this.userId);

  final itemData;
  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _JoinGroupPage(itemData, token, userId);
  }
}

class _JoinGroupPage extends State {
  _JoinGroupPage(this.itemData, this.token, this.userId);

  final itemData;
  final token;
  final userId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowListImageItem(token, itemData.itemId),
              ShowListItemData(itemData, token, userId)
            ],
          ),
        ),
      ),
    );
  }

}
