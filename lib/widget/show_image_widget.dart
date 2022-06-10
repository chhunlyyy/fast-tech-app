import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_tech_app/helper/custom_cache_manager.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatefulWidget {
  final BoxFit boxFit;
  final String imageString;
  final double imageBorderRadius;
  const DisplayImage({Key? key, required this.imageString, required this.imageBorderRadius, required this.boxFit}) : super(key: key);

  @override
  _DisplayImageState createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  @override
  Widget build(BuildContext context) {
    String imageUrl = httpApiService.url.substring(0, httpApiService.url.length - 4) + widget.imageString;
    return CachedNetworkImage(
      cacheManager: CustomCacheManager(),
      fit: widget.boxFit,
      imageUrl: imageUrl,
      // placeholder: (context, imageUrl) => Image.asset('assets/images/placeholder.jpg'),
      errorWidget: (context, imageUrl, error) => Image.asset('assets/images/placeholder.jpg'),
    );
  }
}
