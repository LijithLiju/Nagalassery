import 'package:flutter/material.dart';
import 'package:safeSoftware/MainScreens/ChittyLoan.dart';
import 'package:safeSoftware/Passbook/PassbookDPSH.dart';
import 'package:safeSoftware/Util/util.dart';

class PassbookMenus extends StatefulWidget {

  const PassbookMenus({Key key}) : super(key: key);

  @override
  _PassbookMenusState createState() => _PassbookMenusState();
}

class _PassbookMenusState extends State<PassbookMenus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
	      centerTitle: true,
        title: Text("Passbook"),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  childAspectRatio: .8,
                  children: <Widget>[
                    GlobalWidgets().gridWidget(
	                    context: context,
                      imageName: 'assets/deposit.png',
                      name: "Deposit",
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PassbookDPSH(
                                    type: "DP",
                                  ))),
                    ),
                    GlobalWidgets().gridWidget(
	                    context: context,
                      imageName: 'assets/loan.png',
                      name: "Loan",
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChittyLoan(
	                              type: null,
	                              isAccount: false,
                              ))),
                    ),
                    GlobalWidgets().gridWidget(
	                    context: context,
                      imageName: 'assets/chitty.png',
                      name: "Chitty",
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChittyLoan(
                                    type: "MMBS",
                                    isAccount: false,
                                  ))),
                    ),
                    GlobalWidgets().gridWidget(
	                    context: context,
                      imageName: 'assets/share.png',
                      name: "Share",
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PassbookDPSH(
                                    type: "SH",
                                  ))),
                    ),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/safesoftware_logo.png",
                  width: 200,
                ))
          ],
        ),
      ),
    );
  }
}
