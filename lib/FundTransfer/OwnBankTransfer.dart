import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:safeSoftware/FundTransfer/FundTransfer.dart';
import 'package:safeSoftware/FundTransfer/Receipt.dart';
import 'package:safeSoftware/FundTransfer/bloc/bloc.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnBankTransfer extends StatefulWidget {
  @override
  _OwnBankTransferState createState() => _OwnBankTransferState();
}

class _OwnBankTransferState extends State<OwnBankTransfer> {
  TextEditingController mob = TextEditingController(),
      accNo = TextEditingController(),
      name = TextEditingController(),
      amt = TextEditingController();
  String userName, userAcc = "", userId, userBal = "";
  bool mobVal = false, accNoVal = false, nameVal = false, amtVal = false;

  List accNos = List();
  String payerName = "";
  double amtBoxSize = 70.0;
  int toGroupValue = 0;

  GlobalKey toKey = GlobalKey();

  FocusNode _mobFocusNode = FocusNode();

  ScrollController _customScrollController = ScrollController();

  SharedPreferences preferences;

  TransferBloc _transferBloc = TransferBloc();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  double _minTransferAmt = 0.0, _maxTransferAmt = 0.0;

  Map<String, dynamic> _referanceNo = Map();

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
                      "Own Bank Transfer",
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
                          Icon(
                            Icons.person,
                            size: 56.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          TextView(
                            "Paying ${payerName == null || payerName.isEmpty ? "____" : payerName}",
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
                        Row(
                          key: toKey,
                          children: [
                            TextView(
                              "To",
                              size: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 20.0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: EditTextBordered(
                                  controller: mob,
                                  hint: "Enter payer mobile no.",
                                  errorText: mobVal ? "Mobile number is invalid" : null,
                                  keyboardType: TextInputType.number,
                                  focusNode: _mobFocusNode,
                                  obscureIcon: InkWell(
                                    onTap: () {
                                      if (mob.text.isNotEmpty && !mobVal) {
                                        _transferBloc.add(FetchCustomerAccNo(mob.text));
                                      } else {
                                        GlobalWidgets()
                                            .showSnackBar(_scaffoldKey, "Mobile number is invalid");
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius: 3,
                                                spreadRadius: 2.0,
                                                offset: Offset(1.5, 1.5))
                                          ]),
                                      child: Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                                    ),
                                  ),
                                  onChange: (value) {
                                    setState(() {
                                      mobVal = value.trim().length != 10;
                                    });
                                  }),
                            ),
                          ],
                        ),
                        BlocListener<TransferBloc, TransferState>(
                            cubit: _transferBloc,
                            listener: (context, snapshot) {
                              if (snapshot is CustAccNoResponse) {
                                setState(() {
                                  if (snapshot.response["Table"][0]["ACCNO"] == "N") {
                                    mobVal = true;
                                    GlobalWidgets()
                                        .showSnackBar(_scaffoldKey, "Mobile number does not exist");
                                  } else {
                                    accNos = snapshot.response["Table"];
                                    payerName = snapshot.response["Table"][0]["Cust_Name"];
                                  }
                                });
                              }
                            },
                            child: accNos.length > 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: accNos.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile(
                                        value: index,
                                        groupValue: toGroupValue,
                                        onChanged: (value) {
                                          setState(() {
                                            toGroupValue = value;
                                          });
                                        },
                                        title: TextView(
                                          accNos[index]["ACCNO"],
                                          size: 24,
                                        ),
                                        subtitle: TextView(
                                          "SB INDIVIDUAL",
                                          size: 12.0,
                                        ),
                                      );
                                    },
                                  )
                                : Container()),
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
                    print("object __ ${snapshot.response["Table"][0]["Column1"]}");
                    if (snapshot.response["Table"][0]["Column1"].toString().toLowerCase() == 'y') {
                      bool isLoading = false;
                      String _pass, _otp;
                      GlobalWidgets().proceedToPaymentModal(
                        context,
                        getValue: (passVal, otpVal) {
                          setState(() {
                            _pass = passVal;
                            _otp = otpVal;
                          });
                        },
                        actionButton: CustomRaisedButton(
                            loadingValue: isLoading,
                            buttonText: "PAY",
                            onPressed: isLoading
                                ? null
                                : () async {
                                    print("passVal $_pass otpCtrl : $_otp");
                                    if (_pass != null && _otp != null) {
                                      Map otpValidateResponse = await RestAPI().get(
                                          APis.fundTransferOTPValidation({"Acc_No": userAcc, "OTP": _otp}));
                                      if (otpValidateResponse["Table"][0]["status"]
                                              .toString()
                                              .toLowerCase() ==
                                          "y") {
                                        Map<String, String> params = {
                                          "Customer_AccNo": userAcc,
                                          "Customer_Mobileno": "",
                                          "ShopAccno": accNos[toGroupValue]["ACCNO"].toString(),
                                          "PayAmount": amt.text,
                                          "st_otp": _otp,
                                          "RefNo": _referanceNo["Table"][0]["Tran_No"]
                                        };

                                        setState(() {
                                          isLoading = true;
                                        });

                                        try {
                                          Map response =
                                              await RestAPI().get<Map>(APis.ownBankFundTrans2(params));

                                          setState(() {
                                            isLoading = false;
                                          });

                                          if (response["Table"][0]["Status"].toString().toLowerCase() ==
                                              "y") {
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) => Receipt(
                                                    widgetBuilder: (context) => FundTransfer(),
                                                    amount: amt.text,
                                                    transID: response["Table"][0]["TranNO"].toString(),
                                                    paidTo: payerName,
                                                    accTo: accNos[toGroupValue]["ACCNO"].toString(),
                                                    accFrom: userAcc,
                                                  ),
                                                ),
                                                (Route<dynamic> route) => false);
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
						                                          payerName)
						                                          .toString(),
				                                          accTo:accNos[toGroupValue]["ACCNO"].toString(),
				                                          accFrom: userAcc,
			                                          ),
		                                          ),
				                                          (Route<dynamic> route) => false,
	                                          );
                                          }
                                        } on RestException catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.of(context).pop();
                                          GlobalWidgets().showSnackBar(_scaffoldKey, e.message);
                                        }
                                      }else{
                                        setState(() {
                                          isLoading = false;
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
                                  }),
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
                        loadingValue: snapshot is LoadingTransferState,
                        onPressed: () async {
                          print("accNos.length :: ${accNos.length}");
                          if (amt.text.isNotEmpty &&
                              int.parse(amt.text) >= _minTransferAmt &&
                              double.parse(amt.text) <= _maxTransferAmt &&
                              double.parse(amt.text) <= double.parse(userBal)) {
                            if (mob.text.isEmpty || !mobVal && accNos.length <= 0) {
                              GlobalWidgets().showSnackBar(_scaffoldKey,
                                  ("Enter Payer Mobile number and select an account to transfer"),
                                  actions: SnackBarAction(
                                      label: "Okay", textColor: Colors.white, onPressed: () {}));
                            } else {
                              print("selectedAccNo :: ${accNos[toGroupValue]["ACCNO"]}");
                              Map<String, dynamic> params = {
                                "Customer_AccNo": userAcc,
                                "BankId": "",
                                "Customer_Mobileno": "",
                                "ShopAccno": accNos[toGroupValue]["ACCNO"],
                                "PayAmount": amt.text,
                              };
                              _transferBloc.add(SendDetails(APis.ownFundTransferOTP(params)));
                              _referanceNo = await RestAPI().get(APis.generateRefID("ownBankTransfer"));

                              print("REFNO$_referanceNo");
                            }
                          } else {
                            if (double.parse(amt.text == "" ? "0" : amt.text) > double.parse(userBal)) {
                              GlobalWidgets().showSnackBar(_scaffoldKey, "Insufficient Balance");
                            } else
                              GlobalWidgets().showSnackBar(_scaffoldKey,
                                  ("Minimum amount is ${StaticValues.rupeeSymbol}$_minTransferAmt and Maximum amount is ${StaticValues.rupeeSymbol}$_maxTransferAmt"));
                          }
                        },
                        buttonText: "PROCEED",
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
      _maxTransferAmt = transDailyLimit["Table"][0]["Max_interfundtranbal"];
//      userBal = balanceResponse["Table"][0]["BalAmt"].toString();
    });
  }
}
