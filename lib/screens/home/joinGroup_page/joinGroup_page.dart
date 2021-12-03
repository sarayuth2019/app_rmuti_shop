import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/cart/string_status_cart.dart';
import 'package:app_rmuti_shop/screens/home/joinGroup_page/show_review_page.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/screens/method/review_market_method.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  int _number = 1;

  final urlGetImageByItemId = "${Config.API_URL}/images/";
  final urlSaveToCart = "${Config.API_URL}/Cart/save";
  final snackBarOnSaveToCart = SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น'));
  final snackBarOnJoinGroupSuccess =
      SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น สำเร็จ !'));
  final snackBarNumberError =
      SnackBar(content: Text('กรุณากรอกจำนวนให้ถูกต้อง'));
  final snackBarOnJoinGroupSuccess2 = SnackBar(
      content: Text('กรุณาชำระเงินในหน้ารถเข็น เพื่อยืนยันการลงทะเบียน !'));
  final snackBarOnJoinGroupFall =
      SnackBar(content: Text('กำลังเพิ่มไปยังรถเข็น ผิดพลาด !'));

  var size;
  int _sizePrice = 0;
  bool _checkSelectSize = false;
  var color;
  int _colorPrice = 0;
  bool _checkSelectColor = false;
  var textStyle = TextStyle(fontSize: 12);

  @override
  Widget build(BuildContext context) {
    DateTime _dayNow = DateTime.now();
    var stringDealFinal =
        '${itemData.dealFinal.split('/')[2]}-${itemData.dealFinal.split('/')[1]}-${itemData.dealFinal.split('/')[0]}';
    DateTime _dealFinal = DateTime.parse(stringDealFinal);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: getImage(itemData.itemId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotImage) {
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
                                      child: Center(
                                          child: Text('กำลังโหลดภาพ...')))
                                  : Container(
                                      height: 150,
                                      width: double.infinity,
                                      child: Image.memory(
                                          base64Decode(
                                              snapshotImage.data[index]),
                                          fit: BoxFit.fill)));
                        },
                      ),
                    );
                  }
                },
              ),
              FutureBuilder(
                future: listReviewByMarketId(token, itemData.marketId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotReview) {
                  if (snapshotReview.data == null) {
                    return Text('กำลังโหลด...');
                  } else if (snapshotReview.data.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: double.infinity,
                          decoration: boxDecorationGrey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'ยังไม่มีการรีวิวร้านค้า',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                    );
                  } else {
                    var _sumRating = snapshotReview.data
                        .map((r) => r.rating)
                        .reduce((value, element) => value + element);
                    var _countRating = snapshotReview.data.length;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowReviewPage(
                                      snapshotReview.data,
                                      (_sumRating / _countRating),
                                      _countRating)));
                        },
                        child: Container(
                            decoration: boxDecorationGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'รีวิวของทางร้าน : ${(_sumRating / _countRating).toStringAsFixed(1)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  RatingBar.builder(
                                      itemSize: 30,
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      initialRating: _sumRating / _countRating,
                                      itemBuilder: (context, r) {
                                        return Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                        );
                                      },
                                      onRatingUpdate: (value) {}),
                                ],
                              ),
                            )),
                      ),
                    );
                  }
                },
              ),
              Container(
                  child: itemData.size[0] == 'null'
                      ? Container()
                      : Container(
                          child: _checkSelectSize == false
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _checkSelectSize = !_checkSelectSize;
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: size == null
                                                ? Container(
                                                    child: Text('เลือกขนาด '),
                                                  )
                                                : Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'ขนาด : ${size.split(':')[0].toString()}',
                                                          style: textStyle,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          '+${size.split(':')[1].toString()} บาท',
                                                          style: textStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                        Icon(
                                          Icons.arrow_right_outlined,
                                          color: Colors.teal,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: boxDecorationGrey,
                                  height: 40,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: itemData.size.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            size = itemData.size[index];
                                            _sizePrice = int.parse(itemData
                                                .size[index]
                                                .split(':')[1]);
                                            _checkSelectSize =
                                                !_checkSelectSize;
                                          });
                                        },
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${itemData.size[index]}',
                                            style: textStyle,
                                          ),
                                        )),
                                      );
                                    },
                                  ),
                                ))),
              Container(
                  child: itemData.color[0] == 'null'
                      ? Container()
                      : Container(
                          child: _checkSelectColor == false
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _checkSelectColor = !_checkSelectColor;
                                    });
                                  },
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            child: color == null
                                                ? Container(
                                                    child: Text('เลือกสี'),
                                                  )
                                                : Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'สี : ${color.split(':')[0].toString()}',
                                                          style: textStyle,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          '+${color.split(':')[1].toString()} บาท',
                                                          style: textStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                        Icon(
                                          Icons.arrow_right_outlined,
                                          color: Colors.teal,
                                          size: 35,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: boxDecorationGrey,
                                  height: 40,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: itemData.color.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            color = itemData.color[index];
                                            _colorPrice = int.parse(itemData
                                                .color[index]
                                                .split(':')[1]);
                                            _checkSelectColor =
                                                !_checkSelectColor;
                                          });
                                        },
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${itemData.color[index]}',
                                            style: textStyle,
                                          ),
                                        )),
                                      );
                                    },
                                  ),
                                ))),
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
                        Row(
                          children: [
                            Text(
                              itemData.nameItem,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Container(
                                child: itemData.groupItems == 1
                                    ? Text('(สินค้าพร้อมขาย)')
                                    : Text('(สินค้า Pre order)'))
                          ],
                        ),
                        Text(
                          "ราคา ${((itemData.priceSell + _sizePrice + _colorPrice) * _number).toString()} บาท",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "ลดราคาจาก ${((itemData.price + _sizePrice + _colorPrice) * _number).toString()} บาท",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "จำนวนคนที่ต้องการ ${itemData.countRequest} คน",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "มีผู้เข้าร่วมแล้ว ${itemData.count} คน",
                          style: TextStyle(fontSize: 14),
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
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "ระยะเวลาที่สามารถใช้สิทธิ์รับสินค้าได้",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${itemData.dateBegin} - ${itemData.dateFinal}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  child: itemData.count == itemData.countRequest
                      ? Text('* จำนวนผู้ลงทะเบียนครบแล้ว')
                      : Container()),
              Container(
                  child:
                      _dayNow.isAfter(_dealFinal.add(Duration(days: 1))) == true
                          ? Text('* สิ้นสุดระยะเวลาการลงทะเบียนแล้ว')
                          : Container()),
              Container(
                  child: itemData.count == itemData.countRequest ||
                          _dayNow.isAfter(_dealFinal.add(Duration(days: 1))) ==
                              true
                      ? Card(
                          color: Colors.red,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ไม่สามารถลงทะเบียนเข้าร่วมได้',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        print(_number);
                                        if (_number <= 1) {
                                          setState(() {
                                            _number = 1;
                                            print(_number);
                                          });
                                        } else {
                                          setState(() {
                                            _number--;
                                            print(_number);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.teal,
                                      )),
                                  Container(
                                    decoration: boxDecorationGrey,
                                    height: 30,
                                    width: 40,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                          text: _number.toString()),
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      onChanged: (text) {
                                        if (text.toString().length == 0) {
                                          setState(() {
                                            _number = 1;
                                            print(_number);
                                          });
                                        } else {
                                          _number = int.parse(text);
                                          print(_number);
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _number++;
                                          print(_number);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.teal,
                                      ))
                                ],
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.teal),
                                onPressed: () {
                                  if (_number == 0 ||
                                      (_number + itemData.count) >
                                          itemData.countRequest) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBarNumberError);
                                  } else {
                                    print('Save to cart +++++');
                                    _onSaveToCart();
                                  }
                                },
                                child: Text("เพิ่มไปยังรถเข็น"),
                              ),
                            ],
                          ),
                        ))
            ],
          ),
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
    params['number'] = _number.toString();
    params['price'] = (itemData.price + _sizePrice + _colorPrice).toString();
    params['priceSell'] =
        (itemData.priceSell + _sizePrice + _colorPrice).toString();
    params['detail'] = '${size.toString()},${color.toString()}';
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

class CheckBox {
  CheckBox({this.value = false});

  bool value;
}
