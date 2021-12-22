import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/home/home_page.dart';
import 'package:http/http.dart' as http;

Future<Items?> getItemDataByItemId(token, int itemId) async {
  final String urlGetItemDataByItemId = '${Config.API_URL}/Item/list/item';
  Items? _items;
  Map params = Map();
  params['id'] = itemId.toString();
  await http.post(Uri.parse(urlGetItemDataByItemId), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    var jsonData = jsonDecode(utf8.decode(res.bodyBytes));
    var itemData = jsonData['data'];
    print(itemData);
    _items = Items(
      itemData['itemId'],
      itemData['nameItems'],
      itemData['groupItems'],
      itemData['price'],
      itemData['priceSell'],
      itemData['count'],
      itemData['size'],
      itemData['colors'],
      itemData['countRequest'],
      itemData['marketId'],
      itemData['dateBegin'],
      itemData['dateFinal'],
      itemData['dealBegin'],
      itemData['dealFinal'],
      itemData['createDate'],
    );
  });
  print('ItemData : ${_items}');
  return _items;
}

