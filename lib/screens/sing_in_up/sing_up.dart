import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:app_rmuti_shop/screens/sing_in_up/sing_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SingUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingUp();
  }
}

class _SingUp extends State {
  final urlSingUp = "${Config.API_URL}/Register/user";
  final _formKey = GlobalKey<FormState>();
  final _snackBarKey = GlobalKey<ScaffoldState>();
  final singUpSnackBar =
      SnackBar(content: Text("กำลังสมัคสมาชิก กรุณารอซักครู่..."));
  final singUpFail = SnackBar(content: Text("Email นี้มีผู้ใช้แล้ว"));
  bool _checkText = false;
  String? email;
  String? password;
  TextEditingController confirmPass = TextEditingController();
  String? name;
  String? surname;
  String? number;
  File? imageFile;
  String? imageData;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _snackBarKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Sing Up"),
      ),
      body: SingleChildScrollView(
        child: Form(
          // ignore: deprecated_member_use
          autovalidate: _checkText,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showAlertSelectImage(context);
                    },
                    child: Container(
                      child: imageData == null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 200,
                                width: 200,
                                color: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                child: Image.memory(
                                  base64Decode(imageData!),
                                  fit: BoxFit.fill,
                                  height: 200,
                                  width: 200,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  maxLength: 32,
                  validator: validateEmail,
                  onSaved: (String? _text) {
                    email = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Password"),
                  maxLength: 12,
                  obscureText: true,
                  validator: validatePassword,
                  controller: confirmPass,
                  onSaved: (String? _text) {
                    password = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Confirm Password"),
                  maxLength: 12,
                  obscureText: true,
                  validator: validateConfirmPassword,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "ชื่อ"),
                  maxLength: 32,
                  validator: validateName,
                  onSaved: (String? _text) {
                    name = _text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "นามสกุล"),
                  maxLength: 32,
                  validator: validateName,
                  onSaved: (String? _text) {
                    surname = _text;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(hintText: "เบอร์โทรติดต่อ"),
                  validator: validateNumber,
                  onSaved: (String? _num) {
                    number = _num;
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: onSingUp,
                  child: Text(
                    "Sing up",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.length == 0) {
      return "กรุณากรอกอีเมล";
    } else if (!regExp.hasMatch(value)) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอก Password";
    } else if (text.length < 6) {
      return "กรุณากรอก Password 6-12";
    } else if (text.length > 12) {
      return "กรุณากรอก Password 6-12 ตัว";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอก Confirm Password";
    } else if (text != confirmPass.text) {
      return "กรุณากรอก Password ให้ตรงกัน";
    } else {
      return null;
    }
  }

  String? validateName(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกชื่อ";
    } else {
      return null;
    }
  }

  String? validateSurName(String? text) {
    if (text!.length == 0) {
      return "กรุณากรอกนามสกุล";
    } else {
      return null;
    }
  }

  String? validateNumber(String? text) {
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(text!)) {
      return "กรุณากรอกเบอร์ติดต่อให้ถูกต้อง";
    } else {
      return null;
    }
  }

  void _showAlertSelectImage(BuildContext context) async {
    print('Show Alert Dialog Image !');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Choice'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      child: GestureDetector(
                          child: Text('Gallery'), onTap: _onGallery)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: GestureDetector(
                          child: Text('Camera'), onTap: _onCamera)),
                ],
              ),
            ),
          );
        });
  }

  _onGallery() async {
    print('Select Gallery');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.gallery,maxWidth: 1000,imageQuality: 100);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
    } else {
      return null;
    }
  }

  _onCamera() async {
    print('Select Camera');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker()
        .getImage(source: ImageSource.camera,maxWidth: 1000,imageQuality: 100);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return imageData;
    } else {
      return null;
    }
  }

  void onSingUp() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(singUpSnackBar);
      //_snackBarKey.currentState.showSnackBar(singUpSnackBar);
      _formKey.currentState!.save();
      print(email);
      print(password);
      print(name);
      print(number);
      saveToDB();
    } else {
      setState(() {
        _checkText = true;
      });
    }
  }

  void saveToDB() async {
    Map params = Map();
    params['imageUser'] = imageData.toString();
    params['email'] = email.toString();
    params['password'] = password.toString();
    params['name'] = name.toString();
    params['surname'] = surname.toString();
    params['phoneNumber'] = number.toString();

    http.post(Uri.parse(urlSingUp), body: params).then((res) {
      print(res.body);
      Map resBody = jsonDecode(res.body) as Map;
      var _resStatus = resBody['status'];
      print("Sing Up Status : ${_resStatus}");

      setState(() {
        if (_resStatus == 1) {
          Navigator.pop(
              context, MaterialPageRoute(builder: (context) => SingIn()));
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(singUpFail);
          //_snackBarKey.currentState.showSnackBar(singUpFail);
        }
      });
    });
  }
}
