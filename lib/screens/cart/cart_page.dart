import 'dart:convert';
import 'dart:io';

import 'package:app_rmuti_shop/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  CartPage(this.token, this.userId);

  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPage(token, userId);
  }
}

class _CartPage extends State {
  _CartPage(this.token, this.userId);

  final token;
  final userId;
  final urlGetCartByUserId = "${Config.API_URL}/Cart/find/user";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: FutureBuilder(
      future: _listCartByUserId(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
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
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data[index].nameItem}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("จากราคา ${snapshot.data[index].price} บาท"),
                                    Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                        "ลดเหลือ ${snapshot.data[index].priceSell} บาท"),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: ElevatedButton(
                                onPressed: () {}, child: Text('ชำระเงิน')),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,right: 0,
                      child: IconButton(
                          onPressed: () {},
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
            i['createDate']);
        _listCart.add(_cart);
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
  final String createDate;

  _Cart(this.cartId, this.status, this.nameItem, this.number, this.price,
      this.priceSell, this.marketId, this.userId, this.itemId, this.createDate);
}
