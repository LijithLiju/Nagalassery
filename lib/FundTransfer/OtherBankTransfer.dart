import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:safeSoftware/FundTransfer/FundTransfer.dart';
import 'package:safeSoftware/FundTransfer/Model/PeopleModel.dart';
import 'package:safeSoftware/FundTransfer/Receipt.dart';
import 'package:safeSoftware/FundTransfer/bloc/bloc.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherBankTransfer extends StatefulWidget {
  final PeopleTable peopleTable;

  const OtherBankTransfer({
    Key key,
    @required this.peopleTable,
  }) : super(key: key);

  @override
  _OtherBankTransferState createState() => _OtherBankTransferState();
}

class _OtherBankTransferState extends State<OtherBankTransfer> {
  TextEditingController mob = TextEditingController(),
      accNo = TextEditingController(),
      name = TextEditingController(),
      amt = TextEditingController();
  List paymentType = List();
  bool mobVal = false, accNoVal = false, nameVal = false, amtVal = false;
  List<String> accNos = List();
  double amtBoxSize = 70.0;
  int payModeGroupValue = 0;
  String userName, userAcc = "", userId, userBal = "";
  GlobalKey toKey = GlobalKey();
  TransferBloc _transferBloc = TransferBloc();
  double _minTransferAmt = 0.0, _maxTransferAmt = 0.0;
  FocusNode _mobFocusNode = FocusNode();
  SharedPreferences preferences;
  ScrollController _customScrollController = ScrollController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool isProcessing = false;
  String strDate;

  Map sendOTPParams;

  bool _isLoading = false;
  Map<String, dynamic> _referenceNo = Map();
  @override
  void dispose() {
    _transferBloc?.close();
    super.dispose();
  }

  @override
  void initState() {
    // listen to focus changes
    loadData();

    _mobFocusNode.addListener(() {
      print(
          'focusNode updated: hasFocus: ${_mobFocusNode.hasFocus}  ${MediaQuery.of(context).viewInsets.bottom}');
      if (_mobFocusNode.hasFocus && MediaQuery.of(context).viewInsets.bottom == 0.0)
        Scrollable.ensureVisible(toKey.currentContext,
            duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    });
    super.initState();
  }

  getCurrentDate() {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("tsdknfbsldkj l;kndsfa;ln");
        if (!_mobFocusNode.hasPrimaryFocus) {
          _mobFocusNode.unfocus();
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _customScrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                    centerTitle: true,
                    expandedHeight: MediaQuery.of(context).size.width / .8,
                    pinned: true,
                    stretch: true,
                    title: Text(
                      "Other Bank Transfer",
                    ),
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30.0,
                        ),
                        onPressed: () => Navigator.of(context).pop()),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      collapseMode: CollapseMode.parallax,
                      stretchModes: [StretchMode.fadeTitle, StretchMode.blurBackground],
                      background: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 6.0,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                "assets/otherBankTransfer.png",
                                height: 30.0,
                                width: 30.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextView(
                            "Paying ${widget.peopleTable.recieverName.isEmpty ? "____" : widget.peopleTable.recieverName}",
                            color: Colors.white,
                          ),
                          TextView(
                            "${widget.peopleTable.recieverAccno}",
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: amtBoxSize,
                            child: EditTextBordered(
                                controller: amt,
                                hint: "0",
                                keyboardType: TextInputType.number,
                                color: Colors.white,
                                maxLength: 8,
                                maxLines: 1,
                                hintColor: Colors.white60,
                                size: 56,
                                setDecoration: false,
                                setBorder: false,
                                textAlign: TextAlign.center,
                                textCapitalization: TextCapitalization.words,
                                prefix: TextView(
                                  StaticValues.rupeeSymbol,
                                  size: 24,
                                  color: Colors.white,
                                ),
                                onChange: (value) {
                                  setState(() {
                                    amtVal = value.isEmpty || int.parse(value) < 1;
                                    amtBoxSize = 70 + (value.length * 25).toDouble();
                                    print(amtBoxSize);
                                  });
                                }),
                          ),
                          TextView(
                            "Minimum amount ${StaticValues.rupeeSymbol} $_minTransferAmt",
                            size: 10,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextView(
                            userBal,
                            size: 24,
                            color: Colors.greenAccent,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextView(
                            "Available Balance",
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        TextView(
                          "Payment Mode",
                          size: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FutureBuilder<Map>(
                            future: getPaymentMode(),
                            builder: (context, snapshot) {
                              print("SNAPSHOT :: ${snapshot.data}");
                              if (snapshot.hasData) {
                                paymentType = (snapshot.data["Table"]);
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: paymentType.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      value: index,
                                      groupValue: payModeGroupValue,
                                      onChanged: (value) {
                                        setState(() {
                                          payModeGroupValue = value;
                                        });
                                      },
                                      title: TextView(
                                        paymentType[index]["TYPE_NAME"],
                                        size: 24,
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
                        SizedBox(
                          height: 20.0,
                        ),
                        Divider(
                          color: Colors.grey[400],
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextView(
                          "From",
                          size: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: 1,
                          onChanged: null,
                          title: TextView(
                            userAcc,
                            size: 24,
                          ),
                          subtitle: TextView(
                            "SB INDIVIDUAL",
                            size: 12.0,
                          ),
                        ),
                        SizedBox(height: 100.0),
                      ],
                    ),
                  )
                ]))
              ],
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              left: 0.0,
              child: BlocListener<TransferBloc, TransferState>(
                cubit: _transferBloc,
                listener: (context, snapshot) {
                  if (snapshot is DetailsResponse) {
                    if (snapshot.response["Table"][0]["Status"].toString().toLowerCase() == 'y') {
                      String _pass, _otp;
                      GlobalWidgets().proceedToPaymentModal(
                        context,
                        getValue: (passVal, otpVal) {
                          setState(() {
                            _pass = passVal;
                            _otp = otpVal;
                          });
                        },
                        actionButton: StatefulBuilder(
                          builder: (context, setState) {
                            return CustomRaisedButton(
                                loadingValue: _isLoading,
                                buttonText: "PAY",
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        print("passVal $_pass otpCtrl : $_otp");
                                        if (_pass != null && _otp != null) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          Map otpValidateResponse = await RestAPI().get(
                                              APis.fundTransferOTPValidation(
                                                  {"Acc_No": userAcc, "OTP": _otp}));
                                          if (otpValidateResponse["Table"][0]["status"]
                                                  .toString()
                                                  .toLowerCase() ==
                                              "y") {
                                            Map<String, String> params = {
                                              "CustAccNo": userAcc,
                                              "ReceiverId": widget.peopleTable.recieverId.toString(),
                                              "PaymentMode": "N",
                                              "PayAmount": amt.text,
                                              "OTP": _otp,
                                              "RefNo": _referenceNo["Table"][0]["Tran_No"]
                                            };
                                            Uri _uri = Uri(queryParameters: params);
                                            print("object////// $params\n$_uri");
                                            try {
                                              Map response =
                                                  await RestAPI().get(APis.otherBankFundTrans2(params));
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              strDate = getCurrentDate();
                                              if (response["Table1"][0]["Status"].toString().toLowerCase() ==
                                                  "y") {

                                                print(strDate);
                                                Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) => Receipt(
                                                      widgetBuilder: (context) => FundTransfer(),
                                                      amount: amt.text,
                                                      transID: response["Table1"][0]["TranNO"].toString(),
                                                      paidTo: toBeginningOfSentenceCase(
                                                              widget.peopleTable.recieverName)
                                                          .toString(),
                                                      accTo: widget.peopleTable.recieverAccno.toString(),
                                                      date: strDate,
                                                      accFrom: userAcc,
                                                      from: "transfer",
                                                      name: userName,
                                                    ),
                                                  ),
                                                  (Route<dynamic> route) => false,
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) => Receipt(
                                                      isFailure: true,
                                                      widgetBuilder: (context) => FundTransfer(),
                                                      amount: amt.text,
                                                      transID: "",
                                                      paidTo: toBeginningOfSentenceCase(
                                                              widget.peopleTable.recieverName)
                                                          .toString(),
                                                      accTo: widget.peopleTable.recieverAccno.toString(),
                                                      date: strDate,
                                                      accFrom: userAcc,
                                                      from: "transfer",
                                                      name: userName,
                                                    ),
                                                  ),
                                                  (Route<dynamic> route) => false,
                                                );
                                              }
                                            } on RestException catch (e) {
                                              Navigator.of(context).pop();
                                              GlobalWidgets().showSnackBar(_scaffoldKey, e.message);
                                            }
                                          } else {
                                          setState((){
                                            _isLoading = false;
                                          });
                                            Fluttertoast.showToast(
                                                msg: "Invalid OTP",
                                                toastLength: Toast.LENGTH_SHORT,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white,
                                                fontSize: 16.0);


                                          }
                                        } else {
                                          _pass == null && _otp != null
                                              ? Fluttertoast.showToast(
                                                  msg: "Incorrect password",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black54,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0)
                                              : Fluttertoast.showToast(
                                                  msg: "Password & OTP should not be empty",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.black54,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                        }
                                      });
                          },
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                      GlobalWidgets().showSnackBar(_scaffoldKey, ("Something went wrong please try again"));
                    }
                  }
                },
                child: BlocBuilder<TransferBloc, TransferState>(
                    cubit: _transferBloc,
                    builder: (context, snapshot) {
                      print("snapshot :: $snapshot");
                      return CustomRaisedButton(
                        buttonText: "PROCEED",
                        loadingValue: snapshot is LoadingTransferState,
                        onPressed: () async {
                          if (amt.text.isNotEmpty &&
                              int.parse(amt.text) >= _minTransferAmt &&
                              double.parse(amt.text) <= _maxTransferAmt &&
                              double.parse(amt.text) <= double.parse(userBal)) {
                            Map neftType = paymentType.singleWhere((element) {
                              print("element :: $element");
                              return element["TYPE_NAME"] == paymentType[payModeGroupValue]["TYPE_NAME"];
                            }, orElse: () => null);
                            print("neftType :: $neftType");
                            if (neftType != null && neftType["TYPE_NAME"] == "NEFT") {
                              Map<String, String> params = {
                                "Customer_AccNo": userAcc,
                                "BankId": "",
                                "Customer_Mobileno": "",
                                "ShopAccno": "1",
                                "PayAmount": amt.text,
                              };

                              _referenceNo = await RestAPI().get(APis.generateRefID("OtherBankTransfer"));
                              print("REFRESPONSE $_referenceNo");
                              print("object////// $params\n${APis.checkFundTransferDailyLimit2(params)}");
                              _transferBloc.add(SendDetails(APis.checkFundTransferDailyLimit2(params)));
                            }
                          } else {
                            if (double.parse(amt.text == "" ? "0" : amt.text) > double.parse(userBal)) {
                              GlobalWidgets().showSnackBar(_scaffoldKey, "Insufficient Balance");
                            } else
                              GlobalWidgets().showSnackBar(_scaffoldKey,
                                  ("Minimum amount is ${StaticValues.rupeeSymbol}$_minTransferAmt and Maximum amount is ${StaticValues.rupeeSymbol}$_maxTransferAmt"));
                          }
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences?.getString(StaticValues.accName) ?? "";
      userId = preferences?.getString(StaticValues.custID) ?? "";
    });
    Map balanceResponse = await RestAPI().get(APis.fetchFundTransferBal(userId));
    setState(() {
      userBal = balanceResponse["Table"][0]["BalAmt"].toString();
      userAcc = balanceResponse["Table"][0]["AccNo"].toString();
    });
    Map transDailyLimit = await RestAPI().get(APis.checkFundTransAmountLimit);
    print("transDailyLimit::: $transDailyLimit");
    setState(() {
      _minTransferAmt = transDailyLimit["Table"][0]["Min_fundtranbal"];
      _maxTransferAmt = transDailyLimit["Table"][0]["Max_fundtranbal"];
//      userBal = balanceResponse["Table"][0]["BalAmt"].toString();
    });
  }

  Future<Map> getPaymentMode() async {
    return await RestAPI().get(APis.fetchFundTransferType);
  }
}
