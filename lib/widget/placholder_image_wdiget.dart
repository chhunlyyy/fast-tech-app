import 'package:flutter/material.dart';

class PlaceholderImageWidget extends StatelessWidget {
  const PlaceholderImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: Image.asset('assets/images/placeholder.jpg').image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
