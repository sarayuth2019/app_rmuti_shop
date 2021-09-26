import 'dart:convert';
import 'dart:io';
import 'package:app_rmuti_shop/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:app_rmuti_shop/screens/method/boxdecoration_stype.dart';

class EditAccount extends StatefulWidget {
  EditAccount(this.userData, this.token);

  final userData;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditAccount(userData, token);
  }
}

class _EditAccount extends State {
  _EditAccount(this.userData, this.token);

  final userData;
  final token;

  final urlUpDate = "${Config.API_URL}/User/update";
  final snackBarEdit = SnackBar(content: Text("กำลังบันทึกการแก้ไข..."));
  final snackBarEditSuccess = SnackBar(content: Text("แก้ไขสำเร็จ"));
  final snackBarEditFall = SnackBar(content: Text("แก้ไขผิดพลาด"));

  String? name;
  String? surname;
  String? email;
  String? phoneNumber;
  String? image;
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = userData.name;
    surname = userData.surname;
    email = userData.email;
    phoneNumber = userData.phoneNumber;
    image = userData.image;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "แก้ไขข้อมูลผู้ใช้",
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showAlertSelectImage(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 200,
                  width: 200,
                  child: image == "null"
                      ? Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.blueGrey,
                        )
                      : Image.memory(
                          base64Decode(image!),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อผู้ใช้'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(text: name),
                            onChanged: (text) {
                              name = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('นามสกุล'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(text: surname),
                            onChanged: (text) {
                              surname = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('เบอร์โทร'),
                      Container(
                        decoration: boxDecorationGrey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            controller: TextEditingController(
                                text: phoneNumber.toString()),
                            onChanged: (text) {
                              phoneNumber = text;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  print("save edit");
                  editMarketData();
                },
                child: Text('บันทึก'),
                style: ElevatedButton.styleFrom(primary: Colors.teal)),
          ],
        ),
      ),
    );
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
    var _imageGallery = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1000, imageQuality: 100);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      image = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
    } else {
      return null;
    }
  }

  _onCamera() async {
    print('Select Camera');
    // ignore: deprecated_member_use
    var _imageGallery = await ImagePicker().pickImage(
        source: ImageSource.camera, maxWidth: 1000, imageQuality: 100);
    if (_imageGallery != null) {
      setState(() {
        imageFile = File(_imageGallery.path);
      });
      image = base64Encode(imageFile!.readAsBytesSync());
      Navigator.of(context).pop();
      return image;
    } else {
      return null;
    }
  }

  void editMarketData() {
    print("account ID : ${userData.id.toString()}");
    print("ชื่อ : ${name.toString()}");
    print("นามสกุล : ${surname.toString()}");
    print("อีเมล : ${email.toString()}");
    print("เบอร์โทร : ${phoneNumber.toString()}");
    saveToDB();
  }

  void saveToDB() async {
    ScaffoldMessenger.of(context).showSnackBar(snackBarEdit);
    Map params = Map();
    params['userId'] = userData.id.toString();
    params['imageUser'] = image.toString();
    params['email'] = email.toString();
    params['password'] = userData.password.toString();
    params['name'] = name.toString();
    params['surname'] = surname.toString();
    params['phoneNumber'] = phoneNumber.toString();

    http.post(Uri.parse(urlUpDate), body: params, headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${token.toString()}'
    }).then((res) {
      print(res.body);

      Navigator.of(context).pop();

      Map resBody = jsonDecode(res.body) as Map;
      var _resStatus = resBody['status'];
      print("Sing Up Status : ${_resStatus}");

      setState(() {
        if (_resStatus == 1) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditSuccess);
        } else if (_resStatus == 0) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarEditFall);
          //_snackBarKey.currentState.showSnackBar(singUpFail);
        }
      });
    });
  }
}
