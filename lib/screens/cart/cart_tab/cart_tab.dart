
import 'package:app_rmuti_shop/screens/cart/cart_tab/payment_page.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/screens/method/item_data_by_itemId.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/card_cart.dart';
import 'package:app_rmuti_shop/screens/method/group_cartByMarketId.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartTab extends StatefulWidget {
  CartTab(this.token, this.userId, this.statusTab);

  final token;
  final userId;
  final String statusTab;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartTab(token, userId, statusTab);
  }
}

class _CartTab extends State {
  _CartTab(this.token, this.userId, this.statusTab);

  final token;
  final userId;
  final String statusTab;

  var _listGroupCart;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder(
        future: listCartByUserId(token, userId, statusTab),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'ไม่มีรายการ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            );
          } else {
            var listMarket = [];
            var _listMarket = [];
            snapshot.data.forEach((element) {
              _listMarket.add(element.marketId);
            });
            // print(_listMarket.length);
            listMarket = _listMarket.reversed.toSet().toList();
            //print(listMarket.length);

            return Scaffold(
                body: ListView.builder(
                    itemCount: listMarket.length,
                    itemBuilder: (BuildContext context, index) {
                     _listGroupCart = listGroupCartByMarketId(
                          snapshot.data, listMarket[index]);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: boxDecorationGrey,
                          child: Column(
                            children: [
                              ListGroupCart(token, _listGroupCart, userId),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder(
                                  future: listItemDataByItemId(
                                      token, snapshot.data[index].itemId),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshotItemData) {
                                    if (snapshotItemData.data == null) {
                                      return Text('กำลังโหลด...');
                                    } else {
                                      DateTime _dayNow = DateTime.now();
                                      var stringDealFinal =
                                          '${snapshotItemData.data.dealFinal.split('/')[2]}-${snapshotItemData.data.dealFinal.split('/')[1]}-${snapshotItemData.data.dealFinal.split('/')[0]}';
                                      DateTime _dealFinal =
                                          DateTime.parse(stringDealFinal);
                                      return Column(
                                        children: [
                                          Container(
                                              child: snapshotItemData.data.count ==
                                                      snapshotItemData
                                                          .data.countRequest
                                                  ? Text('* จำนวนผู้ลงทะเบียนครบแล้ว')
                                                  : Container()),
                                          Container(
                                              child: _dayNow.isAfter(_dealFinal
                                                          .add(Duration(days: 1))) ==
                                                      true
                                                  ? Text(
                                                      '* สิ้นสุดระยะเวลาการลงทะเบียนแล้ว')
                                                  : Container()),
                                          Container(
                                              child: snapshotItemData.data.count ==
                                                          snapshotItemData
                                                              .data.countRequest ||
                                                      _dayNow.isAfter(_dealFinal.add(
                                                              Duration(days: 1))) ==
                                                          true
                                                  ? Card(
                                                      color: Colors.red,
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            'ไม่สามารถชำระเงินได้',
                                                            style: TextStyle(
                                                                color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      Colors.teal),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        PayPage(
                                                                            token,
                                                                            userId,
                                                                            snapshot.data[
                                                                                index])));
                                                          },
                                                          child: Container(
                                                            width: double.infinity,
                                                            child: Center(
                                                              child: Text('ชำระเงิน'),
                                                            ),
                                                          )),
                                                    ))
                                        ],
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
          }
        },
      ),
    );
  }

  Future _onRefresh() async {
    Future.delayed(Duration(seconds: 3));
    setState(() {
      listCartByUserId(token, userId, statusTab);
    });
  }
}
