import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPaymentSuccessTab extends StatefulWidget {
  CartPaymentSuccessTab(this.token, this.userId);

  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPaymentSuccessTab(token, userId);
  }
}

class _CartPaymentSuccessTab extends State {
  _CartPaymentSuccessTab(this.token, this.userId);

  final token;
  final userId;

  final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder(
          future: _listPayment(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print(snapshot.data);
              return Center(child: CircularProgressIndicator());
            } else {
              return Scaffold(
                body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Id : ${snapshot.data[index].payId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text('โอนชำระสินค้า : '),
                                  Text(
                                      'item Id ${snapshot.data[index].itemId}'),
                                ],
                              ),
                              Text(
                                  'โอนเงินจำนวน : ${snapshot.data[index].amount} บาท'),
                              Text(
                                  'โอนจากบัญชี : xxxxxxx ${snapshot.data[index].lastNumber}'),
                              Text('${snapshot.data[index].bankTransfer}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('สถานะ : '),
                                  Text(
                                    '${snapshot.data[index].status}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Container(
                                    height: 25,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                        },
                                        child: Text('ใช้สิทธิ์ซื้อสินค้า')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
    );
  }

  Future<void> _onRefresh() async {
    Future.delayed(Duration(seconds: 3));
    setState(() {
      _listPayment();
    });
  }

  Future<void> getImagePay(int paymentId) async {
    var imagePay;
    Map params = Map();
    params['payId'] = paymentId.toString();
    await http.post(Uri.parse(urlGetPayImage), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      var imagePayData = jsonData['dataImages'];
      imagePay = imagePayData;
    });
    return imagePay;
  }

  Future<List<_Payment>> _listPayment() async {
    List<_Payment> listPayment = [];
    List<_Payment> listPaymentWait = [];
    Map params = Map();
    params['userId'] = userId.toString();
    await http.post(Uri.parse(urlGetPaymentByUserId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
      print(jsonData);
      var resData = jsonData['data'];
      for (var i in resData) {
        _Payment _payment = _Payment(
            i['payId'],
            i['status'],
            i['userId'],
            i['marketId'],
            i['itemId'],
            i['amount'],
            i['lastNumber'],
            i['bankTransfer'],
            i['bankReceive'],
            i['date'],
            i['time'],
            i['dataTransfer']);
        listPayment.add(_payment);
      }
      String status = 'ชำระเงินสำเร็จ';
      listPaymentWait = listPayment
          .where((element) =>
              element.status.toLowerCase().contains(status.toLowerCase()))
          .toList();
    });
    return listPaymentWait;
  }
}

class _Payment {
  final int payId;
  final String status;
  final int userId;
  final int marketId;
  final int itemId;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  _Payment(
      this.payId,
      this.status,
      this.userId,
      this.marketId,
      this.itemId,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
