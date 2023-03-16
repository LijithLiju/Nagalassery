import 'dart:convert';



PassbookListModel transactionModelFromJson(String str) => PassbookListModel.fromJson(json.decode(str));

String transactionModelToJson(PassbookListModel data) => json.encode(data.toJson());

class PassbookListModel {
	List<PassbookTable> table;
	
	PassbookListModel({
		this.table,
	});
	
	factory PassbookListModel.fromJson(Map<String, dynamic> json) => PassbookListModel(
		table: json["Table"] == null ? null : List<PassbookTable>.from(json["Table"].map((x) => PassbookTable.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": table == null ? null : List<dynamic>.from(table.map((x) => x.toJson())),
	};
}

class PassbookTable {
	int custId;
	String custName;
	String address;
	String brName;
	String accNo;
	String schCode;
	String schName;
	String brCode;
	String depBranch;
	double balance;
  String module;


  
		PassbookTable({
		this.custId,
		this.custName,
		this.address,
		this.brName,
		this.accNo,
		this.schCode,
		this.schName,
		this.brCode,
		this.depBranch,
		this.balance,
		this.module,
			});
	
	factory PassbookTable.fromJson(Map<String, dynamic> json) => PassbookTable(
		custId: json["Cust_Id"] == null ? null : json["Cust_Id"],
		custName: json["Cust_Name"] == null ? null : json["Cust_Name"],
		address: json["Adds"] == null ? null : json["Adds"],
		brName: json["Br_Name"] == null ? null : json["Br_Name"],
		accNo: json["Acc_No"] == null ? null :  json["Acc_No"],
		schCode: json["Sch_Code"] == null ? null : json["Sch_Code"],
		schName: json["Sch_Name"] == null ? null : json["Sch_Name"],
		brCode: json["Br_Code"] == null ? null : json["Br_Code"],
		depBranch: json["Dep_Branch"] == null ? null : json["Dep_Branch"],
		balance: json["Balance"] == null ? null : json["Balance"].toDouble(),
		module: json["Module"] == null ? null : json["Module"],
		
	);
	
	Map<String, dynamic> toJson() => {
		"Cust_Id": custId == null ? null : custId,
		"Cust_Name": custName == null ? null : custName,
		"Adds": address == null ? null : address,
		"Br_Name": brName == null ? null : brName,
		"Acc_No": accNo == null ? null : accNo,
		"Sch_Code": schCode == null ? null : schCode,
		"Sch_Name": schName == null ? null : schName,
		"Br_Code": brCode == null ? null : brCode,
		"Dep_Branch": depBranch == null ? null : depBranch,
		"Balance": balance == null ? null : balance,
		"Module": module == null ? null : module,
	
	};
}
