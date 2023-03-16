import 'package:flutter/material.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:safeSoftware/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Settings/MpinGenerate.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController userIdCtrl = TextEditingController(),
      oldPasCtrl = TextEditingController(),
      newPassCtrl = TextEditingController();
  bool idValid = false, oldPassValid = false, newPassValid = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SharedPreferences preferences;
  var userId = "", acc = "", name = "", address = "";

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            profile(),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.grey[200],
              height: 1,
              thickness: 1,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextView(
              "Settings",
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              size: 24.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              onTap: () => changePassword(),
              leading: Icon(
                Icons.lock_outline,
                color: Theme.of(context).accentColor,
              ),
              title: TextView(
                "Change Password",
                fontWeight: FontWeight.bold,
                size: 16.0,
              ),
              subtitle: TextView(
                "Change security password",
                size: 12.0,
              ),
            ),
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.grey[200],
              height: 1,
              thickness: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).accentColor,
              ),
              title: TextView(
                "About Us",
                fontWeight: FontWeight.bold,
                size: 16.0,
              ),
              subtitle: TextView(
                "About this App",
                size: 12.0,
              ),
            ),
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.grey[200],
              height: 1,
              thickness: 1,
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MpinGenerate()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.password,
                  color: Theme.of(context).accentColor,
                ),
                title: TextView(
                  "MPin",
                  fontWeight: FontWeight.bold,
                  size: 16.0,
                ),
                subtitle: TextView(
                  "Set and Update Mpin",
                  size: 12.0,
                ),
              ),
            ),
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.grey[200],
              height: 1,
              thickness: 1,
            ),
            ListTile(
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BankApp(),
              )),
              leading: Image.asset(
                "assets/logout.png",
                color: Theme.of(context).accentColor,
                height: 30.0,
                width: 30.0,
              ),
              title: TextView(
                "Logout",
                fontWeight: FontWeight.bold,
                size: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  void changePassword() {
    String isInvalid = "";
    GlobalWidgets().dialogTemplate(
        context: context,
        title: "Change Password",
        barrierDismissible: false,
        actions: [
          StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                    visible: isInvalid.length > 0,
                    child: TextView(
                      isInvalid,
                      color: Colors.red,
                    )),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        userIdCtrl.text = "";
                        oldPasCtrl.text = "";
                        newPassCtrl.text = "";
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextView(
                          "Cancel",
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: idValid || oldPassValid || newPassValid
                          ? null
                          : () async {
                              if (userIdCtrl.text.length > 0 &&
                                  oldPasCtrl.text.length >= 4 &&
                                  newPassCtrl.text.length >= 4) {
                                Map response = await RestAPI().get<Map>(
                                    "${APis.changePassword}${userIdCtrl.text}&old_pin=${oldPasCtrl.text}"
                                    "&new_pin=${newPassCtrl.text}");
                                setState(() {
                                  bool error = response["Table"][0]["Status"].toString().toLowerCase() ==
                                      "invalid user";

                                  if (!error) {
                                    userIdCtrl.text = "";
                                    oldPasCtrl.text = "";
                                    newPassCtrl.text = "";
                                    GlobalWidgets().showSnackBar(
                                        _scaffoldKey, response["Table"][0]["Status"].toString());
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      isInvalid = "Invalid Credentials";
                                    });
                                  }
                                });
                              } else {
                                setState(() {
                                  isInvalid = "Please fill up the fields";
                                });
                              }
                            },
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextView(
                          "Change Password",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: userIdCtrl,
                  hint: "Enter username",
                  errorText: idValid ? "User should not be empty" : null,
                  onChange: (value) {
                    setState(() {
                      idValid = value.trim().length == 0;
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: oldPasCtrl,
                  hint: "Enter current password",
                  errorText: oldPassValid ? "Password length should be 4" : null,
                  obscureText: true,
                  showObscureIcon: true,
                  onChange: (value) {
                    setState(() {
                      oldPassValid = value.trim().length < 4;
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                EditTextBordered(
                  controller: newPassCtrl,
                  hint: "Enter new password",
                  obscureText: true,
                  showObscureIcon: true,
                  errorText: newPassValid ? "Password length should be 4" : null,
                  onChange: (value) {
                    setState(() {
                      newPassValid = value.trim().length < 4;
                      print(newPassValid);
                      isInvalid = "";
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }

  Widget profile() {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage("assets/people.png"),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            name ?? "",
            fontWeight: FontWeight.bold,
            size: 16,
          ),
          TextView(
            acc ?? "",
            size: 14.0,
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
      subtitle: TextView(
        address ?? "",
        size: 12,
      ),
    );
  }
var about =   "Perumanna SCB FRIENDLY offers you information of your account, in just a touch away from anywhere,"
		" anytime. The application allows instant access to your transactions info.\n"
		"You can instantly know your account balance, makes fund transfers and mobile recharges on the move,"
		" real-time and lots more !\n    We provide Features to harness in the palm of your hands.";
}
