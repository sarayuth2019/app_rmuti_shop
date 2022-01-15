
import 'package:app_rmuti_shop/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/method/group_cartByMarketId.dart';
import 'package:app_rmuti_shop/method/list_cartData_byUserId.dart';
import 'package:app_rmuti_shop/screens/cart/cart_tab/card_cartByItemId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListGroupCart extends StatefulWidget {
  ListGroupCart(
      this.token, this.listGroupCartDataByMarket, this.userId, this.callBack,this.callBackMainPage);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;
  final Function callBack;
  final Function callBackMainPage;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListGroupCartState(
        token, listGroupCartDataByMarket, userId, callBack,callBackMainPage);
  }
}

class _ListGroupCartState extends State {
  _ListGroupCartState(
      this.token, this.listGroupCartDataByMarket, this.userId, this.callBack,this.callBackMainPage);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;
  final Function callBack;
  final Function callBackMainPage;


  int sumPriceTotal = 0;
  var listItemId = [];
  var _listItemId = [];
  var listCartByItemId;

  @override
  Widget build(BuildContext context) {
    ///////////////// ListItemId ////////////////////////
    listGroupCartDataByMarket.forEach((element) {
      _listItemId.add(element.itemId);
    });
    listItemId = _listItemId.toSet().toList();
    print('listItem length : ${listItemId.length}');
    if (listGroupCartDataByMarket.length == 0) {
      return Container();
    } else {
      return Container(
        decoration: boxDecorationGrey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Market Id : ${listGroupCartDataByMarket[0].marketId}'),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listItemId.length,
                  itemBuilder: (BuildContext context, int indexItem) {
                    ///////////////// ListCartByItemId ////////////////////////
                    listCartByItemId = listGroupCartByItemId(
                        listGroupCartDataByMarket, listItemId[indexItem]);
                    print('list CartByItemId : ${listCartByItemId.length}');
                    return CardCartByItemId(token, listCartByItemId, userId,
                        callBack,callBackMainPage);
                  }),
              SizedBox(
                height: 8,
              ),
              /*
              Container(
                height: 25,
                child: Row(
                  children: [
                    Text('ราคาสินค้าทั้งหมด : '),
                    Text(
                        "${listGroupCartDataByMarket.map((e) => e.priceSell * e.number).reduce((value, element) => value + element)} บาท"),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.teal),
                        onPressed: () {
                          showListCartBuy(context, token, userId,
                              listGroupCartDataByMarket);
                        },
                        child: Text('ชำระเงินทั้งหมด')),
                  ],
                ),
              )
              */
            ],
          ),
        ),
      );
    }
  }
}
