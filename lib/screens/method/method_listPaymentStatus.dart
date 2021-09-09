
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:app_rmuti_shop/config/config.dart';


Future<List<_Payment>> listPaymentByStatus(token,int userId,String status) async {
  final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
  List<_Payment> listPayment = [];
  List<_Payment> listPaymentWait = [];
  Map params = Map();
  params['userId'] = userId.toString();
  await http.post(Uri.parse(urlGetPaymentByUserId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print(jsonData);
    var resData = jsonData['data'];
    for (var i in resData) {
      _Payment _payment = _Payment(
          i['payId'],
          i['status'],
          i['userId'],
          i['marketId'],
          i['itemId'],
          i['amount'],
          i['lastNumber'],
          i['bankTransfer'],
          i['bankReceive'],
          i['date'],
          i['time'],
          i['dataTransfer']);
      listPayment.add(_payment);
    }
    listPaymentWait = listPayment
        .where((element) =>
        element.status.toLowerCase().contains(status.toLowerCase()))
        .toList();
  });
  return listPaymentWait;
}
class _Payment {
  final int payId;
  final String status;
  final int userId;
  final int marketId;
  final int itemId;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  _Payment(
      this.payId,
      this.status,
      this.userId,
      this.marketId,
      this.itemId,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
