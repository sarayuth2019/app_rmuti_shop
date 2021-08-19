import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String? bankReceive;
  String? bankTransfer;
  String? dataTransfer;
  String? _bankTransferValue;
  String? _bankReceiveValue;
  String? _dateTransfer;
  String? _timeNow;

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
          Text(
            'ชำระเงินผ่านทาง',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
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
                  child: imageFile == null
                      ? Center(
                          child: Container(
                            height: 300,
                            width: 190,
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text('เพิ่มภาพสลิปจ่ายเงิน'),
                              ],
                            ),
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
                    decoration: BoxDecoration(border: Border.all()),
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
                    decoration: BoxDecoration(border: Border.all()),
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
                            child: _timeNow == null
                                ? Text('ชม:นาที')
                                : Text('${_timeNow.toString()}')),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        amount = value as int?;
                        print('จำนวนเงิน : ${amount.toString()}');
                      },
                      decoration: InputDecoration(
                          hintText: 'จำนวนเงิน : บาท',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
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
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
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
                      onPressed: () {},
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
        _timeNow = '${value!.hour}:${value.minute}';
      });
    });
  }

  _onGallery() async {
    print('Select Gallery');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1080);
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
