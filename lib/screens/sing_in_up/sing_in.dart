import 'dart:convert';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/main.dart';
import 'package:app_rmuti_shop/screens/sing_in_up/sing_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingIn();
  }
}

class _SingIn extends State {
  final snackBarOnSingIn =
      SnackBar(content: Text("กำลังเข้าสู้ระบบ กรุณารอซักครู่..."));
  final snackBarSingInFail =
      SnackBar(content: Text("กรุณาตรวจสอบ Email หรือ Password"));
  final urlSingIn = "${Config.API_URL}/authorizeUser";

  int? userID;
  var token;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.teal,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.location_searching,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SingUp()));
                        },
                        child: Center(
                          child: Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "RMUTI Shop",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                  child: ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: TextField(
                  controller: email,
                  decoration:
                      InputDecoration(hintText: "Email", border: InputBorder.none),
                ),
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.vpn_key_outlined),
                title: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password", border: InputBorder.none),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: onSingIn,
                  child: Text('Sing in'),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SingUp()));
                  },
                  child: Text('Sing Up'),
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSingIn() {
    ScaffoldMessenger.of(context).showSnackBar(snackBarOnSingIn);
    Map params = Map();
    params['email'] = email.text;
    params['password'] = password.text;
    http.post(Uri.parse(urlSingIn), body: params).then((res) {
      print(res);
      Map resData = jsonDecode(res.body) as Map;
      var _userData = resData['data'];
      setState(() {
        if (_userData == 1) {
          userID = resData['userId'];
          token = resData['token'];
          print("User ID : ${userID}");
          saveUserIDToDevice();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainPage(userID!, token)),
              (route) => false);
        } else if (_userData == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarSingInFail);
        }
      });
    });
  }

  Future saveUserIDToDevice() async {
    final SharedPreferences _userData = await SharedPreferences.getInstance();
    _userData.setInt('userID', userID!);
    _userData.setString('token', token);
    print("save accountID to device : aid ${_userData.toString()}");
  }

  Future autoLogin() async {
    final SharedPreferences _userData = await SharedPreferences.getInstance();
    final _userIDInDevice = _userData.getInt('userID');
    final _tokenInDevice = _userData.getString('token');
    if (_userIDInDevice != null) {
      setState(() {
        userID = _userIDInDevice;
        token = _tokenInDevice;
        print("account login future: accountID ${userID.toString()}");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage(userID!, token)),
            (route) => false);
      });
    } else {
      print("No user login");
    }
  }
}
