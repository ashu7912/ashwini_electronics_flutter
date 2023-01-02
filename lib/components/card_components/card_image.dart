import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ashwini_electronics/constants.dart';
import 'package:ashwini_electronics/config.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';



class CardImage extends StatelessWidget {
  const CardImage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final ProductModel? model;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kCardBorderRadius),
      child: CachedNetworkImage(
        key: UniqueKey(),
        imageUrl: '${Customconfig.apiURL}/products/${model!.id}/image',
        height: 62,
        // fit: BoxFit.cover,
        placeholder: (context, url) => CardPlaceholder(),
        errorWidget: (context, url, error) => CardPlaceholder(),
      ),
      // child: Image.network(
      //   '${Config.apiURL}/products/${model!.id}/image',
      //   height: 62,
      //   errorBuilder: (context, error, stackTrace) {
      //     return Image.asset(
      //       kLogoPlaceholderImage,
      //       height: 62,
      //       fit: BoxFit.scaleDown,
      //     );
      //   },
      //   key: ValueKey(new Random().nextInt(100)),
      // ),
    );
  }
}

class CardPlaceholder extends StatelessWidget {
  const CardPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kLogoPlaceholderImage,
      height: 62,
      fit: BoxFit.scaleDown,
    );
  }
}