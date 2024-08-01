// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

ItemModel itemFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemToJson(ItemModel data) => json.encode(data.toJson());

class ItemFields {
  static const String name = "name";
  static const String quantity = "quantity";
}

class ItemModel {
  ItemModel({
    required this.name,
    this.quantity,
  });

  String? name;
  String? quantity;

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        name: json[ItemFields.name],
        quantity: json[ItemFields.quantity],
      );

  Map<String, dynamic> toJson() => {
        ItemFields.name: name,
        ItemFields.quantity: quantity,
      };
}
