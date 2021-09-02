import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRCode extends StatefulWidget {
  CreateQRCode(this.paymentId);

  final int paymentId;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createElement
    return _CreateQRCode(paymentId);
  }
}

class _CreateQRCode extends State {
  _CreateQRCode(this.paymentId);

  final int paymentId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'โปรดนำไปแสกนที่ร้านค้าที่ลงทะเบียนเพื่อรับสินค้า',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: QrImage(
                data: paymentId.toString(),
                semanticsLabel: '${paymentId.toString()}',
                size: 250,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.teal),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('เสร็จสิ้น'),
            )
          ],
        ),
      ),
    );
  }
}
