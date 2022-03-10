import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/method/list_notify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotifyPage extends StatefulWidget {
  NotifyPage(this.userId, this.token,this.callBack);

  final int userId;
  final token;
  final callBack;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotifyPage(userId, token,callBack);
  }
}

class _NotifyPage extends State {
  _NotifyPage(this.userId, this.token,this.callBack);

  final int userId;
  final token;
  final callBack;
  final String urlClearAllNotifyByUserId =
      '${Config.API_URL}/UserNotify/deleteByUserId';
  final String urlDeleteNotifyByNotifyId =
      '${Config.API_URL}/UserNotify/deleteId';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: clearAll,
              child: Text(
                'clear all',
                style: TextStyle(color: Colors.teal),
              ))
        ],
      ),
      body: FutureBuilder(
        future: listNotify(token, userId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Center(
                child: Text(
              'ไม่มีรายการแจ้งเตือน',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ));
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, bottom: 8),
                      child: Stack(
                        children: [
                          Container(
                              child: snapshot.data[index].status
                                          .split(" ")[0] ==
                                      "ยืนยันการชำระเงินผิดพลาด"
                                  ? Container(
                                      decoration: boxDecorationGrey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Payment Id : ${snapshot.data[index].payId}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${snapshot.data[index].status.split(" ")[0]}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      '${snapshot.data[index].status.split(" ")[1]} '),
                                                  Text(
                                                    ' ${snapshot.data[index].status.split(" ")[2]}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    '${snapshot.data[index].createDate}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: boxDecorationGrey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Payment Id : ${snapshot.data[index].payId}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${snapshot.data[index].status.split(" ")[0]}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Container(
                                                    child: snapshot.data[index]
                                                                .status
                                                                .split(
                                                                    " ")[0] ==
                                                            'จำนวนผู้ลงทะเบียนครบแล้ว'
                                                        ? Container()
                                                        : Text(
                                                            'จำนวนเงิน : ${snapshot.data[index].amount} บาท'))
                                              ],
                                            ),
                                            Text(
                                                '${snapshot.data[index].status.split(" ")[1]}'),
                                            Row(
                                              children: [
                                                Text(
                                                    '${snapshot.data[index].status.split(" ")[2]}'),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      color: Colors.teal,
                                                    )),
                                                Text(
                                                    '${snapshot.data[index].status.split(" ")[4]}'),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                    '${snapshot.data[index].createDate}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  onDeleteNotifyByNotifyId(
                                      snapshot.data[index].notifyId);
                                },
                                icon: Icon(
                                  Icons.highlight_remove,
                                  color: Colors.red,
                                  size: 16,
                                ),
                              ))
                        ],
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      listNotify(token, userId);
      callBack();
    });
  }

  void onDeleteNotifyByNotifyId(int notifyId) async {
    await http.get(
        Uri.parse(
            '${urlDeleteNotifyByNotifyId.toString()}/${notifyId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      setState(() {
        print(res.body);
        callBack();
      });
    });
  }

  void clearAll() async {
    await http.get(
        Uri.parse(
            '${urlClearAllNotifyByUserId.toString()}/${userId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      setState(() {
        print(res.body);
        callBack();
      });
    });
  }
}
