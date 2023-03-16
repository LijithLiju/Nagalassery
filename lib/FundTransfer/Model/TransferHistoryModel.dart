// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
    this.table,
  });

  List<HistoryTable> table;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
    table: List<HistoryTable>.from(json["Table"].map((x) => HistoryTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Table": List<dynamic>.from(table.map((x) => x.toJson())),
  };
}

class HistoryTable {
  HistoryTable({
    this.transferAmt,
    this.transferDate,
    this.transactionId,
    this.fromAccNo,
    this.narration,
  });

  double transferAmt;
  DateTime transferDate;
  String transactionId;
  String fromAccNo;
  String narration;

  factory HistoryTable.fromJson(Map<String, dynamic> json) => HistoryTable(
    transferAmt: json["TransferAmt"],
    transferDate: DateTime.parse(json["TransferDate"]),
    transactionId: json["TransactionID"],
    fromAccNo: json["FromAccNo"],
    narration: json["Narration"],
  );

  Map<String, dynamic> toJson() => {
    "TransferAmt": transferAmt,
    "TransferDate": transferDate.toIso8601String(),
    "TransactionID": transactionId,
    "FromAccNo": fromAccNo,
    "Narration": narrationValues.reverse[narration],
  };
}

enum Narration { FUND_TRANSFER_TO_SHAMBREED_30525735492_SBIN0009593, FUND_TRANSFER_TO_SHAMRID_30525735492_SBIN0009593 }

final narrationValues = EnumValues({
  " Fund Transfer  to SHAMBREED (30525735492 SBIN0009593 )": Narration.FUND_TRANSFER_TO_SHAMBREED_30525735492_SBIN0009593,
  " Fund Transfer  to Shamrid (30525735492 SBIN0009593 )": Narration.FUND_TRANSFER_TO_SHAMRID_30525735492_SBIN0009593
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
