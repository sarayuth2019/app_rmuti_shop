import 'package:app_rmuti_shop/screens/cart/cart_tab/card_cartByItemId.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/screens/method/group_cartByMarketId.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListGroupCart extends StatefulWidget {
  const ListGroupCart(this.token, this.listGroupCartDataByMarket, this.userId);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListGroupCartState(token, listGroupCartDataByMarket, userId);
  }
}

class _ListGroupCartState extends State {
  _ListGroupCartState(this.token, this.listGroupCartDataByMarket, this.userId);

  final token;
  final List<Cart> listGroupCartDataByMarket;
  final int userId;

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
    return Container(
      decoration: boxDecorationGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Market Id : ${listGroupCartDataByMarket[0].marketId}'),
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
                  return CardCartByItemId(
                      token, listCartByItemId, userId);
                }),
          ],
        ),
      ),
    );
  }
}
