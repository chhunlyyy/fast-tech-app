import 'package:flutter/material.dart';

class GridViewWidget {
  static Widget gridView({required BuildContext context, required List<Widget> children, double cellHeight = 300, int crossAxisCount = 2, int crossAxisCountForBigScreen = 3}) {
    var _crossAxisSpacing = 10;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = _screenWidth > 440 ? crossAxisCountForBigScreen : crossAxisCount;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) / _crossAxisCount;
    var _aspectRatio = _width / cellHeight;
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: _crossAxisCount,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(1.0),
      childAspectRatio: _aspectRatio,
      children: children,
    );
  }
}
