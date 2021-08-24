import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/cart/pay_page.dart';
import 'package:app_rmuti_shop/screens/cart/string_status_cart.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartTab extends StatefulWidget {
  CartTab(this.cartData, this.token, this.userId, this.statusTab);

  final cartData;
  final token;
  final userId;
  final String statusTab;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartTab(cartData, token, userId, statusTab);
  }
}

class _CartTab extends State {
  _CartTab(this.cartData, this.token, this.userId, this.statusTab);

  final List cartData;
  final token;
  final userId;
  final String statusTab;
  final urlDeleteByCartId = "${Config.API_URL}/Cart/delete";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCartTab = cartData
        .where((element) =>
            element.status.toLowerCase().contains(statusTab.toLowerCase()))
        .toList();
  }

  List? listCartTab;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: ListView.builder(
            itemCount: listCartTab!.length,
            itemBuilder: (BuildContext context, index) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: boxDecorationGrey,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${cartData[index].nameItem}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "จากราคา ${cartData[index].price} บาท"),
                                    Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                        "ลดเหลือ ${cartData[index].priceSell} บาท"),
                                  ],
                                ),
                                Text(
                                  'ควรชำระเงินเพื่อยืนยันการลงทะเบียนภายในวันที่',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${cartData[index].dealBegin}'),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.teal,
                                    ),
                                    Text('${cartData[index].dealFinal}'),
                                  ],
                                ),
                                Text(
                                  'ระยะเวลาการใช้สิทธิ์ลดราคา',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${cartData[index].dateBegin}'),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.teal,
                                    ),
                                    Text('${cartData[index].dateFinal}'),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Container(
                                child: cartData[index].status == statusCartJoin
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.teal),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => PayPage(
                                                      token,
                                                      userId,
                                                      cartData[index])));
                                        },
                                        child: Text('ชำระเงิน'))
                                    : Center(
                                        child: Text(
                                          '${cartData[index].status}',
                                          style: TextStyle(
                                              color: Colors.indigoAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          child: cartData[index].status == statusCartJoin
                              ? IconButton(
                                  onPressed: () {
                                    _showAlertDeleteCart(
                                        context, cartData[index].cartId);
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    color: Colors.red,
                                  ))
                              : Container())),
                ],
              );
            }));
  }

  void _showAlertDeleteCart(BuildContext context, snapShotId) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ต้องการลบรายการนี้ ?'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('ยืนยัน'),
                          onTap: () {
                            _deleteCart(snapShotId);
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

  void _deleteCart(snapShotId) async {
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
