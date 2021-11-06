import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<_ReviewData>> listReviewByMarketId(
    String token, int marketId) async {
  final String urlReviewByItems = '${Config.API_URL}/Review/find/MarketId';
  List<_ReviewData> listReview = [];

  Map params = Map();
  params['marketId'] = marketId.toString();
  print("connect to Api Review...");
  await http.post(Uri.parse(urlReviewByItems), body: params, headers: {
    HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
  }).then((res) {
    print("connect to Api Review Success !");
    Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
    var dataReview = jsonData['data'];
    print(dataReview);

    for (var i in dataReview) {
      _ReviewData _reviewData = _ReviewData(i['reviewId'], i['marketId'],
          i['userId'], i['rating'], i['content'], i['createDate']);
      listReview.insert(0, _reviewData);
      print("list review success");
    }
  });
  return listReview;
}

class _ReviewData {
  _ReviewData(this.reviewId, this.marketId, this.userId, this.rating,
      this.content, this.createDate);

  final int reviewId;
  final int marketId;
  final int userId;
  final double rating;
  final String content;
  final String createDate;
}
