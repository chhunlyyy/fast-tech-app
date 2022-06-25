import 'package:fast_tech_app/core/models/product_model.dart';
import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.colorId,
    required this.qty,
    required this.product,
  });

  int id;
  int productId;
  int userId;
  int colorId;
  int qty;
  Product product;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        colorId: json["color_id"],
        qty: json["qty"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "color_id": colorId,
        "qty": qty,
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
