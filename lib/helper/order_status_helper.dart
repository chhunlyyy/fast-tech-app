import 'package:flutter/material.dart';

class OrderStatusHelper {
  int id;
  Color color;
  String i18nDesc;

  static OrderStatusHelper buying = OrderStatusHelper(0, Colors.blue, 'buying');
  static OrderStatusHelper confirm = OrderStatusHelper(1, Colors.green, 'confrim');
  static OrderStatusHelper deliverying = OrderStatusHelper(2, Colors.orange, 'delivering');
  static OrderStatusHelper done = OrderStatusHelper(3, Colors.red, 'done');

  OrderStatusHelper(this.id, this.color, this.i18nDesc);

  static Color getColor(int id) {
    if (id == buying.id) {
      return buying.color;
    } else if (id == confirm.id) {
      return buying.color;
    } else {
      return done.color;
    }
  }

  static String getDesc(int id) {
    if (id == buying.id) {
      return buying.i18nDesc;
    } else if (id == confirm.id) {
      return buying.i18nDesc;
    } else {
      return done.i18nDesc;
    }
  }
}
