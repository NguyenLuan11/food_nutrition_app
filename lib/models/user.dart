// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? userId;
  String userName;
  String email;
  DateTime? dateBirth;
  bool? state;
  DateTime? dateJoining;
  String? address;
  String? fullName;
  String? image;
  String? photoURL;
  String? password;
  String? gender;
  double? weight;
  double? height;
  double? ideal_weight;
  List<ListUserBmi>? listUserBmi;
  DateTime? modifiedDate;
  String? phone;
  String? accessToken;
  String? refreshToken;

  UserModel({
    this.userId,
    required this.userName,
    required this.email,
    this.dateBirth,
    this.state,
    this.dateJoining,
    this.fullName,
    this.image,
    this.photoURL,
    this.password,
    this.gender,
    this.weight,
    this.height,
    this.ideal_weight,
    this.listUserBmi,
    this.modifiedDate,
    this.phone,
    this.address,
    this.accessToken,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        state: json["state"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        address: json["address"],
        dateBirth: json["dateBirth"] != null
            ? DateTime.parse(json["dateBirth"])
            : null,
        dateJoining: DateTime.parse(json["dateJoining"]),
        email: json["email"],
        fullName: json["fullName"],
        image: json["image"],
        listUserBmi: List<ListUserBmi>.from(
            json["list_user_bmi"].map((x) => ListUserBmi.fromJson(x))),
        modifiedDate: json["modified_date"] != null
            ? DateTime.parse(json["modified_date"])
            : null,
        phone: json["phone"],
        userId: json["userID"],
        userName: json["userName"],
        gender: json["gender"],
        weight: json["weight"],
        height: json["height"],
        ideal_weight: json["ideal_weight"],
      );

  Map<String, dynamic> toJson() => {
        // "access_token": accessToken,
        // "refresh_token": refreshToken,
        "address": address,
        "dateBirth": dateBirth != null
            ? "${dateBirth?.year.toString().padLeft(4, '0')}-${dateBirth?.month.toString().padLeft(2, '0')}-${dateBirth?.day.toString().padLeft(2, '0')}"
            : null,
        // "dateJoining":
        //     "${dateJoining?.year.toString().padLeft(4, '0')}-${dateJoining?.month.toString().padLeft(2, '0')}-${dateJoining?.day.toString().padLeft(2, '0')}",
        "email": email,
        "fullName": fullName,
        "image": image,
        "password": password,
        // "list_user_bmi":
        //     List<ListUserBmi>.from(listUserBmi!.map((x) => x.toJson())),
        // "modified_date":
        //     "${modifiedDate?.year.toString().padLeft(4, '0')}-${modifiedDate?.month.toString().padLeft(2, '0')}-${modifiedDate?.day.toString().padLeft(2, '0')}",
        "phone": phone,
        // "userID": userId,
        "userName": userName,
      };
}

class ListUserBmi {
  int bmiId;
  DateTime checkDate;
  double result;

  ListUserBmi({
    required this.bmiId,
    required this.checkDate,
    required this.result,
  });

  factory ListUserBmi.fromJson(Map<String, dynamic> json) => ListUserBmi(
        bmiId: json["bmiId"],
        checkDate: DateTime.parse(json["check_date"]),
        result: json["result"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bmiId": bmiId,
        "check_date":
            "${checkDate.year.toString().padLeft(4, '0')}-${checkDate.month.toString().padLeft(2, '0')}-${checkDate.day.toString().padLeft(2, '0')}",
        "result": result,
      };
}
