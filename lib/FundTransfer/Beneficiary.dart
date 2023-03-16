import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Beneficiary extends StatefulWidget {
  @override
  _BeneficiaryState createState() => _BeneficiaryState();
}

class _BeneficiaryState extends State<Beneficiary> {
  TextEditingController rName = TextEditingController(),
      rMob = TextEditingController(),
      ifsc = TextEditingController(),
      accNo = TextEditingController(),
      accNo1 = TextEditingController(),
      bankName = TextEditingController(),
      bankAddress = TextEditingController();
  bool rNameVal = false,
      rMobVal = false,
      ifscVal = false,
      accNoVal = false,
      accNoVal1 = false,
      bankNameVal = false,
      bankAddressVal = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _isLoading = false;

  TextInputType changeKeyboardAppearence() {
    return ifsc.text.length < 5 ? TextInputType.text : TextInputType.number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
	      centerTitle: true,
        title: Text("Add Beneficiary"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              itemExtent: 75.0,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              children: [
                EditTextBordered(
                    controller: rName,
                    hint: "Enter Receiver Name",
                    errorText: rNameVal ? "Name is invalid" : null,
                    textCapitalization: TextCapitalization.words,
                    onChange: (value) {
                      setState(() {
                        rNameVal = value.trim().length < 3;
                      });
                    }),

                EditTextBordered(
                    controller: ifsc,
                    hint: "Enter IFSC",
                    keyboardType: changeKeyboardAppearence(),
                    errorText: ifscVal ? "IFSC is invalid" : null,
                    textCapitalization: TextCapitalization.characters,
                    onChange: (value) {
                      setState(() {
                        ifscVal = value.trim().length != 11;
                      });
                    }),
                EditTextBordered(
                    controller: accNo,
                    hint: "Enter Account no.",
                    keyboardType: TextInputType.number,
                    errorText: accNoVal ? "Account number is invalid" : null,
                    onChange: (value) {
                      setState(() {
                        accNoVal = value.trim().length < 8;
                      });
                    }),
                EditTextBordered(
                    controller: accNo1,
                    hint: "ReEnter Account no.",
                    keyboardType: TextInputType.number,
                    errorText: accNoVal1 ? "Account number is invalid" : null,
                    onChange: (value) {
                      setState(() {
                        accNoVal1 = value.trim().length < 8;
                      });
                    }),
                EditTextBordered(
                    controller: bankName,
                    hint: "Enter Bank Name",
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    errorText: bankNameVal ? "Bank Name is invalid" : null,
                    onChange: (value) {
                      setState(() {
                        bankNameVal = value.trim().length <= 0;
                      });
                    }),
                Visibility(
                  visible: false,
                  child: EditTextBordered(
                      controller: rMob,
                      hint: "Enter Receiver Mobile no.",
                      keyboardType: TextInputType.number,
                      errorText: rMobVal ? "Number is invalid" : null,
                      onChange: (value) {
                        setState(() {
                          rMobVal = value.trim().length != 10;
                        });
                      }),
                ),
                Visibility(
                  visible: false,
                  child: EditTextBordered(
                      controller: bankAddress,
                      hint: "Enter Bank Address",
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      errorText: bankAddressVal ? "Bank Address is invalid" : null,
                      onChange: (value) {
                        setState(() {
                          bankAddressVal = value.trim().length <= 0;
                        });
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: CustomRaisedButton(
	            loadingValue: _isLoading,
              buttonText:  "Add Beneficiary",
              onPressed: () async {
	              if(accNo.text == accNo1.text){
                  SharedPreferences preference = await SharedPreferences.getInstance();
                  if (rName.text.isNotEmpty &&

                      ifsc.text.isNotEmpty &&
                      accNo.text.isNotEmpty &&
                      bankName.text.isNotEmpty) {
                    print("TRUE ::::");
                    Map<String, String> params = {
                      "CustId": preference.getString(StaticValues.custID),
                      "reciever_name": rName.text,
                      "reciever_mob": rMob.text,
                      "reciever_ifsc": ifsc.text,
                      "reciever_Accno": accNo.text,
                      "BankName": bankName.text,
                      "Receiver_Address": bankAddress.text
                    };
                    try {
                      _isLoading = true;
                      Map response = await RestAPI().get(APis.addBeneficiary(params));
                      _isLoading = true;
                      String status =  response["Table"][0]["status"];
                      GlobalWidgets().showSnackBar(_scaffoldKey, status);
                      if(status == "Success"){
                        Navigator.of(context).pop(true);
                      }
                    } on RestException catch (e) {
                      print(e.toString());
                      GlobalWidgets().showSnackBar(_scaffoldKey, "Something went wrong");
                    }
                  } else {
                    print("FALSE ::::");
                    GlobalWidgets().showSnackBar(_scaffoldKey, "All fields are mandatory");
                  }
                }
	              else{
                  GlobalWidgets().showSnackBar(_scaffoldKey, "Account No Missmatch");
                }

              },
            ),
          )
        ],
      ),
    );
  }
}
