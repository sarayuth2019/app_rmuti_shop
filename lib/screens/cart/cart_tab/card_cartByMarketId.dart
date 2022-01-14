import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/method/group_cartByMarketId.dart';
import 'package:app_rmuti_shop/method/list_cartData_byUserId.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/card_cartByItemId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListGroupCart extends StatefulWidget {
  ListGroupCart(
      this.token, this.listGroupCartDataByMarket, this.userId, this.callBack);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;
  final Function callBack;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListGroupCartState(
        token, listGroupCartDataByMarket, userId, callBack);
  }
}

class _ListGroupCartState extends State {
  _ListGroupCartState(
      this.token, this.listGroupCartDataByMarket, this.userId, this.callBack);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;
  final Function callBack;

  int sumPriceTotal = 0;
  var listItemId = [];
  var _listItemId = [];
  var listCartByItemId;

  @override
  Widget build(BuildContext context) {
    ///////////////// ListItemId ////////////////////////
    listGroupCartDataByMarket.forEach((element) {
      _listItemId.add(element.itemId);
    });
    listItemId = _listItemId.toSet().toList();
    print('listItem length : ${listItemId.length}');
    if (listGroupCartDataByMarket.length == 0) {
      return Container();
    } else {
      return Container(
        decoration: boxDecorationGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Market Id : ${listGroupCartDataByMarket[0].marketId}'),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listItemId.length,
                  itemBuilder: (BuildContext context, int indexItem) {
                    ///////////////// ListCartByItemId ////////////////////////
                    listCartByItemId = listGroupCartByItemId(
                        listGroupCartDataByMarket, listItemId[indexItem]);
                    print('list CartByItemId : ${listCartByItemId.length}');
                    return CardCartByItemId(token, listCartByItemId, userId,
                        callBack, showAlertDeleteCart);
                  }),
              SizedBox(
                height: 8,
              ),
              /*
              Container(
                height: 25,
                child: Row(
                  children: [
                    Text('ราคาสินค้าทั้งหมด : '),
                    Text(
                        "${listGroupCartDataByMarket.map((e) => e.priceSell * e.number).reduce((value, element) => value + element)} บาท"),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.teal),
                        onPressed: () {
                          showListCartBuy(context, token, userId,
                              listGroupCartDataByMarket);
                        },
                        child: Text('ชำระเงินทั้งหมด')),
                  ],
                ),
              )
              */
            ],
          ),
        ),
      );
    }
  }

  void showAlertDeleteCart(BuildContext context, snapShotId, cartDelete) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'ต้องการลบรายการนี้ ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            deleteCart(token, snapShotId, cartDelete);
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

  void deleteCart(token, snapShotId, cartDelete) async {
    print('cartId delete : ${snapShotId.toString()}.....');
    final urlDeleteByCartId = "${Config.API_URL}/Cart/delete";
    var statusRes;
    Map params = Map();
    params['id'] = snapShotId.toString();
    await http.post(Uri.parse(urlDeleteByCartId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resData = jsonDecode(res.body);
      statusRes = resData['status'];
      if (statusRes == 0) {
        setState(() {
          print(res.body);
          listGroupCartDataByMarket.remove(cartDelete);
          //listCartByItemId.remove(cartDelete);
          callBack(listGroupCartDataByMarket.length);
        });
      }
    });
  }
}
