import 'package:app_rmuti_shop/screens/home/joinGroup_page/joinGroup_page.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage(this.token, this.userId, this._listItem);

  final token;
  final userId;
  final _listItem;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPage(token, userId, _listItem);
  }
}

class _SearchPage extends State {
  _SearchPage(this.token, this.userId, this._listItem);

  final token;
  final userId;
  final List _listItem;
  List _listItemSearch = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _listItemSearch = _listItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
                width: double.infinity,
                decoration: boxDecorationGrey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "กรอกสินค้าที่ต้องการค้นหา",
                        border: InputBorder.none),
                    onChanged: (textSearch) {
                      setState(() {
                        _listItemSearch = _listItem
                            .where((element) =>
                            element.nameItem
                                .toLowerCase()
                                .contains(textSearch.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                )),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _listItemSearch.length,
                itemBuilder: (BuildContext context, index) {
                  if (_listItemSearch.length == 0) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  JoinGroupPage(
                                      _listItemSearch[index], token, userId)));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: boxDecorationGrey,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_listItemSearch[index].nameItem}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                    "จากราคา ${_listItemSearch[index]
                                        .price} บาท"),
                                Icon(Icons.arrow_forward_outlined,color: Colors.teal,),
                                Text(
                                    "ลดเหลือ ${_listItemSearch[index]
                                        .priceSell} บาท"),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "ระยะเวลาลงทะเบียน : ${_listItemSearch[index]
                                        .dealBegin} - ${_listItemSearch[index]
                                        .dealFinal}"),
                                Text(
                                    "ระยะเวลาใช้สิทธิ์ : ${_listItemSearch[index]
                                        .dateBegin} - ${_listItemSearch[index]
                                        .dateFinal}"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
