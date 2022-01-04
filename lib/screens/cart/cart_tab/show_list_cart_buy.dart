import 'package:app_rmuti_shop/screens/cart/cart_tab/payment_page.dart';
import 'package:app_rmuti_shop/screens/method/list_cartData_byUserId.dart';
import 'package:flutter/material.dart';

void showListCartBuy(
    BuildContext context, token, userId, List<Cart> listCartBuy) async {
  print('Show Alert Dialog ListCart Buy');
  int sumPrice = listCartBuy
      .map((e) => e.priceSell * e.number)
      .reduce((value, element) => value + element);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              'รายการสินค้าที่ต้องการชำระเงิน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 21 * double.parse(listCartBuy.length.toString()),
                    width: 600,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listCartBuy.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Text('${listCartBuy[index].nameItem}'),
                            Text(' : ราคา ${listCartBuy[index].priceSell}'),
                            Text(' x ${listCartBuy[index].number}'),
                            Text(
                                ' = ${listCartBuy[index].priceSell * listCartBuy[index].number} บาท'),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        'ราคารวม : ${sumPrice.toString()} บาท',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PayPage(token, userId, listCartBuy)));
                              },
                              child: Text('ชำระเงิน')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('ยกเลิก')),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
      });
}
