import 'dart:core';
import 'list_cartData_byUserId.dart';

List<Cart> listGroupCartByMarketId(List<Cart> listCartData, int marketId) {
  List<Cart> listCartGroupByMarket = [];
  var _listCartGroupByMarket = [];
  _listCartGroupByMarket = listCartData
      .where((element) =>
          element.marketId.toString().contains(marketId.toString()))
      .toList();
  listCartGroupByMarket = _listCartGroupByMarket as List<Cart>;
  //print('listGroupCart success : ${listCartGroupByMarket.length}');
  return listCartGroupByMarket;
}

List<Cart> listGroupCartByItemId(List<Cart> listCartData, int itemId) {
  List<Cart> listCartGroupByMarket = [];
  var _listCartGroupByMarket = [];
  _listCartGroupByMarket = listCartData
      .where((element) =>
      element.itemId.toString().contains(itemId.toString()))
      .toList();
  listCartGroupByMarket = _listCartGroupByMarket as List<Cart>;
  //print('listGroupCart success : ${listCartGroupByMarket.length}');
  return listCartGroupByMarket;
}