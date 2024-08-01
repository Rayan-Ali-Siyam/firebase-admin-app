// To parse this JSON data, do
//
//     final image = imageFromJson(jsonString);

import 'dart:convert';

ImageModel imageFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageToJson(ImageModel data) => json.encode(data.toJson());

class ImageFields {
  static const String name = "name";
  static const String url = "url";
}

class ImageModel {
  ImageModel({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        name: json[ImageFields.name],
        url: json[ImageFields.url],
      );

  Map<String, dynamic> toJson() => {
        ImageFields.name: name,
        ImageFields.url: url,
      };
}
