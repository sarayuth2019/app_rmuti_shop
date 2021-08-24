import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/cart/pay_page.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  CartPage(this.userId, this.token);

  final userId;
  final token;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPage(userId,token);
  }
}

class _CartPage extends State {
  _CartPage(this.userId, this.token);

  final userId;
  final token;
  final urlGetCartByUserId = "${Config.API_URL}/Cart/find/user";
  final urlDeleteByCartId = "${Config.API_URL}/Cart/delete";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: FutureBuilder(
      future: _listCartByUserId(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.length == 0) {
          return Center(
              child: Text(
            'ไม่มีรายการที่ต้องการเข้าร่วม',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
          ));
        } else {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data[index].nameItem}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "จากราคา ${snapshot.data[index].price} บาท"),
                                      Icon(
                                        Icons.arrow_forward_outlined,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                          "ลดเหลือ ${snapshot.data[index].priceSell} บาท"),
                                    ],
                                  ),
                                  Text(
                                    'ควรชำระเงินเพื่อยืนยันการลงทะเบียนภายในวันที่',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${snapshot.data[index].dealBegin}'),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.teal,
                                      ),
                                      Text('${snapshot.data[index].dealFinal}'),
                                    ],
                                  ),
                                  Text(
                                    'ระยะเวลาการใช้สิทธิ์ลดราคา',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${snapshot.data[index].dateBegin}'),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.teal,
                                      ),
                                      Text('${snapshot.data[index].dateFinal}'),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Container(
                                child: snapshot.data[index].status ==
                                        'ชำระเงินแล้ว'
                                    ? Center(
                                      child: Text(
                                          '${snapshot.data[index].status} รอการตรวจสอบ',
                                          style: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold),
                                        ),
                                    )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PayPage(
                                                      token,
                                                      userId,
                                                      snapshot.data[index])));
                                        },
                                        child: Text('ชำระเงิน')),
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            _showAlertDeleteCart(
                                context, snapshot.data[index].cartId);
                          },
                          icon: Icon(
                            Icons.highlight_remove,
                            color: Colors.red,
                          )),
                    ),
                  ],
                );
              });
        }
      },
    ));
  }

  void _showAlertDeleteCart(BuildContext context, snapShotId) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ต้องการลบรายการนี้ ?'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            _deleteCart(snapShotId);
                            setState(() {
                              Navigator.pop(context);
                            });
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.pop(context);
                          })),
                ],
              ),
            ),
          );
        });
  }

  void _deleteCart(snapShotId) async {
    Map params = Map();
    params['id'] = snapShotId.toString();
    await http.post(Uri.parse(urlDeleteByCartId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resData = jsonDecode(res.body);
      var statusRes = resData['status'];
      if (statusRes == 0) {
        setState(() {
          print(res.body);
        });
      }
    });
  }

  Future<List<_Cart>> _listCartByUserId() async {
    List<_Cart> _listCart = [];
    Map params = Map();
    params['user'] = userId.toString();
    await http.post(Uri.parse(urlGetCartByUserId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var _cartData = resData['data'];
      print(_cartData);
      for (var i in _cartData) {
        _Cart _cart = _Cart(
            i['cartId'],
            i['status'],
            i['nameCart'],
            i['number'],
            i['price'],
            i['priceSell'],
            i['marketId'],
            i['userId'],
            i['itemId'],
            i['dateBegin'],
            i['dateFinal'],
            i['dealBegin'],
            i['dealFinal'],
            i['createDate']);
        _listCart.insert(0, _cart);
      }
    });
    return _listCart;
  }
}

class _Cart {
  final int cartId;
  final String status;
  final String nameItem;
  final int number;
  final int price;
  final int priceSell;
  final int marketId;
  final int userId;
  final int itemId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String createDate;

  _Cart(
      this.cartId,
      this.status,
      this.nameItem,
      this.number,
      this.price,
      this.priceSell,
      this.marketId,
      this.userId,
      this.itemId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.createDate);
}
