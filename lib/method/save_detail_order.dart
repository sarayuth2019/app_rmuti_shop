import 'dart:convert';
import 'dart:io';

import 'package:app_rmuti_shop/config/config.dart';
import 'list_cartData_byUserId.dart';
import 'package:http/http.dart' as http;

void saveDetailOrder(token, Cart cartData, int orderId) async {
  final String urlSaveDetailOrder = '${Config.API_URL}/DetailOrder/save';
  String size = cartData.detail.split(',')[0];
  String color = cartData.detail.split(',')[1];

  print('${cartData}');
  print('orderId : ${orderId.toString()}');
  print('size : ${size}');
  print('color : ${color}');

  Map params = Map();
  params['orderId'] = orderId.toString();
  params['nameItem'] = '${cartData.itemId}:${cartData.nameItem}'.toString();
  params['size'] = size.toString();
  params['color'] = color.toString();
  params['number'] = cartData.number.toString();
  params['price'] = cartData.priceSell.toString();
  await http.post(Uri.parse(urlSaveDetailOrder), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var status = resData['status'];
    if (status == 1) {
    } else {
      print('Save detail OrderId : ${orderId.toString()}  Fall !!!!!');
    }
  });
}
