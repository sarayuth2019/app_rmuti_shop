import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_rmuti_shop/config/config.dart';

Future<List<Payment>> listPaymentByStatus(
    token, int userId, String status) async {
  final String urlGetPaymentByUserId = '${Config.API_URL}/Pay/user';
  List<Payment> listPayment = [];
  List<Payment> listPaymentWait = [];
  Map params = Map();
  params['userId'] = userId.toString();
  await http.post(Uri.parse(urlGetPaymentByUserId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    print(jsonData);
    var resData = jsonData['data'];
    for (var i in resData) {
      Payment _payment = Payment(
          i['payId'],
          i['status'],
          i['userId'],
          i['orderId'],
          i['marketId'],
          i['detail'],
          i['amount'],
          i['lastNumber'],
          i['bankTransfer'],
          i['bankReceive'],
          i['date'],
          i['time'],
          i['dataTransfer']);
      listPayment.add(_payment);
    }
    if (status == 'รอดำเนินการ') {
      List<Payment> _listPaymentWait1 = listPayment
          .where((element) =>
              element.status.toLowerCase().contains(status.toLowerCase()))
          .toList();
      List<Payment> _listPaymentWait2 = listPayment
          .where((element) => element.status
              .toLowerCase()
              .contains('ชำระเงินผิดพลาด'.toLowerCase()))
          .toList();
      listPaymentWait = _listPaymentWait1 + _listPaymentWait2;
    } else if (status == "ประวัติการซื้อ") {
      List<Payment> _listPaymentWait1 = listPayment
          .where((element) => element.status
              .toLowerCase()
              .contains('รับสินค้าสำเร็จ'.toLowerCase()))
          .toList();
      List<Payment> _listPaymentWait2 = listPayment
          .where((element) => element.status
              .toLowerCase()
              .contains('รีวิวสำเร็จ'.toLowerCase()))
          .toList();
      listPaymentWait = _listPaymentWait1 + _listPaymentWait2;
    } else {
      listPaymentWait = listPayment
          .where((element) =>
              element.status.toLowerCase().contains(status.toLowerCase()))
          .toList();
    }
  });
  return listPaymentWait;
}

class Payment {
  final int payId;
  final String status;
  final int userId;
  final int orderId;
  final int marketId;
  final detail;
  final int amount;
  final int lastNumber;
  final String bankTransfer;
  final String bankReceive;
  final String date;
  final String time;
  final String dataTransfer;

  Payment(
      this.payId,
      this.status,
      this.userId,
      this.orderId,
      this.marketId,
      this.detail,
      this.amount,
      this.lastNumber,
      this.bankTransfer,
      this.bankReceive,
      this.date,
      this.time,
      this.dataTransfer);
}
