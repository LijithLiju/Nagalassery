import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeSoftware/Util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../REST/RestAPI.dart';
import 'Model/PassbookListModel.dart';
import 'Model/TransactionModel.dart';

class DepositShareTransaction extends StatefulWidget {
  final PassbookTable depositTransaction;

  const DepositShareTransaction({Key key, this.depositTransaction}) : super(key: key);

  @override
  _DepositShareTransactionState createState() => _DepositShareTransactionState();
}

class _DepositShareTransactionState extends State<DepositShareTransaction>
    with AutomaticKeepAliveClientMixin {
  List<TransactionTable> transactionList = List();
  bool isShare = false;

  Future<List<TransactionTable>> getTransactions() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map res = await RestAPI().get(
        "${isShare ? APis.getShareTransaction : APis.getDepositTransaction}${pref.getString(StaticValues.custID)}&Acc_no=${widget.depositTransaction.accNo}&Sch_code=${widget.depositTransaction.schCode}&Br_code=${widget.depositTransaction.brCode}&Frm_Date=${""}");
    TransactionModel _transactionModel = TransactionModel.fromJson(res);
    return _transactionModel.table;
  }

  @override
  void initState() {
    isShare = widget.depositTransaction.module.toLowerCase() == "share";
    getTransactions().then((onValue) {
      setState(() {
        transactionList = onValue;
        print("page : ${transactionList.length / 30}");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: transactionList.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 20.0,
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FractionColumnWidth(.40),
                        1: FractionColumnWidth(.30),
                        2: FractionColumnWidth(.30)
                      },
                      children: <TableRow>[
                        TableRow(children: [
                          TableCell(
                            child: TextView(
                              "Date",
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                              size: 12,
                            ),
                          ),
                          isShare
                              ? TableCell(
                                  child: TextView(
                                    "Type",
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    size: 12,
                                  ),
                                )
                              : TableCell(
                                  child: CustomText(
                                    children: [
                                      TextSpan(
                                          text: "Credit",
                                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: "/",
                                      ),
                                      TextSpan(
                                          text: "Debit",
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                          TableCell(
                            child: isShare
                                ? CustomText(
                                    children: [
                                      TextSpan(
                                          text: "Credit",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(
                                        text: "/",
                                      ),
                                      TextSpan(
                                          text: "Debit",
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                : TextView(
                                    "Balance",
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.end,
                                    size: 12,
                                  ),
                          ),
                        ])
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .59,
                  width: MediaQuery.of(context).size.width * .85,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: transactionList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                columnWidths: {
                                  0: FractionColumnWidth(.40),
                                  1: FractionColumnWidth(.30),
                                  2: FractionColumnWidth(.30)
                                },
                                children: <TableRow>[
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            TextView(
                                              DateFormat("dd-MM-yyyy").format(transactionList[index].trDate),
                                              fontWeight: FontWeight.bold,
                                              size: 12,
                                              textAlign: TextAlign.start,
                                            ),
                                            TextView(
                                              transactionList[index].narration,
                                              textAlign: TextAlign.start,
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: isShare
                                          ? TextView(
                                              toBeginningOfSentenceCase(
                                                  transactionList[index].show.toLowerCase()),
                                              textAlign: TextAlign.center,
                                              size: 12,
                                              fontWeight: FontWeight.bold)
                                          : TextView(
                                              transactionList[index].amount.toStringAsFixed(2),
                                              textAlign: TextAlign.end,
                                              fontWeight: FontWeight.bold,
                                              color: transactionList[index].tranType.toLowerCase() == 'c'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                    ),
                                    TableCell(
                                      child: TextView(
                                        isShare
                                            ? transactionList[index].amount.toStringAsFixed(2)
                                            : transactionList[index].tranBalance.toStringAsFixed(2),
                                        textAlign: TextAlign.end,
                                        size: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isShare
                                            ? transactionList[index].tranType.toLowerCase() == 'c'
                                                ? Colors.green
                                                : Colors.red
                                            : Colors.black,
                                      ),
                                    )
                                  ]),
                                ]),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
