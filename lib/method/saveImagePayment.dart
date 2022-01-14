import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/editCartStatus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void saveImagePayment(
    context, token, userId, int payId, File imageFile, listCartData) async {
  print("payId : ${payId.toString()}");

  print("save image pay Id : ${payId.toString()}");
  print("Update image File : ${imageFile.toString()}");
  final String urlSaveImagePay = '${Config.API_URL}/ImagePay/save';

  var request = http.MultipartRequest('POST', Uri.parse(urlSaveImagePay));
  request.headers
      .addAll({HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'});

  var _multipart = await http.MultipartFile.fromPath('picture', imageFile.path);

  request.files.add(_multipart);
  request.fields['payId'] = payId.toString();

  await http.Response.fromStream(await request.send()).then((res) {
    print(res.body);
    var resData = jsonDecode(res.body);
    var statusRes = resData['status'];
    if (statusRes == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ชำระเงินสำเร็จ รอการตรวจสอบการชำระเงิน')));
      if (listCartData == 'ไม่แก้ไข') {
        print(listCartData);
        Navigator.pop(context);
      } else {
        listCartData.forEach((cartData) {
          editCartStatus(context, token, userId, cartData);
        });
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกภาพ ชำระเงินผิดพลาด !')));
    }
  });
}
