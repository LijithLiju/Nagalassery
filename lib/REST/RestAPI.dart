import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:safeSoftware/REST/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef CustomResponse = Function(Map<String, dynamic> response, String error);

class RestAPI {
  static String clientId = "2";

//  static String clientSecret = "9Uei7JezQFj15Vs5TyMfWflnOBKtfY6C17O1pnDY";
//
  static String clientSecret = "1IWvjOOvaoC7DIsQuep9opQ2dRlPeThAukV6vNCN";

  Future checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(APis._superLink);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  Future<T> get<T>(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accessToken');
    print('Api Get, url $url');
    T responseJson;
    try {
      Response response =
          await http.get(Uri.parse(url), headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
      print("RESPONSE ${response.body}");
      responseJson = _returnResponse(response);
    } on SocketException {
      print('SocketException');
      throw FetchDataException('Either network issue nor server error');
      
    } on TimeoutException {
      print('TimeoutException');
      throw FetchDataException('Time out try again');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<T> post<T>(String url, {params}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accessToken');
    print('Api Post, url $url  and $params');
    T responseJson;
    try {
      final response = await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Accept": "application/json",
        'Content-type': 'application/json',
        "Authorization": "Bearer $token"
      });
      print("POST RESPONSE : ${response.statusCode} ${response.body}");
      responseJson = _returnResponse(response);
//      throw Exception('Testing');
//      print("RESPONSEJSON : $responseJson");
    } on SocketException {
      print('SocketException');
      throw FetchDataException('Either network issue nor server error');
    } on TimeoutException {
      print('TimeoutException');
      throw FetchDataException('Time out try again');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accessToken');
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http
          .put(Uri.parse(url), body: body, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
      responseJson = _returnResponse(response);
    } on SocketException {
      print('SocketException');
      throw FetchDataException('Either network issue nor server error');
    } on TimeoutException {
      print('TimeoutException');
      throw FetchDataException('Time out try again');
    }
    print('api put.');
//    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('accessToken');
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response =
          await http.delete(Uri.parse(url), headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('SocketException');
      throw FetchDataException('Either network issue nor server error');
    } on TimeoutException {
      print('TimeoutException');
      throw FetchDataException('Time out try again');
    }
    print('api delete.');
    return apiResponse;
  }
}

dynamic _returnResponse<T>(T response) {
  print('respose-------------- $T');
  if (response is http.Response) {
    // print(response.body);
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        print("responseJson : $responseJson");
        return responseJson;
      case 404:
      case 400:
        throw BadRequestException(json.decode(response.body));
      case 401:
      case 403:
        throw UnauthorisedException(json.decode(response.body));
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  } else if (response is Map<String, dynamic>) {
    print("MAP :::");
    print(response);
    switch (response["code"]) {
      case 200:
        var responseJson = response["response"];
        print("responseJson : $responseJson");
        return responseJson;
      case 404:
      case 400:
        throw BadRequestException(response["response"]);
      case 401:
      case 403:
        throw UnauthorisedException(response["response"]);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response["code"]}');
    }
  }
}

///[MEDIA] get full size image without crop
///[THUMB] get cropped size image
enum ImageConversion { MEDIA, THUMB }
enum ImageFolder { PROFILE, DOCUMENT }

//Api For Nagalaserry SCB updated 16-2-23 By LJT
//http://safewebserverthree.safeandsmartbank.com:6445
class APis {
  static String apiGenerate({String path, Map<String, String> params}) =>
      Uri.http("safewebserverthree.safeandsmartbank.com:6445", path, params).toString();



  static String _superLink = 'http://safewebserverthree.safeandsmartbank.com:6445/Api/Values';
  static String loginUrl = "$_superLink/get_AccountInfo1?";
  static String mpinLoginUrl = "$_superLink/LoginMPin?";
  static String mobileGetVersion = "$_superLink/Mobile_Get_Version";
  static String generateRefID(String key) => "$_superLink/GetReferanceNo?UserId=$key";

//  http://103.230.37.187:6556/change_pin?Mob_no=chitra&old_pin=98478&new_pin=123456
  static String changePassword = "$_superLink/change_pin?Mob_no=";

  ///Register
  //http://103.230.37.187:6556/Mobile_Get_OTP?MobileNo=9847828438
  static String getRegisterOTP = "$_superLink/Mobile_Get_OTP";

  //http://103.230.37.187:6556/Mobile_Get_SbNo?MobileNo=9847828438&OTP=4020
  static String validateOTP = "$_superLink/Mobile_Get_SbNo";

  // http://103.230.37.187:6556/registercustomer?userid=chitra
  // &password=1234567&MobileNo=9847828438&Accno=0020070001785
  static String registerAcc = "$_superLink/registercustomer";

  ///Forgot password
  static String getPassChangeOTP = "$_superLink/GetPasswordChangeOTP?";

  //http://103.230.37.187:6556/ChangePassword?userid=chitra&Newpassword=1234567
  static String changeForgotPass = "$_superLink/ChangePassword?";


  //save MPin
  static String saveMpin(String custID,String MPin) => "$_superLink/SaveMPin?CustId=$custID&MPIN=$MPin";

  ///Account Section
  static String accountLoanListUrl(String custID) => "$_superLink/get_loan_details?Cust_id=$custID";

  static String getDepositDetailsList(String custID) => "$_superLink/get_deposit_details?Cust_id=$custID";

  ///get Other Acc List of passbook and account section=============
  //Acc_Type=LN(Loan List)
  //Acc_Type=DP(Deposit List)
  //Acc_Type=SH(Share List)
  //Acc_Type=MMBS(Chitty List)
  // "http://103.230.37.187:6556/get_Other_AccountInfo?Cust_id=31125&Acc_Type=";
  static String otherAccListInfo = "$_superLink/get_Other_AccountInfo?Cust_id=";

  ///Passbook Section===========
  //31125&Acc_no=0020070001785&Sch_code=007&Br_code=2&Frm_Date=";
  static String getDepositTransaction = "$_superLink/get_Full_Transaction?Cust_id=";

  //http://103.230.37.187:6556/GetChittypassbook_details?Accno=0020070001785&Frm_Date=
  static String getChittyPassbook = "$_superLink/GetChittypassbook_details?Accno=";

  //	http://103.230.37.187:6556/GetLoanpassbook_details?Accno=0020890000033
  static String getLoanPassbook = "$_superLink/GetLoanpassbook_details?Accno=";

  //1494&Acc_no=0010010001396&Sch_code=001&Br_code=1&Frm_Date=
  static String getShareTransaction = "$_superLink/get_share_Transaction?Cust_id=";

  ///AddBeneficiary
  ///CustId=&reciever_name=&reciever_mob=&reciever_ifsc=&reciever_Accno=&BankName=&Receiver_Address=
  ///    Uri.https(_superLink,addBeneficiary({}),{});
  static String addBeneficiary(Map params) => "$_superLink/Mobile_ICICIFuntran_recieverdtls?"
      "CustId=${params["CustId"]}&reciever_name=${params["reciever_name"]}"
      "&reciever_mob=${params["reciever_mob"]}&reciever_ifsc=${params["reciever_ifsc"]}"
      "&reciever_Accno=${params["reciever_Accno"]}&BankName=${params["BankName"]}"
      "&Receiver_Address=${params["Receiver_Address"]}";

  static String deleteBeneficiary(String recieverId) => "$_superLink/Mobile_ICICIFuntran_recieverdtls?"

      ///CustId = Reciever_Id, reciever_name = "delete"
      "CustId=$recieverId&reciever_name=DELETE"
      "&reciever_mob=&reciever_ifsc="
      "&reciever_Accno=&BankName="
      "&Receiver_Address=";

  static String fetchBeneficiary(String custID) =>
      "$_superLink/Mobile_GetFuntran_recieverdtls?Cust_Id=$custID";

  static String fetchTransferHistory(String custID) =>
      "$_superLink/GetOnlineTransferHistory?CustId=$custID";

  ///Fund Transfer
  static String fetchIMPSCharge(String amount) => "$_superLink/Mobile_Getcharges?Amount=";

  static String fetchFundTransferBal(String custID) => "$_superLink/get_CustomerSB?Cust_Id=$custID";

  static String fetchFundTransferType = "$_superLink/TransferTypeDetails";
  static String checkFundTransAmountLimit = "$_superLink/Mobile_Checkfund_limits";

  static String checkFundTransferDailyLimit(Map params) => "$_superLink/Mobile_CheckonlinepaymentDailyLimit?"
      "Customer_AccNo=${params["Customer_AccNo"]}&BankId=${params["BankId"]}"
      "&Customer_Mobileno=${params["Customer_Mobileno"]}&ShopAccno=${params["ShopAccno"]}"
      "&PayAmount=${params["PayAmount"]}";

  static String checkFundTransferDailyLimit2(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/Mobile_CheckonlinepaymentDailyLimit", params: params);

  static String fundTransferOTPValidation(Map params) => "$_superLink/FundTransferIMPSOTPValidation?"
      "Acc_No=${params["Acc_No"]}&OTP=${params["OTP"]}";

  ///Other bank transfer
  static String otherBankFundTrans2(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/MobileIMPSTransaction", params: params);

  ///Own Bank Transfer
  static String fetchAccNo(String accNo) => "$_superLink/Mobile_Get_Accno?MobileNo=$accNo";
  static String ownBankFundTrans2(Map params) =>
      apiGenerate(params: params, path: "Api/Values/Mobile_Saveonlinepayment");
  static String ownFundTransferOTP(Map params) => "$_superLink/Mobile_Checkonlinepayment?"
      "Customer_AccNo=${params["Customer_AccNo"]}&BankId=${params["BankId"]}"
      "&Customer_Mobileno=${params["Customer_Mobileno"]}&ShopAccno=${params["ShopAccno"]}"
      "&PayAmount=${params["PayAmount"]}";

  /// QrScan
  static String fetchShoppingInfo(String accNo) => "$_superLink/Mobile_Getdetails_onlinepayment?AccNo=$accNo";

  ///Recharge Operators
  static String rechargeOperators = "$_superLink/Mobile_Getoperaters";
	///Dish TV Operators
  static String dishTvOperators = "$_superLink/DishTv_Getoperater";

  ///Recharge Mobile
  static String rechargeMobile(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/Recharge_Mobile", params: params);
  
  ///Recharge Dish TV
  static String rechargeDishTv(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/Recharge_DishTv", params: params);
  
  ///KSEB Pill Payment
  static String payKSEB(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/KSEB_BillPayment", params: params);
  
	///KWA Pill Payment
  static String payKWA(Map<String, String> params) =>
      apiGenerate(path: "Api/Values/KWA_BillPayment", params: params);
  
  

  ///[imageSize] will only need when [imageConversion] is thumb
  String imageApi(String imageName,
      {int imageSize = 0,
      ImageConversion imageConversion = ImageConversion.MEDIA,
      ImageFolder imageFolder = ImageFolder.PROFILE}) {
    if (imageSize > 0 && imageConversion == ImageConversion.MEDIA)
      throw "Change $imageConversion to ImageConversion.THUMB when setting the size of image.";
    var conversion = imageConversion == ImageConversion.MEDIA ? "media" : "thumb";
    var folder = imageFolder == ImageFolder.PROFILE ? "profiles" : "documents";
    return "$_superLink/$conversion/$folder/$imageName/${imageSize > 0 ? imageSize : ''}";
  }
}
