import 'dart:convert';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/account/edit_account_page.dart';
import 'package:app_rmuti_shop/screens/sing_in_up/sing_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  AccountPage(this.accountID);

  final accountID;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountPage(accountID);
  }
}

class _AccountPage extends State {
  _AccountPage(this.accountID);

  final accountID;
  final String urlSendAccountById = "${Config.API_URL}/User/list/id";
  AccountData? _AccountData;

  @override
  Widget build(BuildContext context) {
    print("user ID : ${accountID.toString()}");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: logout,
                child: Text(
                  "ออกจากระบบ",
                  style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),
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
                    builder: (context) => EditAccount(_AccountData)));
          },
        ),
        body: FutureBuilder(
          future: sendDataMarketByUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              print('snapshotData : ${snapshot.data}');
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 200,
                        width: 200,
                        child: snapshot.data.image == "null"
                            ? Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.blueGrey,
                        )
                            : Image.memory(
                          base64Decode(snapshot.data.image!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Account ID : ${snapshot.data.id}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อผู้ใช้ : ${snapshot.data.name} ${snapshot.data.surname}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "อีเมล : ${snapshot.data.email}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "เบอร์ติดต่อ : ${snapshot.data.phone_number}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  Future<AccountData> sendDataMarketByUser() async {
    Map params = Map();
    params['id'] = accountID.toString();
    await http.post(Uri.parse(urlSendAccountById), body: params).then((res) {
      print("Send Market Data...");
      print(res.body);
      Map _jsonRes = jsonDecode(utf8.decode(res.bodyBytes)) as Map;
      var _dataAccount = _jsonRes['data'];
      print("data Market : ${_dataAccount.toString()}");
      _AccountData = AccountData(
          _dataAccount['userId'],
          _dataAccount['password'],
          _dataAccount['name'],
          _dataAccount['surname'],
          _dataAccount['email'],
          _dataAccount['phoneNumber'],
          _dataAccount['dateRegister'],
          _dataAccount['imageUser']);
      print("market data : ${_AccountData}");
    });
    return _AccountData!;
  }

  Future logout() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.clear();
    print("account logout ! ${_accountID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}

class AccountData {
  final int id;
  final String password;
  final String name;
  final String surname;
  final String email;
  final String phone_number;
  final String dateRegister;
  final String image;

  AccountData(this.id, this.password, this.name, this.surname, this.email,
      this.phone_number, this.dateRegister, this.image);
}
