import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

void saveCartDataToOrder(token, listCartData, userId) async {
  const String urlSaveCartDataToOrder = '${Config.API_URL}/Order/save';
  List _listCarData = [];
  String stringListCart;
  print('SaveCartData to Order');
  print('listSaveCartDataToOrder length : ${listCartData.length}');
  await listCartData.forEach((value) {
    var _size = value.detail.split(',')[0];
    var _color = value.detail.split(',')[1];
    _listCarData.add('[${_size.toString()},${_color.toString()},${value.priceSell},${value.number}]');
    //_listCarData.add(DetailCartData(_size, _color, value.priceSell, value.number));
    print('value detail : ${_listCarData.map((e) => e.toString())}');
  });

  var _dealBegin =
      '${listCartData[0].dealBegin.split('/')[1]}/${listCartData[0].dealBegin.split('/')[0]}/${listCartData[0].dealBegin.split('/')[2]}';
  var _dealFinal =
      '${listCartData[0].dealFinal.split('/')[1]}/${listCartData[0].dealFinal.split('/')[0]}/${listCartData[0].dealFinal.split('/')[2]}';
  var _dateBegin =
      '${listCartData[0].dateBegin.split('/')[1]}/${listCartData[0].dateBegin.split('/')[0]}/${listCartData[0].dateBegin.split('/')[2]}';
  var _dateFinal =
      '${listCartData[0].dateFinal.split('/')[1]}/${listCartData[0].dateFinal.split('/')[0]}/${listCartData[0].dateFinal.split('/')[2]}';
  print('_dealBegin เริ่ม ลงทะเบียน : ${_dealBegin.toString()}');
  print('_dealFinal สิ้นสุด ลงทะเบียน : ${_dealFinal.toString()}');
  print('_dateBegin เริ่ม รับสินค้า : ${_dateBegin.toString()}');
  print(' _dateFinal สิ้นสุด รับสินค้า : ${_dateFinal.toString()}');

  String statusCart = 'ชำเงินแล้ว';
  Map params = Map();
  params['itemId'] = listCartData[0].itemId.toString();
  params['marketId'] = listCartData[0].marketId.toString();
  params['nameOrder'] = listCartData[0].nameItem.toString();
  //params['number'] = _number.toString();
  //params['price'] = (itemData.price + _sizePrice + _colorPrice).toString();
  //params['priceSell'] = (itemData.priceSell + _sizePrice + _colorPrice).toString();
  params['detail'] = _listCarData.map((e) => e).toString();
  params['status'] = statusCart.toString();
  params['userId'] = userId.toString();
  params['dealBegin'] = _dealBegin.toString();
  params['dealFinal'] = _dealFinal.toString();
  params['dateBegin'] = _dateBegin.toString();
  params['dateFinal'] = _dateFinal.toString();
  http.post(Uri.parse(urlSaveCartDataToOrder), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    print(res.body);
  });
}

class DetailCartData {
  DetailCartData(this.size, this.color, this.price, this.number);

  final String size;
  final String color;
  final int price;
  final int number;
}
