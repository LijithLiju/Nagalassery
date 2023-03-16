import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeSoftware/REST/RestAPI.dart';
import 'package:safeSoftware/Util/StaticValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FundTransfer.dart';
import 'Model/TransferHistoryModel.dart';
import 'Receipt.dart';


class TransferHistory extends StatefulWidget {
  const TransferHistory({Key key}) : super(key: key);

  @override
  _TransferHistoryState createState() => _TransferHistoryState();
}

class _TransferHistoryState extends State<TransferHistory> {

  SharedPreferences preferences;
  String acc = "", name = "", custId = "";
  bool _isLoading = false;
  String strDate;

  List<HistoryTable> transferHistory = [];

  void loadData() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {

      acc = preferences?.getString(StaticValues.accNumber) ?? "";
      name = preferences?.getString(StaticValues.accName) ?? "";
      custId = preferences?.getString(StaticValues.custID) ?? "";
    });
    fetchTransHistory();
  }

  Future<void> fetchTransHistory() async {
    setState(() {
      _isLoading = true;
    });
    var id = preferences?.getString(StaticValues.custID);
    print("ID :: $id");
    var response =  await RestAPI().get(APis.fetchTransferHistory(custId));

    HistoryModel _historyModel =  HistoryModel.fromJson(response);

    setState(() {
      transferHistory = _historyModel.table;
      _isLoading = false;
    });



    print("RESSS$transferHistory");
  }


  @override
  void initState() {
    loadData();

    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History"),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: transferHistory.length,
            itemBuilder: (context, index){

              return Card(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Receipt(
                              isFailure: false,
                              widgetBuilder: (context) => FundTransfer(),
                              amount: transferHistory[index].transferAmt.toString(),
                              transID: transferHistory[index].transactionId,
                              paidTo: toBeginningOfSentenceCase(
                                  transferHistory[index].narration)
                                  .toString(),
                              accTo: "",
                              date: transferHistory[index].transferDate.toString(),
                              accFrom: transferHistory[index].fromAccNo,
                              from: "history",
                              name: name,
                            ),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: ListTile(

                        title: Row(
                          children: [
                            Text(transferHistory[index].fromAccNo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),),
                            Spacer(),
                            Text(StaticValues.rupeeSymbol +" "+transferHistory[index].transferAmt.toString(),style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                          ],
                        ),

                        subtitle: Text(transferHistory[index].narration,
                        style: TextStyle(
                          fontSize: 14.0
                        ),),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20,bottom: 6.0),
                      child: Text(transferHistory[index].transferDate.toString(),
                      style: TextStyle(
                        fontSize: 14
                      ),),
                    )
                  ],
                ),
              );

        }),
      )
    );
  }
}
