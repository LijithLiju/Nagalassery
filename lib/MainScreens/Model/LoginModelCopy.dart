class LoginModel {
	List<Table> table;
	
	LoginModel({
		this.table,
	});
	
	factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
		table: List<Table>.from(json["Table"].map((x) => Table.fromJson(x))),
	);
	
	Map<String, dynamic> toJson() => {
		"Table": List<dynamic>.from(table.map((x) => x.toJson())),
	};
	
	@override
	String toString() {
		return 'LoginModel{table: $table}';
	}
	
}

class Table {
	dynamic custId;
	String custName;
	String adds;
	String brName;
	String accNo;
	String schCode;
	String schName;
	String brCode;
	String depBranch;
	double balance;
	String module;
	
	Table({
		this.custId,
		this.custName,
		this.adds,
		this.brName,
		this.accNo,
		this.schCode,
		this.schName,
		this.brCode,
		this.depBranch,
		this.balance,
		this.module,
	});
	
	
	factory Table.fromJson(Map<String, dynamic> json) => Table(
		custId: json["Cust_id"],
		custName: json["Cust_name"],
		adds: json["adds"],
		brName: json["Br_Name"],
		accNo: json["Acc_No"],
		schCode: json["Sch_Code"],
		schName: json["Sch_Name"],
		brCode: json["Br_Code"],
		depBranch: json["Dep_Branch"],
		balance: json["balance"],
		module: json["Module"],
	);
	
	Map<String, dynamic> toJson() => {
		"Cust_id": custId,
		"Cust_name": custName,
		"adds": adds,
		"Br_Name": brName,
		"Acc_No": accNo,
		"Sch_Code": schCode,
		"Sch_Name": schName,
		"Br_Code": brCode,
		"Dep_Branch": depBranch,
		"balance": balance,
		"Module": module,
	};
	
	@override
	String toString() {
		return 'Table{custId: $custId, custName: $custName, adds: $adds, brName: $brName, accNo: $accNo, '
				'schCode: $schCode, schName: $schName, brCode: $brCode, depBranch: $depBranch, balance: $balance, '
				'module: $module}';
	}
	
}
