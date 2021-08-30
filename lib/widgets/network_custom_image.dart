import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkCustomImage extends StatelessWidget {
  String imageURL;

  NetworkCustomImage(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      maxHeightDiskCache: 500,
      imageUrl: this.imageURL,
      fit: BoxFit.contain,
      placeholder: (context, url) => Padding(
        child: CircularProgressIndicator(),
        padding: EdgeInsets.all(20.0),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
