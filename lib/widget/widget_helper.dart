import 'package:flutter/material.dart';

class WidgetHepler {
  static Widget item({required BuildContext context, required IconData icon, required Color color, required String fileName, required String label, double iconSize = 18, double fontSize = 12}) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: iconSize,
          color: color,
        ),
        const SizedBox(width: 8),
        //Expanded(child: Text(fileName ?? label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: fontSize),)),
        Expanded(
            child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color, fontSize: fontSize),
        )),
      ],
    );
  }
}
