import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
	LoginModel({
		this.table,
	});
	
	List<Table> table;
	
	factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
		table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": List<dynamic>.from(table.map((x) => x.toJson())),
	};
}

class Table {
	Table({
		this.custId,
		this.custName,
		this.adds,
		this.brName,
		this.smMemNo,
		this.schCode,
		this.schName,
		this.brCode,
		this.depBranch,
		this.balance,
		this.module,
	});
	
	int custId;
	String custName;
	String adds;
	String brName;
	String smMemNo;
	String schCode;
	String schName;
	String brCode;
	String depBranch;
	double balance;
	String module;
	
	factory Table.fromJson(Map<String, dynamic> json) => Table(
		custId: json["Cust_id"],
		custName: json["Cust_name"],
		adds: json["adds"],
		brName: json["Br_Name"],
		smMemNo: json["Acc_No"],
		schCode: json["Sch_Code"],
		schName: json["Sch_Name"],
		brCode: json["Br_Code"],
		depBranch: json["Dep_Branch"],
		balance: json["balance"]?.toDouble(),
		module: json["Module"],
	);
	
	Map<String, dynamic> toJson() => {
		"Cust_id": custId,
		"Cust_name": custName,
		"adds": adds,
		"Br_Name": brName,
		"Sm_MemNo": smMemNo,
		"Sch_Code": schCode,
		"Sch_Name": schName,
		"Br_Code": brCode,
		"Dep_Branch": depBranch,
		"balance": balance,
		"Module": module,
	};
}
