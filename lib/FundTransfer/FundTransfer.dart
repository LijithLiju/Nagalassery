import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safeSoftware/FundTransfer/Beneficiary.dart';
import 'package:safeSoftware/FundTransfer/Model/PeopleModel.dart';
import 'package:safeSoftware/FundTransfer/OtherBankTransfer.dart';
import 'package:safeSoftware/FundTransfer/OwnBankTransfer.dart';
import 'package:safeSoftware/MainScreens/MainPage.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TransferHistory.dart';

class FundTransfer extends StatefulWidget {
  const FundTransfer({Key key}) : super(key: key);

  @override
  _FundTransferState createState() => _FundTransferState();

//  @override
//  _FundTransfer2State createState() => _FundTransfer2State();
}

class _FundTransferState extends State<FundTransfer>
    with SingleTickerProviderStateMixin {
  String acc = "", name = "";
  GlobalKey<ScaffoldState> scaffoldKey;
  final _peopleKey = GlobalKey();

  ScrollController _customScrollController = ScrollController();
  SharedPreferences preferences;
  People people = People();

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      acc = preferences?.getString(StaticValues.accNumber) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
    });
  }

  Future<Map> fetchBeneficiary() async {
    var id = preferences?.getString(StaticValues.custID);
    print("ID :: $id");
    return await RestAPI().get(APis.fetchBeneficiary(id));
  }

  Future<Map> deleteBeneficiary(String recieverId) async {
    return await RestAPI().get(APis.deleteBeneficiary(recieverId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    scaffoldKey = GlobalKey();
    loadData();
    super.initState();
  }

  Widget options() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView(
        shrinkWrap: true,
        itemExtent: 80.0,
        scrollDirection: Axis.horizontal,
        children: [
          GlobalWidgets().btnWithText(
              icon: Image.asset(
                "assets/otherBankTransfer.png",
                height: 30.0,
                width: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              name: "Other Bank Transfer",
              onPressed: () {
                Scrollable.ensureVisible(_peopleKey.currentContext,
                    duration: Duration(milliseconds: 350),
                    curve: Curves.easeIn);
              }),

          GlobalWidgets().btnWithText(
              icon: Image.asset(
                "assets/ownBankTransfer.png",
                height: 30.0,
                width: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              name: "Own Bank Transfer",
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OwnBankTransfer()));
              }),
          GlobalWidgets().btnWithText(
              icon: Icon(
                Icons.add,
                size: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              name: "Add Beneficiary",
              onPressed: () async {
                var result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Beneficiary()));
                print("RESULT ::: $result");
                fetchBeneficiary();
                setState(() {});
              }),
          GlobalWidgets().btnWithText(
              icon: Image.asset(
                "assets/transfer2.png",
                height: 30.0,
                width: 30.0,
                color: Theme.of(context).primaryColor,
              ),
              name: "History",
              onPressed: () async {
                var result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TransferHistory()));
                print("RESULT ::: $result");
                fetchBeneficiary();
                setState(() {});
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainPage()));
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _customScrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 1.30,
                  pinned: true,
                  centerTitle: true,
                  title: Text(
                    "Fund Transfer",
                  ),
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30.0,
                      ),
                      onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MainPage()),
                          )),
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    stretchModes: [
                      StretchMode.fadeTitle,
                      StretchMode.blurBackground
                    ],
                    background: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              QrImage(
                                data: acc,
                                version: QrVersions.auto,
                                size: 200.0,
                                foregroundColor: Colors.white,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextView(
                                name,
                                color: Colors.white,
                                size: 18,
                              ),
                              TextView(
                                acc,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.all(20.0),
                                icon: Image.asset(
                                  "assets/qr-code.png",
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  GlobalWidgets().shoppingPay(
                                      scaffoldKey.currentContext,
                                      setState,
                                      scaffoldKey,
                                      acc);
                                }))
                      ],
                    ),
                  ),
                ),
                SliverList(
                  key: _peopleKey,
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20.0)),
                              width: 25.0,
                              height: 5.0,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          LimitedBox(maxHeight: 120.0, child: options()),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 21.0, left: 12.0),
                            child: TextView(
                              "People",
                              size: 20.0,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          FutureBuilder<Map>(
                              future: fetchBeneficiary(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  people = People.fromJson(snapshot.data);
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    primary: true,
                                    shrinkWrap: true,
                                    itemCount: people.table.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Are you sure?"),
                                                  content: TextView(
                                                      "Do you want delete ${people.table[index].recieverName} beneficiary"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: TextView(
                                                          "No",
                                                          size: 14.0,
                                                        )),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        await deleteBeneficiary(
                                                            people.table[index]
                                                                .recieverId
                                                                .round()
                                                                .toString());
                                                        fetchBeneficiary();
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0)),
                                                      color: Theme.of(context)
                                                          .buttonColor,
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: TextView(
                                                        "Yes",
                                                        size: 12.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              SizeRoute(
                                                  page: OtherBankTransfer(
                                                peopleTable:
                                                    people.table[index],
                                              )));
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Card(
                                              elevation: 6.0,
                                              shape: CircleBorder(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Image.asset(
                                                  "assets/otherBankTransfer.png",
                                                  height: 30.0,
                                                  width: 30.0,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            TextView(toBeginningOfSentenceCase(
                                                people.table[index]
                                                    .recieverName)),
                                            TextView(
                                              toBeginningOfSentenceCase(
                                                people
                                                    .table[index].recieverAccno,
                                              ),
                                              size: 10.0,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;

  SizeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}
