import 'dart:convert';

AccountsDepositModel transactionModelFromJson(String str) => AccountsDepositModel.fromJson(json.decode(str));

String transactionModelToJson(AccountsDepositModel data) => json.encode(data.toJson());

class AccountsDepositModel {
	List<AccountsDepositTable> table;
	
	AccountsDepositModel({
		this.table,
	});
	
	factory AccountsDepositModel.fromJson(Map<String, dynamic> json) => AccountsDepositModel(
		table: json["Table"] == null ? null : List<AccountsDepositTable>.from(json["Table"].map((x) => AccountsDepositTable.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": table == null ? null : List<dynamic>.from(table.map((x) => x.toJson())),
	};
}


class AccountsDepositTable {
	double custId;
	String custName;
	String address;
	String custBranch;
	String accNo;
	String accBranch;
  double balance;
	String nominee;
	String accType;
	String module;
	String dueDate;

	
	AccountsDepositTable({
		this.custId,
		this.custName,
  	this.address,
		this.custBranch,
		this.accNo,
		this.accBranch,
    this.balance,
		this.nominee,
		this.accType,
		this.module,
    this.dueDate,
	});
	
	factory AccountsDepositTable.fromJson(Map<String, dynamic> json) => AccountsDepositTable(
		
		custId: json["Cust_Id"] == null ? null : json["Cust_Id"].toDouble(),
		custName: json["Cust_Name"] == null ? null : json["Cust_Name"],
		address: json["Adds"] == null ? null : json["Adds"],
		custBranch: json["Cust_Br"] == null ? null : json["Cust_Br"],
		accNo: json["Acc_No"] == null ? null : json["Acc_No"],
		accBranch: json["Acc_Br"] == null ? null : json["Acc_Br"],
		 balance: json["Balance"] == null ? null : json["Balance"].toDouble(),
		nominee: json["nominee"] == null ? null : json["nominee"],
		accType: json["Acc_type"] == null ? null : json["Acc_type"],
		module: json["module"] == null ? null : json["module"],
   	dueDate: json["Due_Date"] == null ? null : json["Due_Date"],
	);
	
	Map<String, dynamic> toJson() => {
		"Cust_Id": custId == null ? null : custId,
		"Cust_Name": custName == null ? null : custName,
		"Adds": address == null ? null : address,
		"Cust_Br": custBranch == null ? null : custBranch,
		"Acc_No": accNo == null ? null : accNo,
		"Acc_Br": accBranch == null ? null : accBranch,
		"Balance": balance == null ? null : balance,
		"nominee": nominee == null ? null : nominee,
		"Acc_type": accType == null ? null : accType,
		"module": module == null ? null : module,
		"Due_Date": dueDate == null ? null : dueDate,
		
	};
}

