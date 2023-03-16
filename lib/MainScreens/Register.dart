import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:safeSoftware/MainScreens/Model/LoginModel.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUI extends StatefulWidget {
  final GestureTapCallback onTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RegisterUI({
    Key key,
    this.onTap,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> with SingleTickerProviderStateMixin {
  TextEditingController mobCtrl = TextEditingController(),
      otpCtrl = TextEditingController(),
      accCtrl = TextEditingController(),
      passCtrl = TextEditingController(),
      rePassCtrl = TextEditingController(),
      usernameCtrl = TextEditingController();
  List<String> accNos = List();
  FocusNode chapass = FocusNode();
  bool isSendOTP = false, isOtpValid = false;
  bool mobVal = false,
      passVal = false,
      rePassVal = false,
      accVal = false,
      userNameVal = false,
      otpVal = false;
  LoginModel login = LoginModel();
  AnimationController _controller;
  Animation<double> _fadeIn;

  bool _isLoading = false;

  final _listController = ScrollController();

  void saveData(LoginModel loginModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("CUST ID :: ${loginModel.table[0].toString()}");
    await preferences.setString(StaticValues.custID, loginModel.table[0].custId.toString());
    await preferences.setString(StaticValues.accNumber, loginModel.table[0].smMemNo.toString());
    await preferences.setString(StaticValues.accName, loginModel.table[0].custName.toString());
    Navigator.of(context).pushReplacementNamed("/HomePage");
  }

  void _showAccList(TextEditingController textCtrl) {
    showModalBottomSheet(
      context: context,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: List.generate(accNos.length, (index) {
                return GestureDetector(
                    onTap: () {
                      textCtrl.text = accNos[index];
                      Navigator.of(context).pop();
                    },
                    child: ListTile(title: TextView(accNos[index])));
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: 450), vsync: this);
    _fadeIn = Tween(begin: 0.5, end: 1.0).animate(_controller);
    super.initState();
  }

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
        Positioned(
          top: MediaQuery.of(context).size.width * .15,
          left: 20.0,
          child: TextView(
            "Sign Up",
            size: 20.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * .25,
          left: 0.0,
          right: 0.0,
          height: MediaQuery.of(context).size.width * 1.31,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: KeyboardAvoider(
	            autoScroll: true,
              focusPadding: 100.0,
              child: SingleChildScrollView(
	              controller: _listController,
	              physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                  	SizedBox(
		                  height: 10.0,
	                  ),
                    EditTextBordered(
                        controller: mobCtrl,
                        hint: "Mobile No",
                        keyboardType: TextInputType.number,
                        errorText: mobVal ? "Mobile number is invalid" : null,
		                  textInputAction: TextInputAction.next,
		                  onSubmitted: (_){
			                  onRegister();
			                  FocusScope.of(context).nextFocus();
		                  },
                        onChange: (value) {
                          setState(() {
                            print(value.trim().length != 10);

                            mobVal = value.trim().length != 10;
                            setState(() {
                              isOtpValid = false;
                              isSendOTP = false;
                              _controller.reverse();
                            });
                          });
                        }),
                    SizedBox(
                      height: 20.0,
                    ),
	                EditTextBordered(
		                controller: otpCtrl,
		                hint: "Enter OTP",
		                keyboardType: TextInputType.number,
		                errorText: otpVal ? "OTP length should be 4" : null,
		                onChange: (value) {
			                setState(() {
				                otpVal = value.trim().length < 4;
			                });
		                },
	                ),
	                SizedBox(
		                height: 20.0,
	                ),
                    FadeTransition(
                        opacity: _fadeIn,
                        child: IgnorePointer(
                          ignoring: false/*!isOtpValid && !isSendOTP*/,
                          child: Column(
                            children: <Widget>[
	                        
                              InkWell(
                                onTap: () {
                                  _showAccList(accCtrl);
                                },
                                child: EditTextBordered(
                                  enabled: false,
                                  controller: accCtrl,
                                  hint: "Select A/C No",
                                  errorText: accVal ? "Select an account" : null,
                                  obscureIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                  ),
                                  onChange: (value) {
                                    setState(() {
                                      accVal = value.trim().length <= 0;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              EditTextBordered(
                                controller: usernameCtrl,
                                hint: "Enter a user name",
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[/ \\]')),
                                ],
                                errorText: userNameVal ? "Invalid username" : null,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_){
                                	FocusScope.of(context).nextFocus();
                                },
                                onChange: (value) {
                                  setState(() {
                                    userNameVal = value.trim().length <= 3;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              EditTextBordered(
                                controller: passCtrl,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[/ \\]')),
                                ],
                                hint: "Password",
                                errorText: passVal ? "Password length should be 4" : null,
                                obscureText: true,
                                showObscureIcon: true,
	                            textInputAction: TextInputAction.next,
	                            onSubmitted: (_){
		                            FocusScope.of(context).nextFocus();
	                            },
                                onChange: (value) {
                                  setState(() {
                                    passVal = value.trim().length < 4;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              EditTextBordered(
                                controller: rePassCtrl,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[/ \\]')),
                                ],
                                hint: "Confirm Password",
                                focusNode: chapass,
                                errorText: rePassVal ? "Password not matching" : null,
                                obscureText: true,
                                showObscureIcon: true,
                                onChange: (value) {
                                  setState(() {
                                    rePassVal = rePassCtrl.text != passCtrl.text;
                                  });
                                },
                              ),
	                          SizedBox(
		                          height: 120.0,
	                          ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: CustomRaisedButton(
            loadingValue: _isLoading,
            buttonText: !isSendOTP ? "Send OTP" : isSendOTP && !isOtpValid ? "Validate OTP" : "Register",
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            onPressed: () async {
              onRegister();
            },
          ),
        )
      ],
    );
  }

  void onRegister() async {
    if (!isSendOTP && !isOtpValid) {
      if (mobCtrl.text.trim().length == 10) {
        _isLoading = true;
        try {
          Map response = await RestAPI().post(
            "${APis.getRegisterOTP}?MobileNo=${mobCtrl.text}",
          );
          setState(() {
	          _isLoading = false;
          });
         
          if (response["Table"][0]["Result"].toString().toLowerCase() == 'y') {
            GlobalWidgets().showSnackBar(widget.scaffoldKey, "OTP sent");
            setState(() {
              isSendOTP = true;
            });
          } else {
            setState(() {
              isSendOTP = false;
            });
            GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid mobile number");
          }
        } on RestException catch (e) {
        	setState(() {
		        _isLoading = false;
        	});
		     
		        GlobalWidgets().showSnackBar(widget.scaffoldKey, e.message);
        }
      } else {
        setState(() {
          isSendOTP = false;
        });
        GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid mobile number");
      }
    } else if (isSendOTP && !isOtpValid) {
      if (mobCtrl.text.trim().length == 10 && otpCtrl.text.length >= 4) {
        _isLoading = true;
        try {
          Map response = await RestAPI().get(
            "${APis.validateOTP}?MobileNo=${mobCtrl.text}&OTP=${otpCtrl.text}",
          );
          _isLoading = false;
          if (response["Table"][0]["ACCNO"].toString().toLowerCase() == 'n') {
            GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid OTP or Mobile number");
            setState(() {
              isOtpValid = false;
              isSendOTP = true;
            });
          } else {
            setState(() {
              (response["Table"] as List).forEach((f) {
                accNos.add(f["ACCNO"]);
              });
              isOtpValid = true;
              isSendOTP = true;
              _controller.forward();
            });
          }
        } on RestException catch (e) {
          setState(() {
            _isLoading = false;
          });
          GlobalWidgets().showSnackBar(widget.scaffoldKey, e.message);
        }
      } else {
        GlobalWidgets().showSnackBar(widget.scaffoldKey, "Invalid OTP or Mobile number");
        setState(() {
          isOtpValid = false;
          isSendOTP = true;
        });
      }
    } else {
      if (mobCtrl.text.trim().length == 10 &&
          otpCtrl.text.length >= 4 &&
          accCtrl.text.length > 0 &&
          usernameCtrl.text.length > 3 &&
          passCtrl.text.length >= 4 &&
          passCtrl.text == rePassCtrl.text) {
        String url = "${APis.registerAcc}?userid=${usernameCtrl.text}&password=${passCtrl.text}"
            "&MobileNo=${mobCtrl.text}&Accno=${accCtrl.text}";
        _isLoading = true;
        Map response = await RestAPI().post(url);
        _isLoading = false;
        if (response["Table"][0]["Status"].toString() == "Usercode Already Exists") {
          GlobalWidgets().showSnackBar(widget.scaffoldKey, "Usercode Already Exists");
        } else {
          print(response["Table"][0]["Status"].toString());
          GlobalWidgets().showSnackBar(widget.scaffoldKey, response["Table"][0]["Status"].toString());
          widget.onTap();
        }
      } else {
        GlobalWidgets().showSnackBar(widget.scaffoldKey, "Please fill the missing fields");
      }
    }
  }
}
