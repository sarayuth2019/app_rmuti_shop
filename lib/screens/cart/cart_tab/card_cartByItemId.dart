import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/item_data_by_itemId.dart';
import 'package:app_rmuti_shop/method/list_cartData_byUserId.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/show_list_cart_buy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardCartByItemId extends StatefulWidget {
  CardCartByItemId(
      this.token,
      this.listCartByItemId,
      this.userId,
      this.callBack,
      this.callBackMainPage,
      this.removeListCart,
      this.removeListGroupCartByMarket);

  final token;
  final List<Cart> listCartByItemId;
  final int userId;
  final Function callBack;
  final Function callBackMainPage;
  final Function removeListCart;
  final Function removeListGroupCartByMarket;

  @override
  _CardCartByItemIdState createState() => _CardCartByItemIdState(
      token,
      listCartByItemId,
      userId,
      callBack,
      callBackMainPage,
      removeListCart,
      removeListGroupCartByMarket);
}

class _CardCartByItemIdState extends State<CardCartByItemId> {
  _CardCartByItemIdState(
      this.token,
      this.listCartByItemId,
      this.userId,
      this.callBack,
      this.callBackMainPage,
      this.removeListCart,
      this.removeListGroupCartByMarket);

  final token;
  List<Cart> listCartByItemId;
  final int userId;
  final Function callBack;
  final Function callBackMainPage;
  final Function removeListCart;
  final Function removeListGroupCartByMarket;

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //  Text("${listGroupCartData[index].cartId} : "),
                      Container(
                        child: Row(
                          children: [
                            Text("${listCartByItemId[index].nameItem}"),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                                child: listCartByItemId[index]
                                            .detail
                                            .split(',')[0] ==
                                        'null'
                                    ? Container()
                                    : Text(
                                        'ขนาด : ${(listCartByItemId[index].detail.split(',')[0]).split(':')[0]}')),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                                child: listCartByItemId[index]
                                            .detail
                                            .split(',')[1] ==
                                        'null'
                                    ? Container()
                                    : Text(
                                        'สี : ${(listCartByItemId[index].detail.split(',')[1]).split(':')[0]}')),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                'ราคา : ${listCartByItemId[index].priceSell * listCartByItemId[index].number} บาท'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          child: listCartByItemId[index].status == 'รอชำระเงิน'
                              ? IconButton(
                                  onPressed: () {
                                    print(
                                        'cartId delete : ${listCartByItemId[index].cartId}');
                                    showDialogDelete(
                                        context,
                                        listCartByItemId[index].cartId,
                                        listCartByItemId[index]);
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    size: 18,
                                    color: Colors.red,
                                  ))
                              : Container()),
                    ],
                  ),
                  Container(
                      child: Row(
                    children: [
                      Text('จำนวน'),
                      SizedBox(
                        width: 4,
                      ),
                      IconButton(
                        onPressed: () {
                          if (listCartByItemId[index].number <= 1) {
                            setState(() {
                              listCartByItemId[index].number = 1;
                            });
                          } else {
                            setState(() {
                              listCartByItemId[index].number--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                        color: Colors.teal,
                      ),
                      Text('${listCartByItemId[index].number}'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            listCartByItemId[index].number++;
                          });
                        },
                        icon: Icon(Icons.add),
                        color: Colors.teal,
                      ),
                    ],
                  )),
                ],
              );
            },
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
                            ? Text('* จำนวนที่ต้องการขายครบแล้ว')
                            : Container()),
                    Container(
                        child: _dayNow.isAfter(
                                    _dealFinal.add(Duration(days: 1))) ==
                                true
                            ? Text('* สิ้นสุดระยะเวลาการลงทะเบียนแล้ว')
                            : Container()),
                    Row(
                      children: [
                        FutureBuilder(
                          future: sumPriceMarket(listCartByItemId),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.data == null) {
                              return Text('กำลังโหลด...');
                            } else {
                              return Row(
                                children: [
                                  Text('ราคารวม : '),
                                  Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(' บาท'),
                                ],
                              );
                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
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
                                      height: 30,
                                      width: 90,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () {
                                            print(
                                                '${listCartByItemId.map((e) => e.number).reduce((a, b) => a + b) + (snapshotItemData.data.count)}/${snapshotItemData.data.countRequest}');
                                            if (listCartByItemId
                                                        .map((e) => e.number)
                                                        .reduce(
                                                            (a, b) => a + b) +
                                                    (snapshotItemData
                                                        .data.count) >
                                                snapshotItemData
                                                    .data.countRequest) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'จำนวนสินค้าเกินจากที่ทางร้านกำหนดไว้ !')));
                                            } else {
                                              print('Save to Order !!!!!!');
                                              showListCartBuy(context, token,
                                                  userId, listCartByItemId);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            child: Center(
                                              child: Text('ชำระเงิน'),
                                            ),
                                          )),
                                    ),
                                  )),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                            'จำนวนสินค้าที่ต้องการขาย : ${snapshotItemData.data.count}/${snapshotItemData.data.countRequest}'),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ],
      );
    }
  }

  Future<int> sumPriceMarket(listGroupData) async {
    int sumPriceMarket = 0;
    sumPriceMarket = listGroupData
        .map((m) => m.priceSell * m.number)
        .reduce((a, b) => a + b);
    return sumPriceMarket;
  }

  void showDialogDelete(BuildContext context, snapShotId, cartDelete) async {
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
                            deleteCart(token, snapShotId, cartDelete);
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

  void deleteCart(token, snapShotId, cartDelete) async {
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

          removeListCart(cartDelete);
          removeListGroupCartByMarket(cartDelete);
          listCartByItemId.remove(cartDelete);

          callBack(listCartByItemId.length);
          callBackMainPage();
        });
      }
    });
  }
}
