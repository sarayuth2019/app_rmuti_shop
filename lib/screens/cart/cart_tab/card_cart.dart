import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListGroupCart extends StatefulWidget {
  const ListGroupCart(this.token, this.listGroupCartData,this.userId);

  final token;
  final List<Cart> listGroupCartData;
  final int userId;

  @override
  _ListGroupCartState createState() =>
      _ListGroupCartState(token, listGroupCartData,userId);
}

class _ListGroupCartState extends State<ListGroupCart> {
  _ListGroupCartState(this.token, this.listGroupCartData,this.userId);

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
                          width: 20,
                        ),
                        Text(
                            'ราคา : ${listGroupCartData[index].priceSell} บาท'),
                        Container(
                            child: listGroupCartData[index].status ==
                                    'รอชำระเงิน'
                                ? IconButton(
                                    onPressed: () {
                                      _showAlertDeleteCart(context,
                                          listGroupCartData[index].cartId);
                                    },
                                    icon: Icon(
                                      Icons.highlight_remove,
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
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
        .map((e) => e.priceSell)
        .reduce((value, element) => value + element);

    print('ราคารวมทั้งหมด  :  ${sumPriceTotal}');

    sumPriceMarket =
        listGroupData.map((m) => m.priceSell).reduce((a, b) => a + b);

    print('ราคารวมของร้านค้านั้นๆ  :  ${sumPriceMarket}');
    return sumPriceMarket;
  }

  void _showAlertDeleteCart(BuildContext context, snapShotId) async {
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
                            _deleteCart(snapShotId, token);
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

  void _deleteCart(snapShotId, token) async {
    final urlDeleteByCartId = "${Config.API_URL}/Cart/delete";
    Map params = Map();
    params['id'] = snapShotId.toString();
    await http.post(Uri.parse(urlDeleteByCartId), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      var resData = jsonDecode(res.body);
      var statusRes = resData['status'];
      if (statusRes == 0) {
        setState(() {
          print(res.body);
        });
      }
    });
  }
}
