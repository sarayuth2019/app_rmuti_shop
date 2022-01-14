import 'dart:convert';
import 'dart:io';

import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart'as http;

Future<void> getImagePay(token,int paymentId) async {
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/payId';
  var imagePay;
  Map params = Map();
  params['payId'] = paymentId.toString();
  await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var imagePayData = jsonData['dataImages'];
    print(imagePayData);
    imagePay = imagePayData;
  });
  return imagePay;
}