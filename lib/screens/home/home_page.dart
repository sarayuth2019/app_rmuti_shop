import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/home/search_page.dart';
import 'package:app_rmuti_shop/screens/home/joinGroup_page/joinGroup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage(this.userId, this.token, this.callBackMainPage);

  final userId;
  final token;
  final callBackMainPage;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage(userId, token, callBackMainPage);
  }
}

class _HomePage extends State {
  _HomePage(this.userId, this.token, this.callBackMainPage);

  final userId;
  final token;
  final callBackMainPage;

  List<Items> _listItem = [];
  //final urlListAllItems = "${Config.API_URL}/Item/list";
  final urlListAllItems = "${Config.API_URL}/Item/ListProduct";
  final urlGetImageByItemId = "${Config.API_URL}/images/";
  final snackBarOnFall = SnackBar(content: Text("ผิดพลาด !"));
  DateTime _dayNow = DateTime.now();

  var _fontSize = 12.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItemAll();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          backgroundColor: Colors.teal,
          mini: true,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(
                        token, userId, _listItem, callBackMainPage)));
          },
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder(
            future: listItemAll(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  "No Products",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ));
              } else {
                print('/////////////////// ${_dayNow} /////////////////////');
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, index) {
                      var stringDealFinal =
                          '${snapshot.data[index].dealFinal.split('/')[2]}-${snapshot.data[index].dealFinal.split('/')[1]}-${snapshot.data[index].dealFinal.split('/')[0]}';
                      DateTime _dealFinal = DateTime.parse(stringDealFinal);
                      print(
                          '/////////////////// ${_dealFinal} /////////////////////');
                      print(_dayNow.isAfter(_dealFinal));
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              FutureBuilder(
                                future: getImage(snapshot.data[index].itemId),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshotImage) {
                                  print(snapshotImage.data.runtimeType);
                                  if (snapshotImage.data == null) {
                                    return Container(
                                        color: Colors.grey,
                                        height: 170,
                                        width: double.infinity,
                                        child:
                                            Center(child: Icon(Icons.image)));
                                  } else {
                                    return Container(
                                        height: 170,
                                        width: double.infinity,
                                        child: Image.memory(
                                          base64Decode(snapshotImage.data[0]),
                                          fit: BoxFit.fill,
                                        ));
                                  }
                                },
                              ),
                              Opacity(
                                opacity: 0.70,
                                child: Container(
                                  color: Colors.teal,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${snapshot.data[index].nameItem}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              child: snapshot.data[index]
                                                          .groupItems ==
                                                      1
                                                  ? Text(
                                                      "(สินค้าพร้อมขาย)",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: _fontSize),
                                                    )
                                                  : Text(
                                                      "(สินค้า Pre order)",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: _fontSize),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 8),
                                        child: Text(
                                          "ราคา ${snapshot.data[index].priceSell} จาก ${snapshot.data[index].price} ต้องการขาย ${snapshot.data[index].countRequest} ลงทะเบียนซื้อแล้ว ${snapshot.data[index].count}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _fontSize),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  child: snapshot.data[index]
                                      .count ==
                                      snapshot.data[index]
                                          .countRequest ||
                                      _dayNow.isAfter(_dealFinal
                                          .add(Duration(
                                          days: 1))) ==
                                          true
                                      ? Container()
                                      : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  JoinGroupPage(
                                                      snapshot
                                                          .data[index],
                                                      token,
                                                      userId,
                                                      callBackMainPage)));
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius
                                          .circular(5),
                                      child: Container(
                                          color:
                                          Colors.orange,
                                          height: 22,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                left: 10.0,
                                                right:
                                                10.0),
                                            child: Text(
                                              'เข้าร่วม',
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ));
  }

  Future<void> _onRefresh() async {
    listItemAll();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  Future<List<Items>> listItemAll() async {
    List<Items> listItem = [];
    await http.get(Uri.parse(urlListAllItems), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      //print(res.body);
      print("listItem By Account Success");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _itemData = _jsonRes['data'];
      //print(_itemData);
      for (var i in _itemData) {
        Items _items = Items(
          i['itemId'],
          i['nameItems'],
          i['groupItems'],
          i['price'],
          i['priceSell'],
          i['count'],
          i['size'],
          i['colors'],
          i['countRequest'],
          i['marketId'],
          i['dateBegin'],
          i['dateFinal'],
          i['dealBegin'],
          i['dealFinal'],
          i['createDate'],
        );
        listItem.insert(0, _items);
      }
    });
    print("Products All : ${listItem.length}");
    _listItem = listItem;
    return listItem;
  }

  Future<void> getImage(_itemId) async {
    var _resData;
    await http.get(
        Uri.parse('${urlGetImageByItemId.toString()}${_itemId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      // print(res.body);
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _statusData = jsonData['status'];
      var _dataImage = jsonData['dataImages'];
      //var _dataId = jsonData['dataId'];
      if (_statusData == 1) {
        _resData = _dataImage;
        //print("jsonData : ${_resData.toString()}");
      }
    });
    print("_resData ${_resData.toString()}");
    return _resData;
  }
}

class Items {
  final int itemId;
  final String nameItem;
  final int groupItems;
  final int price;
  final int priceSell;
  final int count;
  final List size;
  final List color;
  final int countRequest;
  final int marketId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String date;

  Items(
      this.itemId,
      this.nameItem,
      this.groupItems,
      this.price,
      this.priceSell,
      this.count,
      this.size,
      this.color,
      this.countRequest,
      this.marketId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);
}
