import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'list_cartData_byUserId.dart';

void editCartStatus(context, token, userId, Cart cartData) async {
  final String urlUpdateStatusCart = "${Config.API_URL}/Cart/update";
  /*
  String listDetailCart;
  String _listDetailCart;
  _listDetailCart =
      '${cartData.map((e) => "[${e.nameItem},${e.detail},${e.priceSell},${e.number}]").toList()}';
  listDetailCart = _listDetailCart.substring(1, _listDetailCart.length - 1);
   */

  var _dealBegin =
      '${cartData.dealBegin.split('/')[1]}/${cartData.dealBegin.split('/')[0]}/${cartData.dealBegin.split('/')[2]}';
  var _dealFinal =
      '${cartData.dealFinal.split('/')[1]}/${cartData.dealFinal.split('/')[0]}/${cartData.dealFinal.split('/')[2]}';
  var _dateBegin =
      '${cartData.dateBegin.split('/')[1]}/${cartData.dateBegin.split('/')[0]}/${cartData.dateBegin.split('/')[2]}';
  var _dateFinal =
      '${cartData.dateFinal.split('/')[1]}/${cartData.dateFinal.split('/')[0]}/${cartData.dateFinal.split('/')[2]}';

  String statusCart = 'ชำระเงินแล้ว';
  Map params = Map();
  params['cartId'] = cartData.cartId.toString();
  params['itemId'] = cartData.itemId.toString();
  params['marketId'] = cartData.marketId.toString();
  params['nameCart'] = cartData.nameItem.toString();
  params['number'] = cartData.number.toString();
  params['price'] = cartData.price.toString();
  params['priceSell'] = cartData.priceSell.toString();
  params['detail'] = cartData.detail;
  params['status'] = statusCart.toString();
  params['userId'] = userId.toString();
  params['dealBegin'] = _dealBegin.toString();
  params['dealFinal'] = _dealFinal.toString();
  params['dateBegin'] = _dateBegin.toString();
  params['dateFinal'] = _dateFinal.toString();

  await http.post(Uri.parse(urlUpdateStatusCart), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var resStatus = resData['status'];
    if (resStatus == 1) {
      print(resData);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกสถานะ Cart ผิดพลาด !')));
    }
  });
}
