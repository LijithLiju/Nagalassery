class People {
  List<PeopleTable> table;

  People({
    this.table,
  });

  factory People.fromJson(Map<String, dynamic> json) => People(
        table: List<PeopleTable>.from(json["Table"].map((x) => PeopleTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Table": List<dynamic>.from(table.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'People{table: $table}';
  }
}

class PeopleTable {
  String recieverName;
  String recieverMob;
  String recieverIfsc;
  String recieverAccno;
  double recieverId;

  PeopleTable({
    this.recieverName,
    this.recieverMob,
    this.recieverIfsc,
    this.recieverAccno,
    this.recieverId,
  });

  factory PeopleTable.fromJson(Map<String, dynamic> json) => PeopleTable(
        recieverName: json["Reciever_Name"],
        recieverMob: json["Reciever_Mob"],
        recieverIfsc: json["Reciever_Ifsc"],
        recieverAccno: json["Reciever_Accno"],
        recieverId: json["Reciever_Id"],
      );

  Map<String, dynamic> toJson() => {
        "Reciever_Name": recieverName,
        "Reciever_Mob": recieverMob,
        "Reciever_Ifsc": recieverIfsc,
        "Reciever_Accno": recieverAccno,
        "Reciever_Id": recieverId,
      };

  @override
  String toString() {
    return 'PeopleTable{recieverName: $recieverName, recieverMob: $recieverMob, recieverIfsc: $recieverIfsc, recieverAccno: $recieverAccno, recieverId: $recieverId}';
  }
}
