// ignore_for_file: file_names
import 'dart:convert';

UserBMIModel userBMIFromJson(String str) =>
    UserBMIModel.fromJson(json.decode(str));

String userBMIToJson(UserBMIModel data) => json.encode(data.toJson());

class UserBMIModel {
  int bmiId;
  DateTime checkDate;
  double result;
  String user;

  UserBMIModel({
    required this.bmiId,
    required this.checkDate,
    required this.result,
    required this.user,
  });

  factory UserBMIModel.fromJson(Map<String, dynamic> json) => UserBMIModel(
        bmiId: json["bmiId"],
        checkDate: DateTime.parse(json["check_date"]),
        result: json["result"]?.toDouble(),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "bmiId": bmiId,
        "check_date":
            "${checkDate.year.toString().padLeft(4, '0')}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}",
        "result": result,
        "user": user,
      };
}
