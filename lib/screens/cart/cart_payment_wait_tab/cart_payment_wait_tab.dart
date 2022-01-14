import 'dart:convert';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/method/getImagePayment.dart';
import 'package:app_rmuti_shop/method/method_listPaymentStatus.dart';
import 'package:app_rmuti_shop/screens/cart/cart_payment_wait_tab/edit_payment_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                                      'Order Id : ${snapshot.data[index].orderId}'),
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
                                  Container(
                                    child: snapshot.data[index].status ==
                                            'รอดำเนินการ'
                                        ? Text(
                                            '${snapshot.data[index].status}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber),
                                          )
                                        : Text(
                                            '${snapshot.data[index].status}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: snapshot.data[index].status ==
                                        'รอดำเนินการ'
                                    ? Center(
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
                                      )
                                    : Center(
                                        child: Container(
                                          height: 25,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.amber),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPaymentPage(
                                                                token,
                                                                snapshot.data[
                                                                    index])));
                                              },
                                              child:
                                                  Text('เพิ่มสลีปการโอนเงิน')),
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
                future: getImagePay(token, snapShotPaymentId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotImagePayment) {
                  if (snapshotImagePayment.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshotImagePayment.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Image.memory(
                                    base64Decode(
                                        snapshotImagePayment.data[index]),
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width*0.7,
                                  ),
                                ),
                              );
                            }));
                  }
                },
              ),
            ),
          );
        });
  }
}
