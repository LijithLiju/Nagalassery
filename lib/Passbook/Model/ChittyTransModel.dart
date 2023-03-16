import 'dart:convert';

class ChittyTransModel {
	List<ChittyTransTable> table;
	
	ChittyTransModel({
		this.table,
	});
	
	factory ChittyTransModel.fromRawJson(String str) => ChittyTransModel.fromJson(json.decode(str));
	
	String toRawJson() => json.encode(toJson());
	
	factory ChittyTransModel.fromJson(Map<String, dynamic> json) => ChittyTransModel(
		table: List<ChittyTransTable>.from(json["Table"].map((x) => ChittyTransTable.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": List<dynamic>.from(table.map((x) => x.toJson())),
	};
}

class ChittyTransTable {
	String trdate;
	int instNo;
	double amount;
	String drcr;
	double disc;
	double intamt;
	double forfeit;
	double bankchrg;
	double chrgCr;
	double chrgDr;
	double balance;
	String narration;
	
	ChittyTransTable({
		this.trdate,
		this.instNo,
		this.amount,
		this.drcr,
		this.disc,
		this.intamt,
		this.forfeit,
		this.bankchrg,
		this.chrgCr,
		this.chrgDr,
		this.balance,
		this.narration,
	});
	
	
	factory ChittyTransTable.fromJson(Map<String, dynamic> json) => ChittyTransTable(
		trdate: json["TRDATE"],
		instNo: json["INST_NO"],
		amount: json["AMOUNT"],
		drcr: json["DRCR"],
		disc: json["DISC"],
		intamt: json["INTAMT"],
		forfeit: json["FORFEIT"],
		bankchrg: json["BANKCHRG"],
		chrgCr: json["CHRG_CR"],
		chrgDr: json["CHRG_DR"],
		balance: json["BALANCE"],
		narration: json["NARRATION"],
	);
	
	Map<String, dynamic> toJson() => {
		"TRDATE": trdate,
		"INST_NO": instNo,
		"AMOUNT": amount,
		"DRCR": drcr,
		"DISC": disc,
		"INTAMT": intamt,
		"FORFEIT": forfeit,
		"BANKCHRG": bankchrg,
		"CHRG_CR": chrgCr,
		"CHRG_DR": chrgDr,
		"BALANCE": balance,
		"NARRATION": narration,
	};
}
