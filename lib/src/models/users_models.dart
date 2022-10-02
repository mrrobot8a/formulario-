// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id = 1,
    this.email,
    this.password,
    this.returnSecureToken = true,
  });

  int? id;
  String? email;
  String? password;
  bool? returnSecureToken;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        // id: json["id"],
        email: json["email"],
        password: json["password"],
        returnSecureToken: json["returnSecureToken"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "email": email,
        "password": password,
        "returnSecureToken": returnSecureToken,
      };
}
