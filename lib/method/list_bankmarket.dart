import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<BankMarket>> listBankMarket(token, marketId) async {
  String urlListBankMarket = '${Config.API_URL}/BankMarket/listBankByMarketId';
  List<BankMarket> listBankMarket = [];
  Map params = Map();
  params['marketId'] = marketId.toString();
  await http.post(Uri.parse(urlListBankMarket), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    var resData = jsonDecode(utf8.decode(res.bodyBytes));
    var listBankData = resData['data'];
    //print(listBankData);
    for (var i in listBankData) {
      BankMarket bankMarket = BankMarket(i['bankMarketId'], i['marketId'],
          i['bankAccountName'], i['nameBank'], i['bankNumber'], i['date']);
      listBankMarket.add(bankMarket);
    }
  });
  return listBankMarket;
}

class BankMarket {
  BankMarket(this.bankMarketId, this.marketId, this.bankAccountName,
      this.nameBank, this.bankNumber, this.date);

  final int bankMarketId;
  final int marketId;
  final String bankAccountName;
  final String nameBank;
  final bankNumber;
  final date;
}
