
import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
	List<TransactionTable> table;
	
	TransactionModel({
		this.table,
	});
	
	factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
		table: json["Table"] == null ? null : List<TransactionTable>.from(json["Table"].map((x) => TransactionTable.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": table == null ? null : List<dynamic>.from(table.map((x) => x.toJson())),
	};
}

class TransactionTable {
	double id;
	String accNo;
	String schCode;
	String brCode;
	DateTime trDate;
	String tranType;
	String display;
	double amount;
	String narration;
	double balance;
	double seqNo;
	String show;
	double dailyBalance;
	double tranBalance;
	
	TransactionTable({
		this.id,
		this.accNo,
		this.schCode,
		this.brCode,
		this.trDate,
		this.tranType,
		this.display,
		this.amount,
		this.narration,
		this.balance,
		this.seqNo,
		this.show,
		this.dailyBalance,
		this.tranBalance,
	});
	
	factory TransactionTable.fromJson(Map<String, dynamic> json) => TransactionTable(
		id: json["ID"] ?? null,
		accNo: json["Acc_No"] == null ? null : json["Acc_No"],
		schCode: json["Sch_Code"] == null ? null : json["Sch_Code"],
		brCode: json["Br_Code"] == null ? null : json["Br_Code"],
		trDate: json["Tr_Date"] == null ? null : DateTime.parse(json["Tr_Date"]),
		tranType: json["Tran_Type"] == null ? null : json["Tran_Type"],
		display: json["Display"] == null ? null : json["Display"],
		amount: json["Amount"] == null ? null : json["Amount"],
		narration: json["Narration"] == null ? null : json["Narration"],
		balance: json["balance"]?.toDouble() ?? json["Balance"]?.toDouble() ?? null,
		seqNo: json["Seq_No"] == null ? null : json["Seq_No"],
		show: json["Show"] == null ? null : json["Show"],
		dailyBalance: json["DailyBalance"] == null ? null : json["DailyBalance"].toDouble(),
		tranBalance: json["TranBalance"] == null ? null : json["TranBalance"].toDouble(),
	);
	
	Map<String, dynamic> toJson() => {
		"ID": id == null ? null : id,
		"Acc_No": accNo == null ? null : accNo,
		"Sch_Code": schCode == null ? null : schCode,
		"Br_Code": brCode == null ? null : brCode,
		"Tr_Date": trDate == null ? null : trDate.toIso8601String(),
		"Tran_Type": tranType == null ? null : tranType,
		"Display": display == null ? null : display,
		"Amount": amount == null ? null : amount,
		"Narration": narration == null ? null : narration,
		"balance": balance == null ? null : balance,
		"Seq_No": seqNo == null ? null : seqNo,
		"Show": show == null ? null : show,
		"DailyBalance": dailyBalance == null ? null : dailyBalance,
		"TranBalance": tranBalance == null ? null : tranBalance,
	};
}
