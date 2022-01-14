import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<Detail>> getDetailOrder(token, int orderId) async {
  final String urlGetItemByItemId =
      '${Config.API_URL}/DetailOrder/listByOrderId';
  List<Detail> listDetail = [];

  Map params = Map();
  params['orderId'] = orderId.toString();

  await http.post(
      Uri.parse(urlGetItemByItemId),body: params,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
      }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var dataDetail = resData['data'];
    for (var i in dataDetail) {
      Detail detail = Detail(i['orderDetailId'], i['orderId'], i['nameItem'],
          i['color'], i['size'], i['number'], i['price']);
      listDetail.add(detail);
    }
  });
  return listDetail;
}

class Detail {
  Detail(this.orderDetailId, this.orderId, this.nameItem, this.color, this.size,
      this.number, this.price);

  final int orderDetailId;
  final int orderId;
  final String nameItem;
  final String color;
  final String size;
  final int number;
  final int price;
}
