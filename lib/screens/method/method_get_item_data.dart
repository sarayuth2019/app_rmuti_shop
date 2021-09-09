import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<_Items?> getItemDataByItemId(token, int itemId) async {
  final String urlGetItemDataByItemId = '${Config.API_URL}/Item/list/item';
  _Items? _items;
  Map params = Map();
  params['id'] = itemId.toString();
  await http.post(Uri.parse(urlGetItemDataByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var itemData = jsonData['data'];
    print(itemData);
   _items = _Items(
     itemData['itemId'],
     itemData['nameItems'],
     itemData['groupItems'],
     itemData['price'],
     itemData['priceSell'],
     itemData['count'],
     itemData['countRequest'],
     itemData['marketId'],
     itemData['dateBegin'],
     itemData['dateFinal'],
     itemData['dealBegin'],
     itemData['dealFinal'],
     itemData['createDate'],);
  });
  print('ItemData : ${_items}');
  return _items;
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

  _Items(this.itemId,
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
