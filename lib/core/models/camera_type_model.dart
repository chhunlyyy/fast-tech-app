import 'dart:convert';

CameraTypeModel cameraTypeFromJson(String str) => CameraTypeModel.fromJson(json.decode(str));

String cameraTypeToJson(CameraTypeModel data) => json.encode(data.toJson());

class CameraTypeModel {
  CameraTypeModel({
    required this.id,
    required this.type,
  });

  int? id;
  String? type;

  factory CameraTypeModel.fromJson(Map<String, dynamic> json) => CameraTypeModel(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}
