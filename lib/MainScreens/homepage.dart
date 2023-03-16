import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:safeSoftware/FundTransfer/FundTransfer.dart';
import 'package:safeSoftware/FundTransfer/Receipt1.dart';
import 'package:safeSoftware/MainScreens/AccountMenus.dart';
import 'package:safeSoftware/MainScreens/PassbookMenus.dart';
import 'package:safeSoftware/PayBills/KSEBNKWA.dart';
import 'package:safeSoftware/PayBills/Recharge.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:safeSoftware/WebView/WebViewXPage.dart';
import 'package:safeSoftware/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  SharedPreferences preferences;
  var userId = "", acc = "", name = "", address = "";
  double _iconSize = 25.0;


  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences?.getString(StaticValues.custID) ?? "";
      acc = preferences?.getString(StaticValues.accNumber) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
      address = preferences?.getString(StaticValues.address) ?? "";
      print("userName");
      print(userId);
      print(acc);
      print(name);
    });
  }



  @override
  void initState() {
    loadData();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.width * .90,
            pinned: false,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: [StretchMode.fadeTitle, StretchMode.blurBackground],
              background: Stack(
                children: <Widget>[
                  Positioned(
                      bottom: -30,
                      right: -20,
                      child: Image.asset(
                        "assets/mini-logo.png",
                        width: 150,
                        height: 150,
                        color: Colors.white10,
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextView(
                            "Hello,",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            size: 24.0,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                name ?? "",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: 16,
                              ),
                              TextView(
                                acc ?? "",
                                color: Colors.white,
                                size: 14.0,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                          subtitle: TextView(
                            address ?? "",
                            color: Colors.white,
                            size: 12,
                          ),
                          trailing: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: AssetImage("assets/people.png"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Bank Name change here
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ListTile(
                      title: TextView(
                        appTitle.toUpperCase(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextView(
                  "Banking",
                  fontWeight: FontWeight.bold,
                ),
              ),
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 20),
                children: <Widget>[
                  GlobalWidgets().btnWithText(
                      icon: Image.asset(
                        'assets/account.png',
                        height: _iconSize,
                        width: _iconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      name: "Account",
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => AccountMenus()))),
                  GlobalWidgets().btnWithText(
                      icon: Image.asset(
                        'assets/passbook.png',
                        height: _iconSize,
                        width: _iconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      name: "Passbook",
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => PassbookMenus()))),
                  GlobalWidgets().btnWithText(
                      icon: Image.asset(
                        'assets/fundTransfer.png',
                        height: _iconSize,
                        width: _iconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      name: "Transfer",
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => FundTransfer()))),

                  GlobalWidgets().btnWithText(
                      icon: Image.asset(
                        'assets/shopping.png',
                        height: _iconSize,
                        width: _iconSize,
                        color: Theme.of(context).accentColor,
                      ),
                      name: "Shopping",
                      onPressed: () => GlobalWidgets()
                          .shoppingPay(widget.scaffoldKey.currentContext, setState,widget.scaffoldKey, acc,)),

       


                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextView(
                    "Recharge & Pay Bills",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Visibility(
                visible: false,
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 20),
                  children: <Widget>[
                    GlobalWidgets().btnWithText(
                        icon: Image.asset(
                          'assets/recharge.png',
                          height: _iconSize,
                          width: _iconSize,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Recharge",
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Recharge(
                                  title: "Mobile Recharge",
                                )))),
                    GlobalWidgets().btnWithText(
                        icon: Image.asset(
                          'assets/dishTv.png',
                          height: _iconSize,
                          width: _iconSize,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "DTH",
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Recharge(
                                  title: "DTH Recharge",
                                )))),
                    GlobalWidgets().btnWithText(
                        icon: Image.asset(
                          'assets/electricity.png',
                          height: _iconSize,
                          width: _iconSize,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Electricity",
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => KSEBNKWA(
                                  title: "KSEB",
                                )))),
                    GlobalWidgets().btnWithText(
                        icon: Image.asset(
                          'assets/water.png',
                          height: _iconSize,
                          width: _iconSize,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Water",
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => KSEBNKWA(
                                  title: "KWA",
                                )))),
                    GlobalWidgets().btnWithText(
                        icon: Image.asset(
                          'assets/shopping.png',
                          height: _iconSize,
                          width: _iconSize,
                          color: Theme.of(context).accentColor,
                        ),
                        name: "Shopping",
                        onPressed: () => GlobalWidgets()
                            .shoppingPay(widget.scaffoldKey.currentContext, setState,widget.scaffoldKey, acc,)),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: .5,
                    child: Image.asset(
                      "assets/safesoftware_logo.png",
                      width: 100,
                    ),
                  )),
            ]),
          )
        ],
      ),

    );
  }
}
