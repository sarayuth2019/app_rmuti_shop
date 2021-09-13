import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/account/edit_account_page.dart';
import 'package:app_rmuti_shop/screens/method/method_listPaymentStatus.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';
import 'package:app_rmuti_shop/screens/sing_in_up/sing_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.userID, this.token);

  final userID;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(userID, token);
  }
}

class _AccountPage extends State {
  _AccountPage(this.userID, this.token);

  final userID;
  final token;

  final String urlSendAccountById = "${Config.API_URL}/User/list";
  UserData? _userData;
  String _status = 'รับสินค้าสำเร็จ';

  @override
  Widget build(BuildContext context) {
    print("user ID : ${userID.toString()}");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: logout,
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditAccount(_userData, token)));
          },
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: sendDataMarketByUser(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  print('snapshotData : ${snapshot.data}');
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.teal,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              width: 60,
                              child: snapshot.data.image == "null"
                                  ? Icon(
                                      Icons.person,
                                      size: 70,
                                      color: Colors.grey,
                                    )
                                  : Image.memory(
                                      base64Decode(snapshot.data.image!),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account ID : ${snapshot.data.id}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "ชื่อผู้ใช้ : ${snapshot.data.name}  ${snapshot.data.surname}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "อีเมล : ${snapshot.data.email}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  "เบอร์ติดต่อ : ${snapshot.data.phoneNumber}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'ประวัติการซื้อ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Expanded(
              child: FutureBuilder(
                future: listPaymentByStatus(token, userID, _status),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.length == 0) {
                    return Center(child: Text('ไม่มีประวัติการซื้อ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: boxDecorationGrey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Id : ${snapshot.data[index].payId}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text('โอนชำระสินค้า : '),
                                      Text(
                                          'item Id ${snapshot.data[index].itemId}'),
                                    ],
                                  ),
                                  Text(
                                      'โอนเงินจำนวน : ${snapshot.data[index].amount} บาท'),
                                  Text(
                                      'โอนจากบัญชี : xxxxxxx ${snapshot.data[index].lastNumber}'),
                                  Text('${snapshot.data[index].bankTransfer}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('สถานะ : '),
                                      Text(
                                        '${snapshot.data[index].status}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Future<UserData> sendDataMarketByUser() async {
    print("Send user Data...");
    await http.post(Uri.parse(urlSendAccountById), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataUser = _jsonRes['data'];
      print("data User : ${_dataUser.toString()}");
      _userData = UserData(
          _dataUser['userId'],
          _dataUser['password'],
          _dataUser['name'],
          _dataUser['surname'],
          _dataUser['email'],
          _dataUser['phoneNumber'],
          _dataUser['dateRegister'],
          _dataUser['imageUser']);
      print("user data : ${_userData}");
    });
    return _userData!;
  }

  Future logout() async {
    final SharedPreferences _userData = await SharedPreferences.getInstance();
    _userData.clear();
    print("user logout ! ${_userData.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}

class UserData {
  final int id;
  final String password;
  final String name;
  final String surname;
  final String email;
  final String phoneNumber;
  final String dateRegister;
  final String? image;

  UserData(this.id, this.password, this.name, this.surname, this.email,
      this.phoneNumber, this.dateRegister, this.image);
}
