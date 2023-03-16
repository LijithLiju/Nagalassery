import 'dart:convert';

AccountsLoanModel transactionModelFromJson(String str) => AccountsLoanModel.fromJson(json.decode(str));

String transactionModelToJson(AccountsLoanModel data) => json.encode(data.toJson());

class AccountsLoanModel {
	List<AccountsLoanTable> table;
	
	AccountsLoanModel({
		this.table,
	});
	
	factory AccountsLoanModel.fromJson(Map<String, dynamic> json) => AccountsLoanModel(
		table: json["Table"] == null ? null : List<AccountsLoanTable>.from(json["Table"].map((x) => AccountsLoanTable.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": table == null ? null : List<dynamic>.from(table.map((x) => x.toJson())),
	};
}


class AccountsLoanTable {
	double accId;
	String custId;
	String name;
	String address;
	String custBranch;
	String loanNo;
	String loanType;
	String loanBranch;
	double balance;
	double intrest;
	double overdueAmnt;
	double overdueIntrest;
	String suerty;
	String module;
  String schemeCode;
  String loanbranchCode;
  double intrestRate;
  String loanDate;
  String dueDate;
	
	AccountsLoanTable({
		this.accId,
		this.custId,
		this.name,
		this.address,
		this.custBranch,
		this.loanNo,
		this.loanType,
		this.loanBranch,
		this.balance,
		this.intrest,
		this.overdueAmnt,
		this.overdueIntrest,
		this.suerty,
		this.module,
    this.schemeCode,
		this.loanbranchCode,
		this.intrestRate,
		this.loanDate,
		this.dueDate,
	});
	
	factory AccountsLoanTable.fromJson(Map<String, dynamic> json) => AccountsLoanTable(
		accId: json["Acc_ID"] == null ? null : json["Acc_ID"].toDouble(),
		custId: json["Cust_id"] == null ? null : json["Cust_id"],
		name: json["Name"] == null ? null : json["Name"],
		address: json["Addrs"] == null ? null : json["Addrs"],
		custBranch: json["cust_br"] == null ? null : json["cust_br"],
		loanNo: json["Loan_no"] == null ? null : json["Loan_no"],
		loanType: json["Loan_type"] == null ? null : json["Loan_type"],
		loanBranch: json["Loan_br"] == null ? null : json["Loan_br"],
    balance: json["Balance"] == null ? null : json["Balance"].toDouble(),
		intrest: json["Interest"] == null ? null : json["Interest"].toDouble(),
		overdueAmnt: json["OverDue_Amt"] == null ? null : json["OverDue_Amt"].toDouble(),
		overdueIntrest: json["OverDue_Int"] == null ? null : json["OverDue_Int"].toDouble(),
		suerty: json["Suerty"] == null ? null : json["Suerty"],
		module: json["Module"] == null ? null : json["Module"],
		schemeCode: json["Sch_code"] == null ? null : json["Sch_code"],
    	loanbranchCode: json["Ln_Br_Code"] == null ? null : json["Ln_Br_Code"],
		intrestRate: json["Int_Rate"] == null ? null : json["Int_Rate"].toDouble(),
		loanDate: json["Loan_date"] == null ? null : json["Loan_date"],
		dueDate: json["Due_date"] == null ? null : json["Due_date"],
	);
	
	Map<String, dynamic> toJson() => {
		"Acc_ID": accId == null ? null : accId,
		"Cust_id": custId == null ? null : custId,
		"Name": name == null ? null : name,
		"Addrs": address == null ? null : address,
		"cust_br": custBranch == null ? null : custBranch,
		"Loan_no": loanNo == null ? null : loanNo,
		"Loan_type": loanType == null ? null : loanType,
		"Loan_br": loanBranch == null ? null : loanBranch,
		"Balance": balance == null ? null : balance,
		"Interest": intrest == null ? null : intrest,
		"OverDue_Amt": overdueAmnt == null ? null : overdueAmnt,
		"OverDue_Int": overdueIntrest == null ? null : overdueIntrest,
		"Suerty": suerty == null ? null : suerty,
		"Module": module == null ? null : module,
    "Sch_code": schemeCode == null ? null : schemeCode,
		"Ln_Br_Code": loanbranchCode == null ? null : loanbranchCode,
		"Int_Rate": intrestRate == null ? null : intrestRate,
		"Loan_date": loanDate == null ? null : loanDate,
		"Due_date": dueDate == null ? null : dueDate,
	};
}

