// ignore_for_file: non_constant_identifier_names

class ProductInsertModel {
  ProductInsertModel(this.id_ref, this.name, this.price, this.discount, this.is_warranty, this.min_qty, this.price_after_discount, this.warranty_period, this.is_camera);

  String id_ref;
  String name;
  double price;
  double discount;
  double price_after_discount;
  int is_warranty;
  String warranty_period;
  int min_qty;
  int is_camera;
}
