import 'package:app_rmuti_shop/screens/cart/cart_tab/show_list_cart_buy.dart';
import 'package:app_rmuti_shop/screens/method/item_data_by_itemId.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardCartByItemId extends StatelessWidget {
  CardCartByItemId(this.token, this.listCartByItemId, this.userId,
      this.callBack, this.showAlertDeleteCart);

  final token;
  final List<Cart> listCartByItemId;
  final int userId;
  final Function callBack;
  final Function showAlertDeleteCart;

  //int sumPriceTotal = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (listCartByItemId.length == 0) {
      return Container();
    } else {
      return Column(
        children: [
          // Text('Market Id : ${listCartByItemId[0].marketId}'),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listCartByItemId.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    children: [
                      //  Text("${listGroupCartData[index].cartId} : "),
                      Text("${listCartByItemId[index].nameItem}"),
                      Text('  x  ${listCartByItemId[index].number}'),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          child: listCartByItemId[index].detail.split(',')[0] ==
                                  'null'
                              ? Container()
                              : Text(
                                  'ขนาด : ${(listCartByItemId[index].detail.split(',')[0]).split(':')[0]}')),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                          child: listCartByItemId[index].detail.split(',')[1] ==
                                  'null'
                              ? Container()
                              : Text(
                                  'สี : ${(listCartByItemId[index].detail.split(',')[1]).split(':')[0]}')),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                          'ราคา : ${listCartByItemId[index].priceSell * listCartByItemId[index].number} บาท'),
                      Container(
                          child: listCartByItemId[index].status == 'รอชำระเงิน'
                              ? IconButton(
                                  onPressed: () {
                                    print(
                                        'cartId delete : ${listCartByItemId[index].cartId}');
                                    showAlertDeleteCart(
                                        context,
                                        listCartByItemId[index].cartId,
                                        listCartByItemId[index]);
                                  },
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    size: 16,
                                    color: Colors.red,
                                  ))
                              : Container()),
                    ],
                  ),
                ],
              );
            },
          ),
          FutureBuilder(
            future: listItemDataByItemId(token, listCartByItemId[0].itemId),
            builder: (BuildContext context,
                AsyncSnapshot<dynamic> snapshotItemData) {
              if (snapshotItemData.data == null) {
                return Text('กำลังโหลด...');
              } else {
                DateTime _dayNow = DateTime.now();
                var stringDealFinal =
                    '${snapshotItemData.data.dealFinal.split('/')[2]}-${snapshotItemData.data.dealFinal.split('/')[1]}-${snapshotItemData.data.dealFinal.split('/')[0]}';
                DateTime _dealFinal = DateTime.parse(stringDealFinal);
                return Column(
                  children: [
                    Container(
                        child: snapshotItemData.data.count ==
                                snapshotItemData.data.countRequest
                            ? Text('* จำนวนผู้ลงทะเบียนครบแล้ว')
                            : Container()),
                    Container(
                        child: _dayNow.isAfter(
                                    _dealFinal.add(Duration(days: 1))) ==
                                true
                            ? Text('* สิ้นสุดระยะเวลาการลงทะเบียนแล้ว')
                            : Container()),
                    Row(
                      children: [
                        FutureBuilder(
                          future: sumPriceMarket(listCartByItemId),
                          builder:
                              (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.data == null) {
                              return Text('กำลังโหลด...');
                            } else {
                              return Text('ราคารวม : ${snapshot.data} บาท');
                            }
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: snapshotItemData.data.count ==
                                        snapshotItemData.data.countRequest ||
                                    _dayNow.isAfter(_dealFinal
                                            .add(Duration(days: 1))) ==
                                        true
                                ? Card(
                                    color: Colors.red,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'ไม่สามารถชำระเงินได้',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      height: 20,
                                      width: 90,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.teal),
                                          onPressed: () {
                                            print(
                                                '${listCartByItemId.map((e) => e.number).reduce((a, b) => a + b) + (snapshotItemData.data.count)}/${snapshotItemData.data.countRequest}');
                                            if (listCartByItemId
                                                        .map((e) => e.number)
                                                        .reduce(
                                                            (a, b) => a + b) +
                                                    (snapshotItemData
                                                        .data.count) >
                                                snapshotItemData
                                                    .data.countRequest) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'จำนวนสินค้าเกินจากที่ทางร้านกำหนดไว้ !')));
                                            } else {
                                              print('Save to Order !!!!!!');
                                              showListCartBuy(context, token,
                                                  userId, listCartByItemId);
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            child: Center(
                                              child: Text('ชำระเงิน'),
                                            ),
                                          )),
                                    ),
                                  )),
                      ],
                    ),
                    Text('จำนวนผู้ลงทะเบียน : ${snapshotItemData.data.count}/${snapshotItemData.data.countRequest}')
                  ],
                );
              }
            },
          ),
        ],
      );
    }
  }

  Future<int> sumPriceMarket(listGroupData) async {
    int sumPriceMarket = 0;
    // print('กำลังรวมราคาของร้านค้านั้นๆ');
/*
    sumPriceTotal = listCartByItemId
        .map((e) => e.priceSell * e.number)
        .reduce((value, element) => value + element);

 */
    // print('ราคารวมทั้งหมด  :  ${sumPriceTotal.toString()}');

    sumPriceMarket = listGroupData
        .map((m) => m.priceSell * m.number)
        .reduce((a, b) => a + b);

    // print('ราคารวมของร้านค้านั้นๆ  :  ${sumPriceMarket.toString()}');
    return sumPriceMarket;
  }
}
