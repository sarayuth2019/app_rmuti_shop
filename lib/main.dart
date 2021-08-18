import 'package:app_rmuti_shop/screens/account/account_page.dart';
import 'package:app_rmuti_shop/screens/cart/cart_page.dart';
import 'package:app_rmuti_shop/screens/home/home_page.dart';
import 'package:app_rmuti_shop/screens/notify/notify_page.dart';
import 'package:app_rmuti_shop/screens/sing_in_up/sing_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SingIn()));

class MainPage extends StatefulWidget {
  MainPage(this.accountID, this.token);

  final int accountID;
  final token;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPage(accountID, token);
  }
}

class _MainPage extends State {
  _MainPage(this.userId, this.token);

  final int userId;
  final token;

  final testSnackBar = SnackBar(content: Text("เทสๆสแนคบา"));
  PageController _pageController = PageController();
  int tabNum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Market account ID : ${userId.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(userId, token),
          CartPage(token, userId),
          NotifyPage(userId,token),
          AccountPage(userId, token)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        backgroundColor: Colors.white,
        currentIndex: tabNum,
        onTap: (index) {
          setState(() {
            tabNum = index;
            pageChanged(index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "User"),
        ],
      ),
    );
  }

  void pageChanged(int numPageView) {
    _pageController.jumpToPage(numPageView);
    setState(() {
      tabNum = numPageView;
      print(tabNum);
    });
  }

  Future logout() async {
    final SharedPreferences _accountID = await SharedPreferences.getInstance();
    _accountID.clear();
    print("account logout ! ${_accountID.toString()}");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SingIn()), (route) => false);
  }
}
