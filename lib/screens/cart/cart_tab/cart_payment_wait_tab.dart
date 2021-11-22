import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/method_listPaymentStatus.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartPaymentWaitTab extends StatefulWidget {
  CartPaymentWaitTab(this.token, this.userId);

  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPaymentWaitTab(token, userId);
  }
}

class _CartPaymentWaitTab extends State {
  _CartPaymentWaitTab(this.token, this.userId);

  final token;
  final userId;

  final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
  String _status = 'รอดำเนินการ';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder(
          future: listPaymentByStatus(token, userId, _status),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print(snapshot.data);
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'ไม่มีรายการ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              );
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
                              Row(
                                children: [
                                  Text('${snapshot.data[index].bankTransfer}'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                          '${snapshot.data[index].bankReceive}'))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('สถานะ : '),
                                  Text(
                                    '${snapshot.data[index].status}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),
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
                                            primary: Colors.amber),
                                        onPressed: () {
                                          _showPaymentImage(context,
                                              snapshot.data[index].payId);
                                        },
                                        child: Text('ดูสลีปจ่ายเงิน')),
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
      listPaymentByStatus(token, userId, _status);
    });
  }

  void _showPaymentImage(BuildContext context, snapShotPaymentId) async {
    print('Show Alert Dialog Image Payment !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Payment Id : ${snapShotPaymentId.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: FutureBuilder(
                future: getImagePay(snapShotPaymentId),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                        height: 250,
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                              initialPage: 0,
                              enlargeCenterPage: true,
                              autoPlay: false),
                          itemCount: snapshot.data.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return Container(
                                child: snapshot.data.length == 0
                                    ? Container(
                                        child: Center(
                                            child: Text('กำลังโหลดสลีป...')))
                                    : Container(
                                        child: Image.memory(
                                        base64Decode(snapshot.data[index]),fit: BoxFit.fill,
                                      )));
                          },
                        ));
                  }
                },
              ),
            ),
          );
        });
  }

  Future<void> getImagePay(int paymentId) async {
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
}
