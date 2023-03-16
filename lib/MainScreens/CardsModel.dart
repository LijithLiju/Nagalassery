import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeSoftware/Account/Model/AccountsDepositModel.dart';
import 'package:safeSoftware/Account/Model/AccountsLoanModel.dart';
import 'package:safeSoftware/Passbook/Model/PassbookListModel.dart';
import 'package:safeSoftware/Util/util.dart';


double _height = 200.0;

BoxDecoration _boxDecoration({@required BuildContext context,bool shadowDisabled = false}) => BoxDecoration(
    borderRadius: BorderRadius.circular(15.0),
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [0.5, 0.9],
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).accentColor,
      ],
    ),
    boxShadow: shadowDisabled
        ? null
        : [
            BoxShadow(
                color: Colors.black45,
                offset: Offset(1.5, 1.5), //(x,y)
                blurRadius: 5.0,
                spreadRadius: 2.0),
          ]);

class DepositCardModel extends StatelessWidget {
  final AccountsDepositTable accountsDeposit;
  final Function onPressed;

  const DepositCardModel({Key key, this.accountsDeposit, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(context: context,shadowDisabled: onPressed == null),
        child: Stack(
          children: [
            Column(
              children: [
                TextView(
                  accountsDeposit.accType,
                  size: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextView(
                  accountsDeposit.accBranch,
                  size: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextView(
                  accountsDeposit.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                  size: 32,
                  color: Colors.white54,
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: TextView(
                "${StaticValues.rupeeSymbol}${accountsDeposit.balance.toStringAsFixed(2)}",
                color: Colors.white,
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextView(
                          "Nominee",
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextView(
                          accountsDeposit.nominee,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextView(
                          "Maturity Date",
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextView(
                          accountsDeposit.dueDate,
                          textAlign: TextAlign.center,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoanCardModel extends StatelessWidget {
  final AccountsLoanTable accountsLoanTable;
  final Function onPressed;

  const LoanCardModel({Key key, this.accountsLoanTable, this.onPressed}) : super(key: key);

  List<String> getDate(DateTime createdAt) {
    String s = formatDate(createdAt, [M, '\n', dd, '\n', yyyy]).toString();
    var sp = s.split("\n");
    print("SP:: $sp");
    return sp;
  }

  @override
  Widget build(BuildContext context) {
    List<String> _dateSplit = getDate(
      DateFormat().add_yMd().parse(accountsLoanTable.dueDate),
    );
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(context: context,shadowDisabled: onPressed == null),
        child: Table(defaultVerticalAlignment: TableCellVerticalAlignment.top, columnWidths: {
          0: FractionColumnWidth(.75),
          1: FractionColumnWidth(.25),
        }, children: [
          TableRow(children: [
            loanDetailWidget(accountsLoanTable),
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0, color: Colors.white)),
                    child: CustomText(
                      children: [
                        TextSpan(
                          text: "${_dateSplit[0]}\n",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        TextSpan(
                          text: "${_dateSplit[1]}\n",
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        TextSpan(
                          text: "${_dateSplit[2]}",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                        color: Theme.of(context).primaryColor,
                        child: TextView(
                          "Due Date",
                          size: keySize,
                          color: Colors.white,
                        ))),
              ],
            ),
          ])
        ]),
      ),
    );
  }

  static const double spaceBetween = 3.0;
  static const double keySize = 10.0;
  static const double valueSize = 11.0;

  Widget loanDetailWidget(AccountsLoanTable accountsLoanTable) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FractionColumnWidth(.45),
        1: FractionColumnWidth(.05),
        2: FractionColumnWidth(.50),
      },
      children: <TableRow>[
        TableRow(children: <Widget>[
          TableCell(
            ///To give a space between each row
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Balance ${StaticValues.rupeeSymbol}",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
            child: TextView(
              "${accountsLoanTable.balance.toStringAsFixed(2)}",
              size: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Overdue Amount ${StaticValues.rupeeSymbol}",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.overdueAmnt}",
            size: valueSize,
            color: Colors.white,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Overdue Interest ${StaticValues.rupeeSymbol}",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.overdueIntrest}",
            size: valueSize,
            color: Colors.white,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Interest @${accountsLoanTable.intrestRate}%",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.intrest}",
            size: valueSize,
            color: Colors.white,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Loan ID",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.loanNo}",
            size: valueSize,
            color: Colors.white,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Loan Type",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.loanType}",
            color: Colors.white,
            size: valueSize,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Loan Branch",
                color: Colors.white,
                size: keySize,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.loanBranch}",
            size: valueSize,
            color: Colors.white,
          )),
        ]),
        TableRow(children: <Widget>[
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: spaceBetween),
              child: TextView(
                "Suerty",
                size: keySize,
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
              child: TextView(
            ":",
            color: Colors.white,
          )),
          TableCell(
              child: TextView(
            "${accountsLoanTable.suerty}",
            color: Colors.white,
            size: valueSize,
          )),
        ]),
      ],
    );
  }
}

class ChittyCardModel extends StatelessWidget {
  final PassbookTable chittyListTable;

  final Function onPressed;

  const ChittyCardModel({Key key, this.chittyListTable, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(context: context,shadowDisabled: onPressed == null),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  chittyListTable.schName,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextView(
                  chittyListTable.depBranch,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextView(
                  chittyListTable.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                  size: 32,
                  color: Colors.white54,
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: TextView(
                "${StaticValues.rupeeSymbol}${chittyListTable.balance.toStringAsFixed(2)}",
                color: Colors.white,
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareCardModel extends StatelessWidget {
  final PassbookTable shareListTable;
  final Function onPressed;

  const ShareCardModel({Key key, this.shareListTable, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.0),
      onTap: onPressed,
      child: Container(
        height: _height,
        padding: EdgeInsets.all(10.0),
        decoration: _boxDecoration(context: context,shadowDisabled: onPressed == null),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextView(
                  shareListTable.schName,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextView(
                  shareListTable.depBranch,
                  size: 16.0,
                  color: Colors.white,
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextView(
                  shareListTable.accNo.replaceAllMapped(RegExp(r".{5}"), (match) => "${match.group(0)} "),
                  size: 32,
                  color: Colors.white54,
                )),
            Align(
              alignment: Alignment.bottomRight,
              child: TextView(
                "${StaticValues.rupeeSymbol}${shareListTable.balance.toStringAsFixed(2)}",
                color: Colors.white,
                size: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
