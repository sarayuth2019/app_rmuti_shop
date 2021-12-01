import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/screens/method/saveImagePayment.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PayPage extends StatefulWidget {
  PayPage(this.token, this.userId, this.cartData);

  final token;
  final userId;
  final cartData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PayPage(token, userId, cartData);
  }
}

class _PayPage extends State {
  _PayPage(this.token, this.userId, this.cartData);

  final token;
  final userId;
  final cartData;

  final String urlSavePay = '${Config.API_URL}/Pay/save';
  String _bankName = 'ธนาคารไทยพาณิชย์ SCB';
  String _bankNumber = 'xxxxxxxxxx';
  List<String> _listTransferBankName = [
    'ธนาคารไทยพาณิชย์ SCB',
    'ธนาคารกรุงเทพ BBL',
    'ธนาคารกสิกรไทย KBANK',
    'ธนาคารกรุงไทย KTB',
    'ธนาคารกรุงศรีอยุธยา BAY',
    'ธนาคารทหารไทยธนชาต TTB',
    'ธนาคารออมสิน GSB',
    'ธนาคารอิสลามแห่งประเทศไทย ISBT'
  ];
  List<String> _listReceiveBankName = [
    'ธนาคารไทยพาณิชย์ SCB',
  ];

  File? imageFile;
  String? imageData;
  int? amount;
  String? dataTransfer;
  String? _bankTransferValue;
  String? _bankReceiveValue;
  String? _dateTransfer;
  String? _timeTransfer;
  int? _lastNumber;

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
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ราคาสินค้า',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                ' ${cartData.priceSell * cartData.number} ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_bankNumber.toString()}'),
              SizedBox(
                width: 10,
              ),
              Container(
                  height: 20,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: (Colors.teal)),
                      onPressed: () {
                        FlutterClipboard.copy(_bankNumber).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copy Bank Number !')));
                        });
                      },
                      child: Text('copy')))
            ],
          ),
          Text('${_bankName.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
              _onGallery();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: boxDecorationGrey,
                  height: 300,
                  width: 190,
                  child: imageFile == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text('เพิ่มภาพสลิปจ่ายเงิน'),
                            ],
                          ),
                        )
                      : Center(
                          child: Container(
                            height: 300,
                            width: 190,
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'โอนจากธนาคาร',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: _bankTransferValue,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  underline: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54)),
                  ),
                  hint: Text('เลือกธนาคาร'),
                  items: _listTransferBankName
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _bankTransferValue = value as String?;
                    });
                  },
                ),
                Text(
                  'โอนไปยังธนาคาร',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  value: _bankReceiveValue,
                  iconEnabledColor: Colors.black,
                  isExpanded: true,
                  underline: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54)),
                  ),
                  hint: Text('เลือกธนาคาร'),
                  items: _listReceiveBankName
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _bankReceiveValue = value as String?;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _pickDate(context);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: boxDecorationGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'วันที่โอนเงิน',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            child: _dateTransfer == null
                                ? Text('เดือน-วัน-ปี')
                                : Text('${_dateTransfer.toString()}')),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _pickTime(context);
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: boxDecorationGrey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'เวลาที่โอนเงิน',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            child: _timeTransfer == null
                                ? Text('ชม:นาที')
                                : Text('${_timeTransfer.toString()}')),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('จำนวนเงิน : บาท'),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: boxDecorationGrey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        amount = int.parse(value);
                        print('จำนวนเงิน : ${amount.toString()}');
                      },
                      decoration: InputDecoration(
                          hintText: 'จำนวนเงิน', border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('เลขบัญชี : '),
                    Text('xxxxxx '),
                    Text(
                      'xxxx',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: boxDecorationGrey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _lastNumber = int.parse(value);
                        print('เลขท้าย บช. : ${_lastNumber.toString()}');
                      },
                      decoration: InputDecoration(
                          hintText: 'เลขท้ายบัญชี 4 ตัว',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.teal),
                      onPressed: () {
                        checkNullData();
                      },
                      child: Text('ชำระเงิน')),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((date) {
      setState(() {
        _dateTransfer = "${date!.month}/${date.day}/${date.year}";
        print(date);
      });
    });
  }

  Future _pickTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    showTimePicker(context: context, initialTime: initialTime).then((value) {
      setState(() {
        _timeTransfer = '${value!.hour}:${value.minute}';
      });
    });
  }

  void checkNullData() {
    if (_bankTransferValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกธนาคารที่โอนเงิน')));
    } else if (_bankReceiveValue == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเลือกธนาคารที่รับเงิน')));
    } else if (_dateTransfer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มวันที่โอนเงิน')));
    } else if (_timeTransfer == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มเวลาที่โอนเงิน')));
    } else if (amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณากรอกจำนวนเงินที่โอน')));
    } else if (amount != (cartData.priceSell* cartData.number)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกจำนวนเงินให้ถูกต้อง')));
    } else if (_lastNumber == null || _lastNumber.toString().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('กรุณากรอกเลขท้ายบัญชีธนาคาร 4 ตัว')));
    } else if (imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณาเพิ่มภาพสลิปการโอนเงิน')));
    } else {
      print(_bankTransferValue);
      print(_bankReceiveValue);
      print(_dateTransfer);
      print(_timeTransfer);
      print(amount);
      print(_lastNumber);
      _savePayment();
    }
  }

  void _savePayment() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String status = 'รอดำเนินการ';
    print('save pay ....');
    Map params = Map();
    params['userId'] = userId.toString();
    params['marketId'] = cartData.marketId.toString();
    params['number'] = cartData.number.toString();
    params['itemId'] = cartData.itemId.toString();
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
        saveImagePayment(context, token, payId, imageFile!, cartData);
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }

  _onGallery() async {
    print('Select Gallery');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 100);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      return imageData;
    } else {
      return null;
    }
  }
}
