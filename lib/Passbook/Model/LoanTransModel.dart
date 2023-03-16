class LoanTransModel {
  List<LoanTransTable> table;

  LoanTransModel({
    this.table,
  });

  factory LoanTransModel.fromJson(Map<String, dynamic> json) => LoanTransModel(
        table: List<LoanTransTable>.from(json["Table"].map((x) => LoanTransTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(table.map((x) => x.toJson())),
      };
}

class LoanTransTable {
  String trdate;
  double amount;
  String drcr;
  double interest;
  double charges;
  double total;
  double balance;
  String narration;

  LoanTransTable({
    this.trdate,
    this.amount,
    this.drcr,
    this.interest,
    this.charges,
    this.total,
    this.balance,
    this.narration,
  });

  factory LoanTransTable.fromJson(Map<String, dynamic> json) => LoanTransTable(
        trdate: json["TRDATE"],
        amount: json["AMOUNT"],
        drcr: json["DRCR"],
        interest: json["INTEREST"],
        charges: json["CHARGES"],
        total: json["TOTAL"],
        balance: json["BALANCE"],
        narration: json["NARRATION"],
      );

  Map<String, dynamic> toJson() => {
        "TRDATE": trdate,
        "AMOUNT": amount,
        "DRCR": drcr,
        "INTEREST": interest,
        "CHARGES": charges,
        "TOTAL": total,
        "BALANCE": balance,
        "NARRATION": narration,
      };
}

