import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<_Items?> listItemDataByItemId(token, int itemId) async {
  final urlGetItemDataByItemId = "${Config.API_URL}/Item/list/item";
  _Items? itemData;
  Map params = Map();
  params['id'] = itemId.toString();
  await http.post(Uri.parse(urlGetItemDataByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    //print("listItem By itemId Success");
    Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var _itemData = _jsonRes['data'];
   // print(_itemData);
     _Items _item = _Items(
        _itemData['itemId'],
        _itemData['nameItems'],
        _itemData['groupItems'],
        _itemData['price'],
        _itemData['priceSell'],
        _itemData['count'],
        _itemData['countRequest'],
        _itemData['marketId'],
        _itemData['dateBegin'],
        _itemData['dateFinal'],
        _itemData['dealBegin'],
        _itemData['dealFinal'],
        _itemData['createDate']);
     itemData = _item;
  });
 // print("Item data : ${itemData!.toString()}");
  return itemData!;
}

class _Items {
  final int itemId;
  final String nameItem;
  final int groupItem;
  final int price;
  final int priceSell;
  final int count;
  final int countRequest;
  final int marketId;
  final String dateBegin;
  final String dateFinal;
  final String dealBegin;
  final String dealFinal;
  final String date;

  _Items(
      this.itemId,
      this.nameItem,
      this.groupItem,
      this.price,
      this.priceSell,
      this.count,
      this.countRequest,
      this.marketId,
      this.dateBegin,
      this.dateFinal,
      this.dealBegin,
      this.dealFinal,
      this.date);
}
