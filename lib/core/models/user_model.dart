class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
  });

  int id;
  String name;
  String phone;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
      };
}
