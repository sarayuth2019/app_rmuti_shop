
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/account/review_market_page.dart';
import 'package:app_rmuti_shop/screens/method/method_listPaymentStatus.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReceivedProductSuccessTab extends StatefulWidget {
  ReceivedProductSuccessTab(this.token, this.userId);

  final token;
  final userId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReceivedProductSuccessTab(token, userId);
  }
}

class _ReceivedProductSuccessTab extends State {
  _ReceivedProductSuccessTab(this.token, this.userId);

  final token;
  final userId;

  final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
  final String urlGetPayImage = '${Config.API_URL}/ImagePay/listId';
  String _status = 'รับสินค้าสำเร็จ';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder(
          future: listPaymentByStatus(token, userId, _status),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print(snapshot.data);
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  'ไม่มีรายการ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              );
            } else {
              return Scaffold(
                body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Id : ${snapshot.data[index].payId}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text('โอนชำระสินค้า : '),
                                  Text(
                                      'item Id ${snapshot.data[index].itemId}'),
                                ],
                              ),
                              Text(
                                  'โอนเงินจำนวน : ${snapshot.data[index].amount} บาท'),
                              Text(
                                  'โอนจากบัญชี : xxxxxxx ${snapshot.data[index].lastNumber}'),
                              Text('${snapshot.data[index].bankTransfer}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('สถานะ : '),
                                  Text(
                                    '${snapshot.data[index].status}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),

                                  Icon(Icons.arrow_forward),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewProductPage(
                                                      token,
                                                      userId,
                                                      snapshot
                                                          .data[index].marketId,
                                                      snapshot.data[index])));
                                    },
                                    child: Text('รีวิวร้านค้า'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
    );
  }

  Future<void> _onRefresh() async {
    Future.delayed(Duration(seconds: 3));
    setState(() {
      listPaymentByStatus(token, userId, _status);
    });
  }
}
