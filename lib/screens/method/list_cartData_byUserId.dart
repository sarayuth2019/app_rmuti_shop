import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:app_rmuti_shop/config/config.dart';

Future<List<Cart>?> listCartByUserId(token,userId,statusTab) async {
  List<Cart> listCartTab = [];
  final urlGetCartByUserId = "${Config.API_URL}/Cart/find/user";
  List<Cart> _listCart = [];
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
      Cart _cart = Cart(
          i['cartId'],
          i['status'],
          i['nameCart'],
          i['number'],
          i['price'],
          i['priceSell'],
          i['detail'],
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
  listCartTab = _listCart
      .where((element) =>
      element.status.toLowerCase().contains(statusTab.toLowerCase()))
      .toList();
  return listCartTab;
}

class Cart {
  final int cartId;
  final String status;
  final String nameItem;
  final int number;
  final int price;
  final int priceSell;
  final detail;
  final int marketId;
  final int userId;
  final int itemId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String createDate;

  Cart(
      this.cartId,
      this.status,
      this.nameItem,
      this.number,
      this.price,
      this.priceSell,
      this.detail,
      this.marketId,
      this.userId,
      this.itemId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.createDate);
}