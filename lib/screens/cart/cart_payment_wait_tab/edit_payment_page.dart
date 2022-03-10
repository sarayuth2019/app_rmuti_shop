import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/getImagePayment.dart';
import 'package:app_rmuti_shop/method/list_bankmarket.dart';
import 'package:app_rmuti_shop/method/method_listPaymentStatus.dart';
import 'package:app_rmuti_shop/method/saveImagePayment.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditPaymentPage extends StatefulWidget {
  EditPaymentPage(this.token, this.paymentData);

  final token;
  final paymentData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditPaymentPage(token, paymentData);
  }
}

class _EditPaymentPage extends State {
  _EditPaymentPage(this.token, this.paymentData);

  final token;
  final Payment paymentData;
  File? _imageFile;
  var imageData;
  List _listImagePayment = [];

  double _fontSize = 12;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Id : ${paymentData.payId}',
          style: TextStyle(color: Colors.teal, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ราคาสินค้า',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        ' ${paymentData.amount} ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'บาท',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    'ชำระเงินผ่านทาง',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FutureBuilder(
                    future: listBankMarket(token, 1),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshotListBankMarket) {
                      if (snapshotListBankMarket.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshotListBankMarket.data.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${snapshotListBankMarket.data[index].nameBank.toString()}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'ชื่อบัญชี : ${snapshotListBankMarket.data[index].bankAccountName.toString()}',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Text(
                                            'เลขบัญชี : ${snapshotListBankMarket.data[index].bankNumber}',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              height: 20,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              (Colors.teal)),
                                                  onPressed: () {
                                                    FlutterClipboard.copy(
                                                            snapshotListBankMarket
                                                                .data[index]
                                                                .bankNumber
                                                                .toString())
                                                        .then((value) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  'Copy Bank Number !')));
                                                    });
                                                  },
                                                  child: Text('copy')))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  )
                ],
              ),
            ),
            FutureBuilder(
              future: getImagePay(token, paymentData.payId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Center(child: Text('กำลังโหลด...'));
                } else {
                  if (_imageFile == null) {
                    _listImagePayment = snapshot.data;
                  } else {
                    print(
                        '_listImagePayment.length : ${_listImagePayment.length}');
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 310,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _listImagePayment.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14.0, left: 14.0),
                                  child: Container(
                                    height: 300,
                                    width: 180,
                                    child: Image.memory(
                                      base64Decode(_listImagePayment[index]),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                                child: snapshot.data.length ==
                                        _listImagePayment.length
                                    ? GestureDetector(
                                        onTap: () {
                                          _onGallery();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[400]!),
                                          ),
                                          height: 310,
                                          width: 180,
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add),
                                              Text('เพิ่มสลีปการโอนเงิน'),
                                            ],
                                          )),
                                        ),
                                      )
                                    : Container())
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Text(
                      'หมายเหตุ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'การชำระเงินของท่านผิดพลาด โปรดตรวจสอบสลีปของท่าน',
                      style: TextStyle(fontSize: _fontSize),
                    ),
                    Text(
                      'หากจำนวนเงินไม่ตรงกับราคาสินค้า กรุณาโอนเพิ่ม',
                      style: TextStyle(fontSize: _fontSize),
                    ),
                    Text(
                      'พร้อมเพิ่มหลักฐานการโอนเงินที่ได้โอนเพิ่ม',
                      style: TextStyle(fontSize: _fontSize),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              child: Text('บันทึกการแก้ไข'),
              onPressed: () {
                _saveStatusPayment(
                    paymentData, 'รอดำเนินการ', paymentData.userId);
              },
            )
          ],
        ),
      ),
    );
  }

  void _saveStatusPayment(_paymentData, statusPayment, userId) async {
    final String urlSavePay = '${Config.API_URL}/Pay/save';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String _date =
        '${_paymentData.date.split('/')[1]}/${_paymentData.date.split('/')[0]}/${_paymentData.date.split('/')[2]}';
    //String status = 'ชำระเงินสำเร็จ';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['orderId'] = _paymentData.orderId.toString();
    params['marketId'] = _paymentData.marketId.toString();
    //params['number'] = _paymentData.number.toString();
    //params['itemId'] = _paymentData.itemId.toString();
    //params['detail'] = _paymentData.detail.toString();
    params['bankTransfer'] = _paymentData.bankTransfer.toString();
    params['bankReceive'] = _paymentData.bankReceive.toString();
    params['date'] = _date.toString();
    params['time'] = _paymentData.time.toString();
    params['amount'] = _paymentData.amount.toString();
    params['lastNumber'] = _paymentData.lastNumber.toString();
    params['status'] = statusPayment.toString();
    await http.post(Uri.parse(urlSavePay), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var resStatus = resData['status'];
      if (resStatus == 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('บันทึกสถานะสำเร็จ')));
        saveImagePayment(
            context, token, userId, paymentData.payId, _imageFile!, 'ไม่แก้ไข');
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  _onGallery() async {
    print('_listImagePayment.length : ${_listImagePayment.length}');
    print('Select Gallery');
    var _imageGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 100);
    if (_imageGallery != null) {
      if (_imageFile == null) {
        print('_image file == null');
        setState(() {
          _imageFile = File(_imageGallery.path);
          imageData = base64Encode(_imageFile!.readAsBytesSync());
          _listImagePayment.add(imageData);
        });
      } else {
        print('_image file != null');
        _listImagePayment.removeAt(_listImagePayment.length - 1);
        setState(() {
          _imageFile = File(_imageGallery.path);
          imageData = base64Encode(_imageFile!.readAsBytesSync());
          _listImagePayment.add(imageData);
        });
      }
      return _listImagePayment;
    } else {
      return null;
    }
  }
}
