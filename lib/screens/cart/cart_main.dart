import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab.dart';
import 'package:app_rmuti_shop/screens/cart/string_status_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartMain extends StatefulWidget {
  CartMain(this.userId, this.token);

  final userId;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartMain(userId, token);
  }
}

class _CartMain extends State {
  _CartMain(this.userId, this.token);

  final userId;
  final token;
  final urlGetCartByUserId = "${Config.API_URL}/Cart/find/user";
  List<_Cart> listCartTab1 = [];
  List<_Cart> listCartTab2 = [];
  List<_Cart> listCartTab3 = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _listCartByUserId(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print('snapshot data : ${snapshot.data}');
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.length == 0) {
          return Center(child: Text('ไม่มีสินค้าที่เข้าร่วม'));
        } else {
          return DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: SafeArea(
                child: Scaffold(
                  appBar: TabBar(
                    labelColor: Colors.teal,
                    tabs: [
                      Tab(text: statusCartJoin),
                      Tab(text: statusCartWaitPayment),
                      Tab(text: statusCartSuccessfulPayment),
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      CartTab(listCartTab1, token, userId, statusCartJoin),
                      CartTab(
                          listCartTab2, token, userId, statusCartWaitPayment),
                      CartTab(listCartTab3, token, userId,
                          statusCartSuccessfulPayment),
                    ],
                  ),
                ),
              ));
        }
      },
    );
  }

  Future<List<_Cart>> _listCartByUserId() async {
    List<_Cart> _listCart = [];
    Map params = Map();
    params['user'] = userId.toString();
    await http.post(Uri.parse(urlGetCartByUserId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print("res body : ${res.body}");
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
    listCartTab1 = _listCart
        .where((element) =>
            element.status.toLowerCase().contains(statusCartJoin.toLowerCase()))
        .toList();
    listCartTab2 = _listCart
        .where((element) => element.status
            .toLowerCase()
            .contains(statusCartWaitPayment.toLowerCase()))
        .toList();
    listCartTab3 = _listCart
        .where((element) => element.status
            .toLowerCase()
            .contains(statusCartSuccessfulPayment.toLowerCase()))
        .toList();
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
