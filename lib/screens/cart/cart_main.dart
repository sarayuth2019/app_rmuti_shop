
import 'package:app_rmuti_shop/screens/cart/cart_tab/cart_payment_success_tab.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/cart_tab.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/received_products_success_tab.dart';
import 'package:app_rmuti_shop/screens/cart/string_status_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_tab/cart_payment_wait_tab.dart';


class CartMain extends StatefulWidget {
  CartMain(this.userId, this.token);

  final userId;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartMain(userId, token);
  }
}

class _CartMain extends State {
  _CartMain(this.userId, this.token);

  final userId;
  final token;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(
              labelColor: Colors.teal,
              tabs: [
                Tab(text: statusAddToCart),
                Tab(text: 'รอตรวจสอบ'),
                Tab(text: 'ชำระเงินสำเร็จ',),
                Tab(text: 'รีวิวร้านค้า',)
              ],
            ),
            body: TabBarView(
              children: [
                CartTab(token, userId, statusAddToCart),
                CartPaymentWaitTab(token, userId),
                CartPaymentSuccessTab(token, userId),
                ReceivedProductSuccessTab(token, userId)
              ],
            ),
          ),
        ));
  }
}

