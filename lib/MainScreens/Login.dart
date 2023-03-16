import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:safeSoftware/MainScreens/Model/LoginModel.dart';
import 'package:safeSoftware/MainScreens/Register.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:safeSoftware/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  int indexPage = 0;
  PageController _pageController = PageController(initialPage: 1);
  AnimationController _animationController, _floatingAnimationController;
  Animation<double> _animation, _floatingAnimation;
  static const int pageCtrlTime = 550;
  static const _animationCurves = Curves.fastLinearToSlowEaseIn;
  static const _pageCurves = Curves.easeIn;
  GlobalKey _regToolTipKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SharedPreferences preferences;
  String MPin,strCustName;
  String version = "";

  void reverseAnimate() {
    Future.delayed(Duration(milliseconds: pageCtrlTime), () {
      _animationController.reverse();
      _floatingAnimationController.reverse();
    });
  }

  void checkVersionCompatible() async {
    Map<String, dynamic> versionMap = await RestAPI().get(APis.mobileGetVersion);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();



    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    setState(() {
      version = packageInfo.version;
    });

    String buildNumber = packageInfo.buildNumber;
    print("VersionNumber$buildNumber");
    print("appName $appName"
        " packageName $packageName"
        " version $version"
        " buildNumber $buildNumber");
   // print("VERSION${version}");
    print("VERSION1 $buildNumber");
    print("VERSION2 ${(versionMap["Table"][0]["Ver_Code"]as double).round().toString()}");

   /* if (versionMap["Table"][0]["Ver_Name"].toString() != version &&
        versionMap["Table"][0]["Ver_Code"].toString() != buildNumber) {*/
    if ((versionMap["Table"][0]["Ver_Code"]as double).round().toString() != buildNumber) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(
                "A new version of this application is available now. "
		                "Please update to get new features.\n current version is $version"),
            actions: [
              RaisedButton(
                onPressed: () async {
                  if (Platform.isIOS) {
                    SystemNavigator.pop();
                  } else if (Platform.isAndroid) exit(0);
                },
                color: Colors.red,
                child: Text("Exit"),
              ),
              RaisedButton(
                onPressed: () async {
                  var url = 'https://play.google.com/store/apps/details?id=$packageName';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                color: Colors.green,
                child: Text("Update Now"),
              ),
            ],
          );
        },
        useSafeArea: true,
      );
    }
  }

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      MPin = preferences?.getString(StaticValues.Mpin) ?? "";

      strCustName = preferences?.getString(StaticValues.accName) ?? "";

      print("MPiN $MPin");

    });
  }

  @override
  void initState() {
   //  checkVersionCompatible();
     loadData();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: pageCtrlTime),
      reverseDuration: Duration(milliseconds: pageCtrlTime),
    );
    _floatingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: pageCtrlTime),
      reverseDuration: Duration(milliseconds: pageCtrlTime),
    );
    _animation = Tween<double>(begin: 1.41, end: 1.67).animate(_animationController)
      ..addListener(() {
        setState(() {
          print(_animationController.isDismissed);
        });
      });
    _floatingAnimation = Tween<double>(begin: .23, end: .1).animate(_floatingAnimationController)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(Duration(seconds: 2), () {
      final dynamic tooltip = _regToolTipKey.currentState;
      tooltip.ensureTooltipVisible();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
   //   resizeToAvoidBottomPadding: false,
      body: WillPopScope(
        onWillPop: () async {
          if (_pageController.page == 0 || _pageController.page == 2) {
            _pageController.animateToPage(
              1,
              duration: Duration(milliseconds: pageCtrlTime),
              curve: _pageCurves,
            );
            reverseAnimate();
            return false;
          } else {
            return true;
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).buttonColor,
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor,
                  ],
                  tileMode: TileMode.repeated,
                  begin: Alignment(0.0, 0.5),
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),

            Align(
                alignment: Alignment.bottomCenter,
                child:  Image.asset(
                  "assets/safesoftware_logo.png",
                  width: 200,
                ),),
            Align(
              alignment: Alignment.center,

              ///this SingleChildScrollView set to visible TextField when SoftKeyboard appears
              child: SingleChildScrollView(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: pageCtrlTime),
                  curve: Curves.easeIn,
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.width * _animation.value,
                  //onRegister .83
                  child: Card(
                    elevation: 0.0,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: <Widget>[
                        ForgotUI(
                          scaffoldKey: _scaffoldKey,
                          onTap: () {
                            setState(() {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: pageCtrlTime),
                                curve: _pageCurves,
                              );
                            });
                          },
                        ),
                        LoginUI(
                          version: version,
                          scaffold: _scaffoldKey,
                          onTap: () {
                            setState(() {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: pageCtrlTime),
                                curve: _pageCurves,
                              );
                            });
                          },
                        ),
                        RegisterUI(
                          onTap: () {
                            setState(() {
                              _pageController.animateToPage(
                                1,
                                duration: Duration(milliseconds: pageCtrlTime),
                                curve: _pageCurves,
                              );
                              reverseAnimate();
                            });
                          },
                          scaffoldKey: _scaffoldKey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: pageCtrlTime),
                right: MediaQuery.of(context).size.width * .035,
                curve: _animationCurves,
                top: MediaQuery.of(context).size.width * _floatingAnimation.value,
                //onRegister .03
                child: Tooltip(
                  key: _regToolTipKey,
                  message: "To register click here",
                  preferBelow: false,
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(20.0)),
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: pageCtrlTime),
                        curve: _pageCurves,
                      );
//                      _animationController.forward();
//                      _floatingAnimationController.forward();
                    },
                    disabledElevation: 1.0,
                    isExtended: true,
                    backgroundColor: Theme.of(context).buttonColor,
                    child: Icon(Icons.add),
                    elevation: 8.0,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class LoginUI extends StatefulWidget {
  final GestureTapCallback onTap;
  final GlobalKey<ScaffoldState> scaffold;
  final String version;

  const LoginUI({Key key, this.onTap, @required this.scaffold,@required this.version}) : super(key: key);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController mpinCtrl = TextEditingController();
  bool mobVal = false, passVal = false, mpinVal = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  LoginModel login = LoginModel();
  bool _isLoading = false;
  SharedPreferences preferences;
  String MPin,strCustName = "",strCustId;

  void saveData(LoginModel loginModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("CUST ID :: ${loginModel.table[0].toString()}");
    await preferences.setString(StaticValues.custID, loginModel.table[0].custId.toString());
    await preferences.setString(StaticValues.accNumber, loginModel.table[0].smMemNo.toString());
    await preferences.setString(StaticValues.accName, loginModel.table[0].custName.toString());
  //  await preferences.setString(StaticValues.userPass, passCtrl.text);
    await preferences.setString(
        StaticValues.address,
        loginModel.table[0].adds
            .split(",")
            .toList()
            .where((element) => element.isNotEmpty)
            .join(",")
            .toString());
    Navigator.of(context).pushReplacementNamed("/MainPage");
  }

  void loadData1() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      MPin = preferences?.getString(StaticValues.Mpin) ?? "";
      strCustName = preferences?.getString(StaticValues.accName) ?? "";
      strCustId = preferences?.getString(StaticValues.custID) ?? "";


      print("MPIN $MPin");

    });
  }

  @override
  void initState() {
    setState(() {
      loadData1();
    /*  usernameCtrl.text = "Prajitha";
     passCtrl.text = "9447307848";*/
//      usernameCtrl.text = "vidya";
//      passCtrl.text = "123456";
//      usernameCtrl.text = "9895564690";
//      passCtrl.text = "123456";
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GlobalWidgets().logoWithText(appTitle),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextView(
                "Sign In",
                size: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                height: 30.0,
              ),
              Visibility(
                visible: MPin == ""?true:false,
                child: Column(
                  children: [

                    EditTextBordered(
                      controller: usernameCtrl,
                      hint: "Username",
                      errorText: mobVal ? "Username is invalid" : null,
                      setBorder: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      setDecoration: true,
                      onChange: (value) {
                        setState(() {
                          mobVal = value.trim().length == 0;
                        });
                      },
                      onSubmitted: (_) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    EditTextBordered(
                      controller: passCtrl,
                      hint: "Password",
                      errorText: passVal ? "Password length should be 4" : null,
                      obscureText: true,
                      showObscureIcon: true,
                      onChange: (value) {
                        setState(() {
                          passVal = value.trim().length < 4;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: MPin == ""?false:true,
                child: Column(
                  children: [

                    TextView(strCustName,
                      size: 16,
                      fontWeight: FontWeight.bold,),
                    SizedBox(
                      height: 20,
                    ),

                    EditTextBordered(
                      controller: mpinCtrl,
                      hint: "MPin",
                      errorText: mpinVal ? "MPin length should be 4" : null,
                      keyboardType: TextInputType.number,
                      // obscureText: true,
                      // showObscureIcon: true,
                      onChange: (value) {
                        setState(() {
                          mpinVal = value.trim().length < 4;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: widget.onTap,
                  child: TextView(
                    "Forgot password?",
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),

            ],
          ),
        ),
        Visibility(
          visible: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: widget.onTap,
              child: TextView(
                "Version : ${widget.version}",
                color: Colors.black26,
              ),
            ),
          ),
        ),
        CustomRaisedButton(
            loadingValue: _isLoading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              print(usernameCtrl.text);
              setState(() {
                passVal = passCtrl.text.trim().length < 4;
                mobVal = usernameCtrl.text.trim().length == 0;
              });

              if(MPin == ""){
                if (!passVal && !mobVal) {
                  print("ALL true");
                  _isLoading = true;
                  try {
                    Map response = await RestAPI().get(
                        "${APis.loginUrl}Mob_no=${usernameCtrl.text}&pwd=${passCtrl.text}&IMEI=863675039500942");
                    setState(() {
                      _isLoading = false;
                      if ((response["Table"][0] as Map).containsKey("invalid")) {
                        GlobalWidgets().showSnackBar(widget.scaffold, "Invalid Credentials");
                      } else {

                       /* SharedPreferences preferences = StaticValues.sharedPreferences;
                        preferences.setString(StaticValues.userPass, passCtrl.text);*/
                      //  await preferences.setString(StaticValues.userPass, passCtrl.text);
                        preferences.setString(StaticValues.userPass, passCtrl.text);
                        LoginModel login = LoginModel.fromJson(response);
                        saveData(login);
                      }
                    });
                  } on RestException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });

                    GlobalWidgets().showSnackBar(widget.scaffold, e.message);
                  }
                }
              }
              else{
                if (!mpinVal) {
                  print("ALL true");
                  _isLoading = true;
                  try {

                    Map response = await RestAPI().get(
                        "${APis.mpinLoginUrl}CustId=$strCustId&MPin=${mpinCtrl.text}");
                    setState(() {
                      _isLoading = false;
                      if ((response["Table"][0] as Map).containsKey("invalid")) {
                        GlobalWidgets().showSnackBar(widget.scaffold, "Invalid Credentials");
                      } else {
                        LoginModel login = LoginModel.fromJson(response);
                        saveData(login);
                      }
                    });
                  } on RestException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });

                    GlobalWidgets().showSnackBar(widget.scaffold, e.message);
                  }
                }
              }


            },
            buttonText: "Login"),
        /*CustomRaisedButton(
          color: Theme.of(context).buttonColor,
          disabledColor: Theme.of(context).buttonColor,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          onPressed: _isLoading
              ? null
              : () async {
	          print(usernameCtrl.text);
	          setState(() {
		          passVal = passCtrl.text.trim().length < 4;
		          mobVal = usernameCtrl.text.trim().length == 0;
	          });

	          if (!passVal && !mobVal) {
		          print("ALL true");
		          _isLoading = true;
		          Map response = await RestAPI().get(
				          "${APis.loginUrl}Mob_no=${usernameCtrl.text}&pwd=${passCtrl.text}&IMEI=863675039500942");
		          setState(() {

			          _isLoading = false;
			          if ((response["Table"][0] as Map).containsKey("invalid")) {
				          GlobalWidgets().showSnackBar(widget.scaffold, "Invalid Credentials");
			          } else {
				          LoginModel login = LoginModel.fromJson(response);
				          saveData(login);
			          }
		          });
	          }
          },
          child: _isLoading
              ? SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    semanticsLabel: "Loading",
                  ))
              : TextView(
                  "Login",
                  color: Colors.white,
                  size: 18.0,
                  fontWeight: FontWeight.bold,
                ),
        )*/
      ],
    );
  }
}

class ForgotUI extends StatefulWidget {
  final Function onTap;
  final GlobalKey<ScaffoldState> scaffoldKey;


  const ForgotUI({Key key, this.onTap, @required this.scaffoldKey}) : super(key: key);

  @override
  _ForgotUIState createState() => _ForgotUIState();
}

class _ForgotUIState extends State<ForgotUI> {
  TextEditingController userIdCtrl = TextEditingController(),
      otpCtrl = TextEditingController(),
      rePassCtrl = TextEditingController(),
      passCtrl = TextEditingController();
  bool userIdVal = false, otpValid = false, passValid = false, rePassValid = false, isGetOTP = false;

  bool _isLoading = false;
  String strOtp;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: widget.onTap,
          child: Card(
            elevation: 3.0,
            margin: EdgeInsets.all(10.0),
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextView(
                "Forgot Password",
                size: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                height: 30.0,
              ),
              EditTextBordered(
                keyboardType: TextInputType.number,
                controller: userIdCtrl,
                hint: "Enter Mobile No",
                errorText: userIdVal ? "Invalid Mobile No" : null,
                onChange: (value) {
                  setState(() {
                    userIdVal = value.trim().isEmpty;
                    isGetOTP = false;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: otpCtrl,
                hint: "Enter OTP",
                errorText: otpValid ? "OTP length should be 4" : null,
                onChange: (value) {
                  setState(() {
                    otpValid = value.trim().length < 4;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: passCtrl,
                hint: "Enter password",
                obscureText: true,
                showObscureIcon: true,
                errorText: passValid ? "Password length should be 4" : null,
                onChange: (value) {
                  setState(() {
                    passValid = value.trim().length < 4;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              EditTextBordered(
                controller: rePassCtrl,
                hint: "Confirm password",
                obscureText: true,
                showObscureIcon: true,
                errorText: rePassValid ? "Password not matching" : null,
                onChange: (value) {
                  setState(() {
                    rePassValid = rePassCtrl.text != passCtrl.text;
                  });
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: CustomRaisedButton(
            buttonText: isGetOTP ? "Update Password" : "Get OTP",
            loadingValue: _isLoading,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              if (!isGetOTP) {
                if (userIdCtrl.text.length > 0) {
                  _isLoading = true;
                  Map response = await RestAPI().get("${APis.getPassChangeOTP}UserId=${userIdCtrl.text}");
                  _isLoading = false;
                  if (response["Table"][0]["statuscode"] == 1) {
                    strOtp = response["Table"][0]["OTP"];
                    GlobalWidgets().showSnackBar(widget.scaffoldKey, "OTP sent");
                    setState(() {
                      isGetOTP = true;
                    });
                  } else {
                    GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid User ID");
                  }
                } else {
                  GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid User ID");
                }
              }
              else if(strOtp != otpCtrl.text){
                GlobalWidgets().showSnackBar(widget.scaffoldKey, "OTP miss match");
              }
              else if((passCtrl.text =="") || (rePassCtrl.text =="")){
                GlobalWidgets().showSnackBar(widget.scaffoldKey, "Password not be null");
              }
              else if(passCtrl.text != rePassCtrl.text){
                GlobalWidgets().showSnackBar(widget.scaffoldKey, "Password miss match");
              }
              else if(passCtrl.text.contains(" ")){
                GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please remove space from password");
              }
              else {
                if (userIdCtrl.text.length <= 0 && otpCtrl.text.length < 4 && passCtrl.text.length < 4) {
                  GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please fill the missing fields");
                } else {
                  _isLoading = true;
                  try {
                    Map response = await RestAPI().post(
                        "${APis.changeForgotPass}userid=${userIdCtrl.text}&Newpassword=${passCtrl.text}");
                    setState(() {
                      _isLoading = false;
                    });
                    if (response["Table"][0]["Column1"] == "Password Updated Successfully") {
                      GlobalWidgets().showSnackBar(widget.scaffoldKey, "Password changed successfully");
                      widget.onTap();
                    } else {
                      GlobalWidgets().showSnackBar(widget.scaffoldKey, "Something went wrong");
                    }
                    print(response);
                  } on RestException catch (e) {
                    setState(() {
                      _isLoading = false;
                    });

                    GlobalWidgets().showSnackBar(widget.scaffoldKey, e.message);
                  }
                }
              }
            },
          ),
        )
      ],
    );
  }
}
