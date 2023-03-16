import 'package:flutter/material.dart';
import 'package:safeSoftware/MainScreens/Login.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/Util/GlobalWidgets.dart';
import 'package:safeSoftware/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class MpinGenerate extends StatefulWidget {
  const MpinGenerate({Key key}) : super(key: key);

  @override
  _MpinGenerateState createState() => _MpinGenerateState();
}

class _MpinGenerateState extends State<MpinGenerate> {
  TextEditingController mpinCtrl = TextEditingController();
  TextEditingController reMpinCtrl = TextEditingController();
  bool mPin = false;
  bool reMpin = false;
  bool currentMpin = false;
  String str_Ststus;
  String strStatusCode;
  SharedPreferences pref;
  String MPin,custId;
  bool _isLoading = false;

//  SharedPreferences preferences;
  final mpinController = TextEditingController();


  void loadData1() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      MPin = pref?.getString(StaticValues.Mpin) ?? "";
      custId = pref?.getString(StaticValues.custID) ?? "";
    //  strCustName = preferences?.getString(StaticValues.accName) ?? "";


      print("MPIN $MPin");

    });
  }

  @override
  void initState() {
    loadData1();
    setState(() {
      SharedPreferences pref = StaticValues.sharedPreferences;
    //  MPin = pref.getString(StaticValues.Mpin);
    //  print("MPIN : $MPin");
      /*usernameCtrl.text = "nira";
      passCtrl.text = "1234";*/
//      usernameCtrl.text = "vidya";
//      passCtrl.text = "123456";
//      usernameCtrl.text = "9895564690";
//      passCtrl.text = "123456";
    });

    super.initState();
  }

  Future<void> saveMpin() async{
    setState(() {
      _isLoading = true;
    });
    var response = await RestAPI().get(APis.saveMpin(custId,mpinCtrl.text));

    setState(() {
      strStatusCode = response["Table"][0]["STATUSCODE"];
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response["Table"][0]["STATUS"])));

    if(strStatusCode == "1"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BankApp(),
      ));
    }





  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Set MPin"),
            InkWell(
                onTap: (){
                  showAlertDialog(context);
                },
                child: Icon(Icons.delete))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            EditTextBordered(
              controller: mpinCtrl,
              hint: "MPin",
              keyboardType: TextInputType.number,
              errorText: mPin ? "Password length should be 4" : null,
              //   obscureText: true,
              //  showObscureIcon: true,
              onChange: (value) {
                setState(() {
                  mPin = value.trim().length < 4;
                });
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            EditTextBordered(
              controller: reMpinCtrl,
              hint: "Re-enter MPin",
              keyboardType: TextInputType.number,
              errorText: reMpin ? "Password length should be 4" : null,
              //   obscureText: true,
              //   showObscureIcon: true,
              onChange: (value) {
                setState(() {
                  reMpin = value.trim().length < 4;
                });
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 40.0,
              child: RaisedButton(onPressed: () async{


                if(mpinCtrl.text == reMpinCtrl.text){

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                  // await pref.setString(StaticValues.Mpin, "1111");
                  saveMpin();
                 // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Set")));


                  //  Navigator.of(context).pushNamedAndRemoveUntil("/LoginPage",(_)=>false);

                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Miss Match")));
                }


                /*  if(MPin == null){
                  if(mpinCtrl.text == reMpinCtrl.text){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                    // await pref.setString(StaticValues.Mpin, "1111");
                    saveMpin();
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Miss Match")));
                  }
                }
                else{
                  if(MPin == currentMpinCtrl.text){
                    if(mpinCtrl.text == reMpinCtrl.text){

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString(StaticValues.Mpin, mpinCtrl.text);

                      // await pref.setString(StaticValues.Mpin, "1111");
                      saveMpin();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mpin Miss Match")));
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Current MPin Missmatch")));
                  }
                }*/



              },
                child: _isLoading?CircularProgressIndicator():Text(MPin == ""?"Save":"Update",
                  style: TextStyle(
                      color: Colors.white
                  ),),),
            )
          ],
        ),
      ),
    );
  }


  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () async{
                SharedPreferences prefs =  await SharedPreferences.getInstance();
                if(prefs.getString(StaticValues.Mpin) == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No MPin Set")));
                }
                else{
                  prefs.remove(StaticValues.Mpin);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("MPin Deteted")));

                 // Navigator.of(context).pushNamedAndRemoveUntil("/LoginPage",(_)=>false);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Login(),
                  ));
                  Navigator.of(context, rootNavigator: true).pop();


                 /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      BankApp()), (Route<dynamic> route) => false);*/
                }
                // prefs.setString(StaticValues.Mpin, "");

              },
              child: Text("YES")),
          InkWell(
              onTap: (){
                Navigator.of(context, rootNavigator: true).pop();
              //  Navigator.of(context).pop();

              },
              child: Text("NO")),
        ],
      ),

    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete MPin"),
      content: Text("Are you sure want to delete MPin."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

