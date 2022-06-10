import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowFullScreenImageWidget extends StatelessWidget {
  final String image;
  const ShowFullScreenImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: DisplayImage(
                    imageString: image,
                    imageBorderRadius: 0,
                    boxFit: BoxFit.contain,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.red,
                            ),
                          )),
                    ))
              ],
            )),
      ),
    );
  }
}
