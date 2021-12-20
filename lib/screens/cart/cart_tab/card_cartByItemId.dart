import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/item_data_by_itemId.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:app_rmuti_shop/screens/method/save_cart_data_to_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardCartByItemId extends StatefulWidget {
  CardCartByItemId(this.token, this.listCartByItemId, this.userId,this.callBack);

  final token;
  final List<Cart> listCartByItemId;
  final int userId;
  final Function callBack;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CardCartByItemId(token, listCartByItemId, userId,callBack);
  }
}

class _CardCartByItemId extends State {
  _CardCartByItemId(this.token, this.listCartByItemId, this.userId,this.callBack);

  final token;
  final List<Cart> listCartByItemId;
  final int userId;
  final Function callBack;

  int sumPriceTotal = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (listCartByItemId.length == 0) {
      return Container();
    } else {
      return Column(
        children: [
          // Text('Market Id : ${listCartByItemId[0].marketId}'),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listCartByItemId.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    children: [
                      //  Text("${listGroupCartData[index].cartId} : "),
                      Text("${listCartByItemId[index].nameItem}"),
                      Text('  x  ${listCartByItemId[index].number}'),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          child: listCartByItemId[index].detail.split(',')[0] ==
                                  'null'
                              ? Container()
                              : Text(
                                  'ขนาด : ${(listCartByItemId[index].detail.split(',')[0]).split(':')[0]}')),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          child: listCartByItemId[index].detail.split(',')[1] ==
                                  'null'
                              ? Container()
                              : Text(
                                  'สี : ${(listCartByItemId[index].detail.split(',')[1]).split(':')[0]}')),
                      SizedBox(
                        width: 10,
                      ),
                      Text('ราคา : ${listCartByItemId[index].priceSell} บาท'),
                      Container(
                          child: listCartByItemId[index].status == 'รอชำระเงิน'
                              ? IconButton(
                                  onPressed: () {
                                    print(
                                        'cartId delete : ${listCartByItemId[index].cartId}');
                                    _showAlertDeleteCart(context,
                                        listCartByItemId[index].cartId, index);
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    size: 16,
                                    color: Colors.red,
                                  ))
                              : Container()),
                    ],
                  ),
                ],
              );
            },
          ),
          Row(
            children: [
              FutureBuilder(
                future: sumPriceMarket(listCartByItemId),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Text('กำลังโหลด...');
                  } else {
                    return Text('ราคารวม : ${snapshot.data} บาท');
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              FutureBuilder(
                future: listItemDataByItemId(token, listCartByItemId[0].itemId),
                builder: (BuildContext context,
                    AsyncSnapshot<dynamic> snapshotItemData) {
                  if (snapshotItemData.data == null) {
                    return Text('กำลังโหลด...');
                  } else {
                    DateTime _dayNow = DateTime.now();
                    var stringDealFinal =
                        '${snapshotItemData.data.dealFinal.split('/')[2]}-${snapshotItemData.data.dealFinal.split('/')[1]}-${snapshotItemData.data.dealFinal.split('/')[0]}';
                    DateTime _dealFinal = DateTime.parse(stringDealFinal);
                    return Column(
                      children: [
                        Container(
                            child: snapshotItemData.data.count ==
                                    snapshotItemData.data.countRequest
                                ? Text('* จำนวนผู้ลงทะเบียนครบแล้ว')
                                : Container()),
                        Container(
                            child: _dayNow.isAfter(
                                        _dealFinal.add(Duration(days: 1))) ==
                                    true
                                ? Text('* สิ้นสุดระยะเวลาการลงทะเบียนแล้ว')
                                : Container()),
                        Container(
                            child: snapshotItemData.data.count ==
                                        snapshotItemData.data.countRequest ||
                                    _dayNow.isAfter(_dealFinal
                                            .add(Duration(days: 1))) ==
                                        true
                                ? Card(
                                    color: Colors.red,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'ไม่สามารถชำระเงินได้',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 90,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () {
                                            print('Save to Order !!!!!!');
                                            //saveCartDataToOrder(token, listCartByItemId, userId);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            child: Center(
                                              child: Text('ชำระเงิน'),
                                            ),
                                          )),
                                    ),
                                  ))
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ],
      );
    }
  }

  Future<int> sumPriceMarket(listGroupData) async {
    int sumPriceMarket = 0;
    print('กำลังรวมราคาของร้านค้านั้นๆ');

    sumPriceTotal = listCartByItemId
        .map((e) => e.priceSell * e.number)
        .reduce((value, element) => value + element);

    print('ราคารวมทั้งหมด  :  ${sumPriceTotal.toString()}');

    sumPriceMarket = listGroupData
        .map((m) => m.priceSell * m.number)
        .reduce((a, b) => a + b);

    print('ราคารวมของร้านค้านั้นๆ  :  ${sumPriceMarket.toString()}');
    return sumPriceMarket;
  }

  void _showAlertDeleteCart(BuildContext context, snapShotId, index) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'ต้องการลบรายการนี้ ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            deleteCart(token, snapShotId, index);
                            setState(() {
                              Navigator.pop(context);
                            });
                          })),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('ยกเลิก'),
                          onTap: () {
                            Navigator.pop(context);
                          })),
                ],
              ),
            ),
          );
        });
  }

  void deleteCart(token, snapShotId, int index) async {
    print('cartId delete : ${snapShotId.toString()}.....');
    final urlDeleteByCartId = "${Config.API_URL}/Cart/delete";
    var statusRes;
    Map params = Map();
    params['id'] = snapShotId.toString();
    await http.post(Uri.parse(urlDeleteByCartId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resData = jsonDecode(res.body);
      statusRes = resData['status'];
      if (statusRes == 0) {
        setState(() {
          print(res.body);
          listCartByItemId.removeAt(index);
          callBack(listCartByItemId.length);
        });
      }
    });
  }
}
