import 'dart:ui';
import 'package:flutter/material.dart';

import '../../const/color_conts.dart';

Color colorOne = ColorsConts.primaryColor;
Color? colorTwo = ColorsConts.primaryColor.withOpacity(.5);
Color? colorThree = ColorsConts.primaryColor.withOpacity(.3);

final appTheme = ThemeData(
  primarySwatch: Colors.red,
);
