
import 'package:app_rmuti_shop/screens/cart/cart_tab/cart_payment_success_tab.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/cart_tab.dart';
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
        length: 3,
        initialIndex: 0,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(
              labelColor: Colors.teal,
              tabs: [
                Tab(text: statusCartJoin),
                Tab(text: statusCartWaitPayment),
                Tab(text: statusCartSuccessfulPayment,)
              ],
            ),
            body: TabBarView(
              children: [
                CartTab(token, userId, statusCartJoin),
                CartPaymentWaitTab(token, userId),
                CartPaymentSuccessTab(token, userId)
              ],
            ),
          ),
        ));
  }
}
