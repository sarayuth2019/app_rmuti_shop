import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class ReviewProductPage extends StatefulWidget {
  ReviewProductPage(this.token, this.userId, this.marketId,this.paymentData);

  final token;
  final int userId;
  final int marketId;
  final paymentData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReviewProductPage(token, userId, marketId,paymentData);
  }
}

class _ReviewProductPage extends State {
  _ReviewProductPage(this.token, this.userId, this.marketId,this.paymentData);

  final token;
  final int userId;
  final int marketId;
  final paymentData;

  final snackBarOnReview = SnackBar(content: Text("กำลังบันทึกการรีวิว..."));
  final snackBarOnReviewSuccess =
      SnackBar(content: Text("สำเร็จ ขอบคุณสำหรับการรีวิว !"));
  final snackBarOnReviewFall = SnackBar(content: Text("ผิดพลาด !"));
  final urlSaveReview = "${Config.API_URL}/Review/save";
  final String urlSavePay = '${Config.API_URL}/Pay/save';
  TextEditingController content = TextEditingController();
  double _rating = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.teal),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Card(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemCount: 5,
                      initialRating: _rating,
                      minRating: 1,
                      maxRating: 5,
                      allowHalfRating: false,
                      itemBuilder: (context, _ratingCount) => Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                          print(_rating);
                        });
                      },
                    ),
                    Text("${_rating.toString()}")
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: content,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "บอกคนอื่นว่าทำไม 'ถูกใจ' ร้านค้านี้",
                        border: InputBorder.none),
                  ),
                ),
                ElevatedButton(
                  child: Text("ให้คะแนนรีวิว"),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: saveReviewToDB,
                )
              ],
            )),
          ),
        ));
  }

  void saveReviewToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnReview);
    print("userId : ${userId.toString()}");
    print("marketId : ${marketId.toString()}");
    print("rating: ${_rating.toString()}");
    print("content : ${content.text}");

    Map params = Map();
    params['userId'] = userId.toString();
    params['marketId'] = marketId.toString();
    params['rating'] = _rating.toString();
    params['content'] = content.text;
    await http.post(Uri.parse(urlSaveReview), body: params,headers: {HttpHeaders.authorizationHeader:'Bearer ${token.toString()}'}).then((res) {
      print(res.body);
      var jsonDataRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var statusData = jsonDataRes['status'];
      if (statusData == 1) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarOnReviewSuccess);
        _saveStatusPayment(paymentData);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarOnReviewFall);
      }
    });
  }
  void _saveStatusPayment(_paymentData) async {
   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กำลังดำเนินการ...')));
    String status = 'รีวิวสำเร็จ';
    print('save pay ....');
    Map params = Map();
    params['payId'] = _paymentData.payId.toString();
    params['userId'] = _paymentData.userId.toString();
    params['marketId'] = _paymentData.marketId.toString();
    params['number'] = _paymentData.number.toString();
    params['itemId'] = _paymentData.itemId.toString();
    params['bankTransfer'] = _paymentData.bankTransfer.toString();
    params['bankReceive'] = _paymentData.bankReceive.toString();
    params['date'] = _paymentData.date.toString();
    params['time'] = _paymentData.time.toString();
    params['amount'] = _paymentData.amount.toString();
    params['lastNumber'] = _paymentData.lastNumber.toString();
    params['status'] = status.toString();
    await http.post(Uri.parse(urlSavePay), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      var resData = jsonDecode(utf8.decode(res.bodyBytes));
      var resStatus = resData['status'];
      if (resStatus == 1) {
        setState(() {
          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('รับสินค้า สำเร็จ')));
        });
      } else {
        print('save fall !');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ชำระเงิน ผิดพลาด !')));
      }
    });
  }
}
