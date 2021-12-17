import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListGroupCart extends StatefulWidget {
  const ListGroupCart(this.token, this.listGroupCartData, this.userId);

  final token;
  final List<Cart> listGroupCartData;
  final int userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListGroupCartState(token, listGroupCartData, userId);
  }
}

class _ListGroupCartState extends State {
  _ListGroupCartState(this.token, this.listGroupCartData, this.userId);

  final token;
  final List<Cart> listGroupCartData;
  final int userId;

  int sumPriceTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Market Id : ${listGroupCartData[0].marketId}'),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: listGroupCartData.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                      //  Text("${listGroupCartData[index].cartId} : "),
                        Text("${listGroupCartData[index].nameItem}"),
                        Text('  x  ${listGroupCartData[index].number}'),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                            child: listGroupCartData[index]
                                        .detail
                                        .split(',')[0] ==
                                    'null'
                                ? Container()
                                : Text(
                                    'ขนาด : ${(listGroupCartData[index].detail.split(',')[0]).split(':')[0]}')),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                            child: listGroupCartData[index]
                                        .detail
                                        .split(',')[1] ==
                                    'null'
                                ? Container()
                                : Text(
                                    'สี : ${(listGroupCartData[index].detail.split(',')[1]).split(':')[0]}')),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            'ราคา : ${listGroupCartData[index].priceSell} บาท'),
                        Container(
                            child:
                                listGroupCartData[index].status == 'รอชำระเงิน'
                                    ? IconButton(
                                        onPressed: () {
                                          print(
                                              'cartId delete : ${listGroupCartData[index].cartId}');
                                          _showAlertDeleteCart(
                                              context,
                                              listGroupCartData[index].cartId,
                                              index);
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
              }),
          FutureBuilder(
            future: sumPriceMarket(listGroupCartData),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Text('กำลังโหลด...');
              } else {
                return Text('ราคารวม : ${snapshot.data} บาท');
              }
            },
          ),
        ],
      ),
    );
  }

  Future<int> sumPriceMarket(List<Cart> listGroupData) async {
    int sumPriceMarket = 0;
    print('กำลังรวมราคาของร้านค้านั้นๆ');

    sumPriceTotal = listGroupCartData
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
          listGroupCartData.removeAt(index);
        });
      }
    });
  }
}
