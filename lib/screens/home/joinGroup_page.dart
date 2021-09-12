import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/cart/string_status_cart.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JoinGroupPage extends StatefulWidget {
  JoinGroupPage(this.itemData, this.token, this.userId);

  final itemData;
  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _JoinGroupPage(itemData, token, userId);
  }
}

class _JoinGroupPage extends State {
  _JoinGroupPage(this.itemData, this.token, this.userId);

  final itemData;
  final token;
  final userId;

  final urlGetImageByItemId = "${Config.API_URL}/images/";
  final urlSaveToCart = "${Config.API_URL}/Cart/save";
  final snackBarOnSaveToCart = SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น'));
  final snackBarOnJoinGroupSuccess =
      SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น สำเร็จ !'));
  final snackBarOnJoinGroupSuccess2 = SnackBar(
      content: Text('กรุณาชำระเงินในหน้ารถเข็น เพื่อยืนยันการลงทะเบียน !'));
  final snackBarOnJoinGroupFall =
      SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น ผิดพลาด !'));

  @override
  Widget build(BuildContext context) {
    print(itemData);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: getImage(itemData.itemId),
              builder:
                  (BuildContext context, AsyncSnapshot<dynamic> snapshotImage) {
                print(snapshotImage.data.runtimeType);
                if (snapshotImage.data == null) {
                  return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: boxDecorationGrey,
                      child: Center(child: Text('กำลังโหลดภาพ...')));
                } else {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          initialPage: 0,
                          enlargeCenterPage: true,
                          autoPlay: true),
                      itemCount: snapshotImage.data.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Container(
                            child: snapshotImage.data.length == 0
                                ? Container(
                                    child:
                                        Center(child: Text('กำลังโหลดภาพ...')))
                                : Container(
                                    height: 150,
                                    width: double.infinity,
                                    child: Image.memory(
                                        base64Decode(snapshotImage.data[index]),
                                        fit: BoxFit.fill)));
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: boxDecorationGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemData.nameItem,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ราคา ${itemData.priceSell.toString()} บาท",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "ลดราคาจาก ${itemData.price.toString()} บาท",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "จำนวนคนที่ต้องการ ${itemData.countRequest} คน",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "มีผู้เข้าร่วมแล้ว ${itemData.count} คน",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: boxDecorationGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ระยะเวลาลงทะเบียนเข้าร่วม",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${itemData.dealBegin} - ${itemData.dealFinal}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "ระยะเวลาที่สามารถใช้สิทธิ์ได้",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${itemData.dateBegin} - ${itemData.dateFinal}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                onPressed: () {
                  _onSaveToCart();
                },
                child: Text("ลงทะเบียนเข้าร่วม"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getImage(_itemId) async {
    var _resData;
    await http.get(
        Uri.parse('${urlGetImageByItemId.toString()}${_itemId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      print(res.body);
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _statusData = jsonData['status'];
      var _dataImage = jsonData['dataImages'];
      //var _dataId = jsonData['dataId'];
      if (_statusData == 1) {
        _resData = _dataImage;
        //print("jsonData : ${_resData.toString()}");
      }
    });
    print("_resData ${_resData.toString()}");
    return _resData;
  }

  void _onSaveToCart() async {
    var _dealBegin =
        '${itemData.dealBegin.split('/')[1]}/${itemData.dealBegin.split('/')[0]}/${itemData.dealBegin.split('/')[2]}';
    var _dealFinal =
        '${itemData.dealFinal.split('/')[1]}/${itemData.dealFinal.split('/')[0]}/${itemData.dealFinal.split('/')[2]}';
    var _dateBegin =
        '${itemData.dateBegin.split('/')[1]}/${itemData.dateBegin.split('/')[0]}/${itemData.dateBegin.split('/')[2]}';
    var _dateFinal =
        '${itemData.dateFinal.split('/')[1]}/${itemData.dateFinal.split('/')[0]}/${itemData.dateFinal.split('/')[2]}';

    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSaveToCart);
    String statusCart = statusAddToCart;
    Map params = Map();
    params['itemId'] = itemData.itemId.toString();
    params['marketId'] = itemData.marketId.toString();
    params['nameCart'] = itemData.nameItem.toString();
    params['number'] = 1.toString();
    params['price'] = itemData.price.toString();
    params['priceSell'] = itemData.priceSell.toString();
    params['status'] = statusCart.toString();
    params['userId'] = userId.toString();
    params['dealBegin'] = _dealBegin.toString();
    params['dealFinal'] = _dealFinal.toString();
    params['dateBegin'] = _dateBegin.toString();
    params['dateFinal'] = _dateFinal.toString();

    await http.post(Uri.parse(urlSaveToCart), body: params, headers: {
      HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var resStatus = resData['status'];
      if (resStatus == 1) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBarOnJoinGroupSuccess);
        ScaffoldMessenger.of(context).showSnackBar(snackBarOnJoinGroupSuccess2);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarOnJoinGroupFall);
      }
    });
  }
}
