import 'dart:async';
import 'package:app_rmuti_shop/method/group_cartByMarketId.dart';
import 'package:app_rmuti_shop/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'card_cartByMarketId.dart';


class CartTab extends StatefulWidget {
  CartTab(this.token, this.userId, this.statusTab,this.callBackMainPage);

  final token;
  final userId;
  final String statusTab;
  final callBackMainPage;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartTab(token, userId, statusTab,callBackMainPage);
  }
}

class _CartTab extends State {
  _CartTab(this.token, this.userId, this.statusTab,this.callBackMainPage);

  final token;
  final userId;
  final String statusTab;
  final callBackMainPage;

  var listGroupCartDataByMarket;
  var listMarket = [];
  var _listMarket = [];
  int sumPriceTotal = 0;

  List listOrder = [];

  var i;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print('build listCartByMarketId !!!!!');
    });
  }

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
            snapshot.data.forEach((element) {
              _listMarket.add(element.marketId);
            });
            print('listMarket length : ${listMarket.length}');
            listMarket = _listMarket.toSet().toList();
            //print(listMarket.length);

            return Scaffold(
                body: ListView.builder(
                    itemCount: listMarket.length,
                    itemBuilder: (BuildContext context, indexMarket) {
                      //var _listGroupCart;
                      listGroupCartDataByMarket = listGroupCartByMarketId(snapshot.data,listMarket[indexMarket]);
                      //listGroupCartDataByMarket = _listGroupCart;
                      i = listGroupCartDataByMarket.length;
                     if(i == 0){
                       return Container();
                     }
                     else{
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ListGroupCart(
                             token,
                             listGroupCartDataByMarket,
                             userId,callBack,callBackMainPage
                         ),
                       );
                     }
                    }));
          }
        },
      ),
    );
  }

  void callBack(value){
    setState(() {
      print('value CallBack : ${value.toString()}');
      i = value;
    });
  }

  Future _onRefresh() async {
    Future.delayed(Duration(seconds: 3));
    setState(() {
      listCartByUserId(token, userId, statusTab);
    });
  }
}
