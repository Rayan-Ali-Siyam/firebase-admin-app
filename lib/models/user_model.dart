// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserFields {
  static const String email = "email";
  static const String isAdmin = "isAdmin";
}

class UserModel {
  UserModel({
    required this.email,
    required this.isAdmin,
  });

  String email;
  bool isAdmin;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json[UserFields.email],
        isAdmin: json[UserFields.isAdmin],
      );

  Map<String, dynamic> toJson() => {
        UserFields.email: email,
        UserFields.isAdmin: isAdmin,
      };
}
