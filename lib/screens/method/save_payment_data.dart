import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/saveImagePayment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void savePayment(
    context,
    token,
    orderId,
    listCartData,
    userId,
    _bankTransferValue,
    _bankReceiveValue,
    _dateTransfer,
    _timeTransfer,
    amount,
    _lastNumber,
    imageFile) async {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
  String status = 'รอดำเนินการ';
  print('save pay ....');

  final String urlSavePay = '${Config.API_URL}/Pay/save';

  Map params = Map();
  params['userId'] = userId.toString();
  params['orderId'] = orderId.toString();
  params['marketId'] = listCartData[0].marketId.toString();
  // params['number'] = cartData.number.toString();
  // params['itemId'] = cartData.itemId.toString();
  //params['detail'] = listDetailCart.toString();
  params['bankTransfer'] = _bankTransferValue.toString();
  params['bankReceive'] = _bankReceiveValue.toString();
  params['date'] = _dateTransfer.toString();
  params['time'] = '${_timeTransfer.toString()}:00';
  params['amount'] = amount.toString();
  params['lastNumber'] = _lastNumber.toString();
  params['status'] = status.toString();
  await http.post(Uri.parse(urlSavePay), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var resStatus = resData['status'];
    if (resStatus == 1) {
      var dataPay = resData['data'];
      var payId = dataPay['payId'];
      print(payId);
      saveImagePayment(context, token, userId, payId, imageFile!, listCartData);
    } else {
      print('save fall !');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
    }
  });
}
