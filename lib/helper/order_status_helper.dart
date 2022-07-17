import 'package:flutter/material.dart';

class OrderStatusHelper {
  int id;
  Color color;
  String i18nDesc;

  static OrderStatusHelper buying = OrderStatusHelper(0, Colors.blue, 'buying');
  static OrderStatusHelper confirm = OrderStatusHelper(1, Colors.green, 'confirm');
  static OrderStatusHelper deliverying = OrderStatusHelper(2, Colors.orange, 'deliverying');
  static OrderStatusHelper done = OrderStatusHelper(3, Colors.red, 'done');

  OrderStatusHelper(this.id, this.color, this.i18nDesc);

  static Color getColor(int id) {
    if (id == buying.id) {
      return buying.color;
    } else if (id == confirm.id) {
      return confirm.color;
    } else if (id == done.id) {
      return done.color;
    } else {
      return deliverying.color;
    }
  }

  static String getDesc(int id) {
    if (id == buying.id) {
      return buying.i18nDesc;
    } else if (id == confirm.id) {
      return confirm.i18nDesc;
    } else if (id == done.id) {
      return done.i18nDesc;
    } else {
      return deliverying.i18nDesc;
    }
  }
}
