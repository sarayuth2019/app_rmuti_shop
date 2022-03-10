
import 'package:app_rmuti_shop/screens/cart/cart_payment_success_tab/cart_payment_success_tab.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/cart_tab.dart';
import 'package:app_rmuti_shop/screens/cart/received_products_tab/received_products_success_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_payment_wait_tab/cart_payment_wait_tab.dart';



class CartMain extends StatefulWidget {
  CartMain(this.userId, this.token,this.callBack);

  final userId;
  final token;
  final callBack;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartMain(userId, token,callBack);
  }
}

class _CartMain extends State {
  _CartMain(this.userId, this.token,this.callBack);

  final userId;
  final token;
  final callBack;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(
              isScrollable: true,
              labelColor: Colors.teal,
              tabs: [
                Tab(text: 'รอชำระเงิน'),
                Tab(text: 'รอตรวจสอบ'),
                Tab(text: 'ชำระเงินสำเร็จ',),
                Tab(text: 'รีวิวร้านค้า',)
              ],
            ),
            body: TabBarView(
              children: [
                CartTab(token, userId,'รอชำระเงิน',callBack),
                CartPaymentWaitTab(token, userId),
                CartPaymentSuccessTab(token, userId),
                ReceivedProductSuccessTab(token, userId)
              ],
            ),
          ),
        ));
  }
}

