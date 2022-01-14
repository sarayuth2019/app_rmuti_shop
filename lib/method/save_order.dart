import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/method/list_cartData_byUserId.dart';
import 'package:app_rmuti_shop/method/save_detail_order.dart';
import 'package:app_rmuti_shop/method/save_payment_data.dart';
import 'package:http/http.dart' as http;

void saveOrder(context,
    token,
    List<Cart> listCartData,
    userId,
    _bankTransferValue,
    _bankReceiveValue,
    _dateTransfer,
    _timeTransfer,
    amount,
    _lastNumber,
    imageFile) async {
  const String urlSaveCartDataToOrder = '${Config.API_URL}/Order/save';
  print('SaveCartData to Order');
  print('listSaveCartDataToOrder length : ${listCartData.length}');

  var statusSaveOrder;

  var _dealBegin =
      '${listCartData[0].dealBegin.split('/')[1]}/${listCartData[0].dealBegin
      .split('/')[0]}/${listCartData[0].dealBegin.split('/')[2]}';
  var _dealFinal =
      '${listCartData[0].dealFinal.split('/')[1]}/${listCartData[0].dealFinal
      .split('/')[0]}/${listCartData[0].dealFinal.split('/')[2]}';
  var _dateBegin =
      '${listCartData[0].dateBegin.split('/')[1]}/${listCartData[0].dateBegin
      .split('/')[0]}/${listCartData[0].dateBegin.split('/')[2]}';
  var _dateFinal =
      '${listCartData[0].dateFinal.split('/')[1]}/${listCartData[0].dateFinal
      .split('/')[0]}/${listCartData[0].dateFinal.split('/')[2]}';
  print('_dealBegin เริ่ม ลงทะเบียน : ${_dealBegin.toString()}');
  print('_dealFinal สิ้นสุด ลงทะเบียน : ${_dealFinal.toString()}');
  print('_dateBegin เริ่ม รับสินค้า : ${_dateBegin.toString()}');
  print(' _dateFinal สิ้นสุด รับสินค้า : ${_dateFinal.toString()}');

  String statusCart = 'ชำเงินแล้ว';
  Map params = Map();
  params['itemId'] = listCartData[0].itemId.toString();
  params['marketId'] = listCartData[0].marketId.toString();
  params['status'] = statusCart.toString();
  params['userId'] = userId.toString();
  params['dealBegin'] = _dealBegin.toString();
  params['dealFinal'] = _dealFinal.toString();
  params['dateBegin'] = _dateBegin.toString();
  params['dateFinal'] = _dateFinal.toString();
  await http.post(Uri.parse(urlSaveCartDataToOrder), body: params, headers: {
    HttpHeaders.authorizationHeader: "Bearer ${token.toString()}"
  }).then((res) {
    print(res.body);
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    statusSaveOrder = resData['status'];
    var dataOrder = resData['data'];
    var orderId = dataOrder['orderId'];
    if (statusSaveOrder == 1) {
      /////////////////// Save Detail Order //////////////////////////
      listCartData.forEach((element) {
        print('save Detail order Id : ${orderId.toString()}');
        saveDetailOrder(token, element, orderId);
      });
      ////////////////// Save Payment ////////////////////////////////////
      savePayment(
          context,
          token,
          orderId,
          listCartData,
          userId,
          _bankTransferValue,
          _bankReceiveValue,
          _dateTransfer,
          _timeTransfer,
          amount,
          _lastNumber,
          imageFile);

    } else {
      print('Save Order fall !!!!!');
    }
  });
}
