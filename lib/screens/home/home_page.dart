import 'dart:convert';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/home/joinGroup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage(accountID);
  }
}

class _HomePage extends State {
  _HomePage(this.accountID);

  final accountID;

  final urlListAllItems = "${Config.API_URL}/Item/list";
  final snackBarOnFall = SnackBar(content: Text("ผิดพลาด !"));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listItemByUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder(
        future: listItemByUser(),
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
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Container(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                              height: 170,
                              width: double.infinity,
                              child: Image.memory(
                                base64Decode(snapshot.data[index].image),
                                fit: BoxFit.fill,
                              )),
                          Opacity(
                            opacity: 0.70,
                            child: Container(
                              color: Colors.teal,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${snapshot.data[index].name}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${snapshot.data[index].deal_begin} - ${snapshot.data[index].deal_final}",
                                          style: TextStyle(color: Colors.white),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ราคา ${snapshot.data[index].price_sell} จาก ${snapshot.data[index].price} ต้องการลงชื่อ ${snapshot.data[index].count_request} มีคนลงแล้ว ${snapshot.data[index].count}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Container(
                                          child: snapshot.data[index].count ==
                                                  snapshot
                                                      .data[index].count_request
                                              ? Container()
                                              : Container(
                                                  height: 20,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  JoinGroupPage(
                                                                      snapshot.data[
                                                                          index])));
                                                    },
                                                    child: Text(
                                                      'เข้าร่วม',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.orange),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
    listItemByUser();
    setState(() {});
    await Future.delayed(Duration(seconds: 3));
  }

  Future<List<_Items>> listItemByUser() async {
    Map params = Map();
    List<_Items> listItem = [];
    params['user'] = accountID.toString();
    await http.get(Uri.parse(urlListAllItems)).then((res) {
      print("listItem By Account Success");
      print(res.body);
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _itemData = _jsonRes['data'];
      print(_itemData);
      for (var i in _itemData) {
        _Items _items = _Items(
          i['id'],
          i['name'],
          i['group'],
          i['price'],
          i['price_sell'],
          i['count'],
          i['count_request'],
          i['user'],
          i['date_begin'],
          i['date_final'],
          i['deal_begin'],
          i['deal_final'],
          i['date'],
          i['image'],
        );
        listItem.insert(0, _items);
      }
    });
    print("Products All : ${listItem.length}");
    return listItem;
  }
}

class _Items {
  final int id;
  final String name;
  final int group;
  final int price;
  final int price_sell;
  final int count;
  final int count_request;
  final int user;
  final String date_begin;
  final String date_final;
  final String deal_begin;
  final String deal_final;
  final String date;
  final String image;

  _Items(
      this.id,
      this.name,
      this.group,
      this.price,
      this.price_sell,
      this.count,
      this.count_request,
      this.user,
      this.date_begin,
      this.date_final,
      this.deal_begin,
      this.deal_final,
      this.date,
      this.image);
}
