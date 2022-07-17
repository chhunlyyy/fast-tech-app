import 'dart:convert';

import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/core/models/user_model.dart';

PickupOrderModel pickupOrderModelFromJson(String str) => PickupOrderModel.fromJson(json.decode(str));

String pickupOrderModelToJson(PickupOrderModel data) => json.encode(data.toJson());

class PickupOrderModel {
  PickupOrderModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.colorId,
    required this.qty,
    required this.deliveryType,
    required this.status,
    required this.addressIdRef,
    required this.product,
    required this.user,
  });

  int id;
  int userId;
  int productId;
  int colorId;
  int qty;
  int deliveryType;
  int status;
  String addressIdRef;
  Product product;
  UserModel user;

  factory PickupOrderModel.fromJson(Map<String, dynamic> json) => PickupOrderModel(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        colorId: json["color_id"],
        qty: json["qty"],
        deliveryType: json["delivery_type"],
        status: json["status"],
        addressIdRef: json["address_id_ref"],
        product: Product.fromJson(json["product"]),
        user: UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "color_id": colorId,
        "qty": qty,
        "delivery_type": deliveryType,
        "status": status,
        "address_id_ref": addressIdRef,
        "product": product.toJson(),
      };
}

class Product {
  Product({
    required this.id,
    required this.idRef,
    required this.name,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.isWarranty,
    required this.warrantyPeriod,
    required this.minQty,
    required this.isCamera,
    required this.colors,
    required this.images,
    required this.details,
  });

  int id;
  String idRef;
  String name;
  int price;
  int discount;
  int priceAfterDiscount;
  int isWarranty;
  String warrantyPeriod;
  int minQty;
  int isCamera;
  List<ColorModel> colors;
  List<ImageModel> images;
  List<DetailModel> details;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        idRef: json["id_ref"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
        isWarranty: json["is_warranty"],
        warrantyPeriod: json["warranty_period"],
        minQty: json["min_qty"],
        isCamera: json["is_camera"],
        colors: List<ColorModel>.from(json["colors"].map((x) => ColorModel.fromJson(x))),
        images: List<ImageModel>.from(json["images"].map((x) => ImageModel.fromJson(x))),
        details: List<DetailModel>.from(json["details"].map((x) => DetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_ref": idRef,
        "name": name,
        "price": price,
        "discount": discount,
        "price_after_discount": priceAfterDiscount,
        "is_warranty": isWarranty,
        "warranty_period": warrantyPeriod,
        "min_qty": minQty,
        "is_camera": isCamera,
        "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}
