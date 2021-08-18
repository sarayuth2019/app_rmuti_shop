import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/account/edit_account_page.dart';
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

  @override
  Widget build(BuildContext context) {
    print("user ID : ${userID.toString()}");
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
                  style: TextStyle(
                      color: Colors.teal, fontWeight: FontWeight.bold),
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
                    builder: (context) => EditAccount(_userData,token)));
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all()),
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
                                "อีเมล : ${snapshot.data.email}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "ชื่อผู้ใช้ : ${snapshot.data.name}  ${snapshot.data.surname}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "เบอร์ติดต่อ : ${snapshot.data.phoneNumber}",
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
