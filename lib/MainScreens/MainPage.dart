import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeSoftware/MainScreens/AccountMenus.dart';
import 'package:safeSoftware/MainScreens/homepage.dart';
import 'package:safeSoftware/Setting.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:safeSoftware/main.dart';
import 'package:safeSoftware/speechRecognition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PassbookMenus.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int bottomNavigationIndex = 1;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String acc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
    //  resizeToAvoidBottomPadding: true,
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).primaryColor,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              bottomNavigationIndex = index;
            });
          },
          currentIndex: bottomNavigationIndex,
          elevation: 6.0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          items: _bottomNavigationItem()),
    //  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          heyBank();
//				    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VoiceCommander()));
        },
        mini: true,
        child: Icon(Icons.mic),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: bottomNavigationIndex,
          children: [
            Settings(),
            HomePage(
              scaffoldKey: _scaffoldKey,
            ),
            Container()
          ],
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationItem() {
    return [
      BottomNavigationBarItem(
          icon: Image.asset(
            "assets/settings.png",
            height: 25.0,
            width: 25.0,
            color: bottomNavigationIndex == 0 ? Theme.of(context).primaryColor : Colors.black,
          ),
          title: TextView("Settings")),
      BottomNavigationBarItem(
          icon: Image.asset(
            "assets/home.png",
            height: 25.0,
            width: 25.0,
            color: bottomNavigationIndex == 1 ? Theme.of(context).primaryColor : Colors.black,
          ),
          title: TextView("Home")),
      BottomNavigationBarItem(
          icon: InkWell(
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BankApp())),
            child: Image.asset(
              "assets/logout.png",
              height: 25.0,
              width: 25.0,
              color: bottomNavigationIndex == 2 ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
          title: TextView(
            "Logout",
            maxLines: 1,
            textAlign: TextAlign.center,
          )),
    ];
  }

  void heyBank() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return VoiceCommander(
              commands: (String commands) async {
                print(commands);
                if (commands.contains("open account")) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountMenus()));
                } else if (commands.contains("get detail")) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PassbookMenus()));
                } else if (commands.toLowerCase().contains("qr scan")) {
                  print("scan");
                  Navigator.pop(context);
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  GlobalWidgets().shoppingPay(
                      context,setState, _scaffoldKey, preferences?.getString(StaticValues.accNumber) ?? "");
                }
              },
            );
          });
        });
  }
}
