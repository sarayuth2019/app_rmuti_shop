import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

class ShowListImageItem extends StatefulWidget{
  ShowListImageItem(this.token, this.itemId);
  final token;
  final itemId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowListImageItem(token,itemId);
  }
}
class _ShowListImageItem extends State{
  _ShowListImageItem(this.token, this.itemId);
  final token;
  final itemId;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return     FutureBuilder(
      future: getImage(itemId),
      builder: (BuildContext context,
          AsyncSnapshot<dynamic> snapshotImage) {
        print(snapshotImage.data.runtimeType);
        if (snapshotImage.data == null) {
          return Container(
              height: 150,
              width: double.infinity,
              decoration: boxDecorationGrey,
              child: Center(child: Text('กำลังโหลดภาพ...')));
        } else {
          return Container(
            height: 150,
            width: double.infinity,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  initialPage: 0,
                  enlargeCenterPage: true,
                  autoPlay: true),
              itemCount: snapshotImage.data.length,
              itemBuilder:
                  (BuildContext context, int index, int realIndex) {
                return Container(
                    child: snapshotImage.data.length == 0
                        ? Container(
                        child: Center(
                            child: Text('กำลังโหลดภาพ...')))
                        : Container(
                        height: 150,
                        width: double.infinity,
                        child: Image.memory(
                            base64Decode(
                                snapshotImage.data[index]),
                            fit: BoxFit.fill)));
              },
            ),
          );
        }
      },
    );
  }
  Future<void> getImage(_itemId) async {
    final urlGetImageByItemId = "${Config.API_URL}/images/";
    var _resData;
    await http.get(
        Uri.parse('${urlGetImageByItemId.toString()}${_itemId.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
        }).then((res) {
      print(res.body);
      Map jsonData = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _statusData = jsonData['status'];
      var _dataImage = jsonData['dataImages'];
      //var _dataId = jsonData['dataId'];
      if (_statusData == 1) {
        _resData = _dataImage;
        //print("jsonData : ${_resData.toString()}");
      }
    });
    print("_resData ${_resData.toString()}");
    return _resData;
  }
}