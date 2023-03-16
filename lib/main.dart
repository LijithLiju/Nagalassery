import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeSoftware/MainScreens/Login.dart';
import 'package:safeSoftware/MainScreens/MainPage.dart';
import 'package:safeSoftware/MainScreens/homepage.dart';
import 'package:safeSoftware/Util/util.dart';

void main() => runApp(BankApp());
String appTitle = "NAGALASSERY SCB Passbook";
class BankApp extends StatelessWidget {
//  final Widget _defaultScreen = Receipt(accFrom: "339202010056217",accTo: "1234567890123",amount: "10000",paidTo: "Dithesh Vishalakshan",transID: "PS/258160/200/50041/280PM",);
  final Widget _defaultScreen = Login();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor));
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: child);
        },
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().themeData(),
        home: Scaffold(
          body: _defaultScreen,
        ),
        routes: <String, WidgetBuilder>{
          "/HomePage": (BuildContext context) => HomePage(),
          "/MainPage": (BuildContext context) => MainPage(),
        });
  }
}
