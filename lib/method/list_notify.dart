import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<_Notify>> listNotify(token, int userId) async {
  final String urlListNotifyByUserId = '${Config.API_URL}/UserNotify/list/user';
  List<_Notify> listNotify = [];
  Map params = Map();
  params['user'] = userId.toString();
  await http.post(Uri.parse(urlListNotifyByUserId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var resData = jsonData['data'];
    for (var i in resData) {
      _Notify _notify = _Notify(i['notifyId'], i['amount'], i['status'],
          i['userId'], i['payId'], i['createDate']);
      listNotify.insert(0, _notify);
    }
  });
  return listNotify;
}

class _Notify {
  final int notifyId;
  final int amount;
  final String status;
  final int userId;
  final int payId;
  final String createDate;

  _Notify(this.notifyId, this.amount, this.status, this.userId, this.payId,
      this.createDate);
}
