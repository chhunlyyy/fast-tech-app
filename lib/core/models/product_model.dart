import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.id,
    required this.idRef,
    required this.name,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount,
    required this.isWarranty,
    required this.warrantyPeriod,
    required this.minQty,
    required this.colors,
    required this.images,
    required this.details,
    required this.isCamera,
    required this.cameraType,
    required this.cameraTypeId,
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
  int? cameraTypeId;
  String? cameraType;
  List<ColorModel> colors;
  List<ImageModel> images;
  List<DetailModel> details;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        idRef: json["id_ref"],
        name: json["name"],
        price: json["price"],
        discount: json["discount"],
        priceAfterDiscount: json["price_after_discount"],
        isWarranty: json["is_warranty"],
        warrantyPeriod: json["warranty_period"],
        minQty: json["min_qty"],
        cameraTypeId: json["camera_type_id"],
        cameraType: json["camera_type"],
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
        "colors": List<dynamic>.from(colors.map((x) => x.toJson())),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class ColorModel {
  ColorModel({
    required this.id,
    required this.productIdRef,
    required this.color,
    required this.colorCode,
  });

  int id;
  String productIdRef;
  String color;
  String colorCode;

  factory ColorModel.fromJson(Map<String, dynamic> json) => ColorModel(
        id: json["id"],
        productIdRef: json["product_id_ref"],
        color: json["color"],
        colorCode: json["color_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id_ref": productIdRef,
        "color": color,
        "color_code": colorCode,
      };
}

class DetailModel {
  DetailModel({
    required this.id,
    required this.productIdRef,
    required this.detail,
    required this.descs,
  });

  int id;
  String productIdRef;
  String detail;
  String descs;

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        id: json["id"],
        productIdRef: json["product_id_ref"],
        detail: json["detail"],
        descs: json["descs"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id_ref": productIdRef,
        "detail": detail,
        "descs": descs,
      };
}

class ImageModel {
  ImageModel({
    required this.id,
    required this.productIdRef,
    required this.image,
  });

  int id;
  String productIdRef;
  String image;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        productIdRef: json["product_id_ref"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id_ref": productIdRef,
        "image": image,
      };
}
