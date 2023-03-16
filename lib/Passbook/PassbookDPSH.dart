import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:safeSoftware/Passbook/depositTransaction.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../REST/RestAPI.dart';
import 'Model/PassbookListModel.dart';

class PassbookDPSH extends StatefulWidget {
  final String type;

  const PassbookDPSH({Key key, this.type}) : super(key: key);

  @override
  _PassbookDPSHState createState() => _PassbookDPSHState();
}

class _PassbookDPSHState extends State<PassbookDPSH> {
  PageController _pageController = PageController(initialPage: 0, keepPage: true, viewportFraction: .90);
  List<PassbookTable> transactionList = List();
  double currentPage = 0;

  Future<List<PassbookTable>> getTransactions1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map res = await RestAPI()
        .get("${APis.otherAccListInfo}${pref.getString(StaticValues.custID)}&Acc_Type=${widget.type}");
    PassbookListModel _transactionModel = PassbookListModel.fromJson(res);
    return _transactionModel.table;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.type.toLowerCase() == "dp" ? "Deposit" : "Share"),
      ),
      body: SafeArea(
          child: FutureBuilder<List<PassbookTable>>(
              future: getTransactions1(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Stack(
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else {
                  if (snapshot.data.length > 0) {
                    transactionList = snapshot.data;
                    return Column(
                      children: <Widget>[
                        DotsIndicator(
                          dotsCount: transactionList.length,
                          position: currentPage,
                          decorator: DotsDecorator(
                            color: Theme.of(context).primaryColor.withAlpha(80),
                            activeColor: Theme.of(context).primaryColor,
                            size: const Size(18.0, 5.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                            activeSize: const Size(18.0, 5.0),
                            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            itemCount: transactionList.length,
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Theme.of(context).accentColor,
                                          Theme.of(context).primaryColor
                                        ]),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black45,
                                              offset: Offset(1.5, 1.5), //(x,y)
                                              blurRadius: 5.0,
                                              spreadRadius: 2.0),
                                        ],
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: ListTile(
                                        title: Column(
                                          children: <Widget>[
                                            ListTile(
                                              dense: true,
                                              isThreeLine: true,
                                              contentPadding: EdgeInsets.all(0.0),
                                              title: TextView(
                                                transactionList[index].accNo,
                                                color: Colors.white,
                                                size: 16.0,
                                                fontWeight: FontWeight.bold,
                                                textAlign: TextAlign.start,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  TextView(
                                                    transactionList[index].schName,
                                                    color: Colors.white,
                                                    textAlign: TextAlign.start,
                                                    size: 12.0,
                                                  ),
                                                  TextView(
                                                    transactionList[index].depBranch,
                                                    color: Colors.white,
                                                    textAlign: TextAlign.start,
                                                    size: 12.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextView(
                                              transactionList[index].balance.toStringAsFixed(2),
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            TextView(
                                              "Available Balance",
                                              color: Colors.white,
                                              size: 13,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DepositShareTransaction(
                                    depositTransaction: transactionList[index],
                                  ),
                                ],
                              );
                            },
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index.floorToDouble();
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Center(
                        child: TextView(
                            "You don't have a ${widget.type == "DP" ? 'deposit' : 'share'} in this bank"),
                      )
                    ],
                  );
                }
              })),
    );
  }
}
