import 'dart:convert';
import 'dart:io';

import 'package:app_rmuti_shop/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class CreateQRCode extends StatefulWidget {
  CreateQRCode(this.paymentId, this.marketId, this.token);

  final int paymentId;
  final int marketId;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createElement
    return _CreateQRCode(paymentId, marketId, token);
  }
}

class _CreateQRCode extends State {
  _CreateQRCode(this.paymentId, this.marketId, this.token);

  final int paymentId;
  final int marketId;
  final token;

  var imageMarket;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'โปรดนำไปแสกนที่ร้านค้าที่ลงทะเบียนเพื่อรับสินค้า',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: QrImage(
                data: paymentId.toString(),
                semanticsLabel: '${paymentId.toString()}',
                size: 250,
                backgroundColor: Colors.white,
              ),
            ),
            FutureBuilder(
              future: sendMarketDataByMarketId(marketId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ชื่อร้าน : ${snapshot.data.nameMarket}'),
                        Text('เบอร์โทรติดต่อ : ${snapshot.data.phoneNumber}'),
                        Text('ที่อยู่ร้าน : ${snapshot.data.descriptionMarket}'),
                        SizedBox(height: 20,),
                        Text(
                          '*หมายเหตุ หากไม่ไปรับสินค้าในวันที่กำหนดทางร้านจะถือว่าท่านสละสิทธิ์',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('เสร็จสิ้น'),
            )
          ],
        ),
      ),
    );
  }

  Future<MarketData?> sendMarketDataByMarketId(int marketId) async {
    final String urlSendAccountById = "${Config.API_URL}/Market/list/id";
    MarketData? _marketAccountData;
    Map params = Map();
    params['id'] = marketId.toString();
    await http.post(Uri.parse(urlSendAccountById), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print("Send Market Data...");
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataAccount = _jsonRes['dataId'];
      imageMarket = _jsonRes['dataImages'];
      print(_dataAccount);
      print("data Market : ${_dataAccount.toString()}");
      print(_dataAccount);
      _marketAccountData = MarketData(
        _dataAccount['marketId'],
        _dataAccount['password'],
        _dataAccount['name'],
        _dataAccount['surname'],
        _dataAccount['email'],
        _dataAccount['statusMarket'],
        _dataAccount['imageMarket'],
        _dataAccount['phoneNumber'],
        _dataAccount['nameMarket'],
        _dataAccount['descriptionMarket'],
        _dataAccount['dateRegister'],
      );
      print("market data : ${_marketAccountData}");
    });
    return _marketAccountData;
  }
}

class MarketData {
  final int? marketID;
  final String? password;
  final String? name;
  final String? surname;
  final String? email;
  final String? statusMarket;
  final String? imageMarket;
  final String? phoneNumber;
  final String? nameMarket;
  final String? descriptionMarket;
  final String? dateRegister;

  MarketData(
      this.marketID,
      this.password,
      this.name,
      this.surname,
      this.email,
      this.statusMarket,
      this.imageMarket,
      this.phoneNumber,
      this.nameMarket,
      this.descriptionMarket,
      this.dateRegister);
}
