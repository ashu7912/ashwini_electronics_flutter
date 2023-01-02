import 'package:flutter/material.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/constants.dart';

import 'package:ashwini_electronics/components/card_components/card_image.dart';
import 'package:ashwini_electronics/components/card_components/delete_button.dart';

class ProductItem extends StatelessWidget {
  final ProductModel? model;
  final Function? onDelete;
  final String? updatedDate;
  const ProductItem({Key? key, this.model, this.onDelete, this.updatedDate})
      : super(key: key);

  String getProductCount() {
    if (model!.count!! < 99) {
      return model!.count.toString();
    } else {
      return '99+';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kCardElevation,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: kCardBgColor,
            borderRadius: BorderRadius.circular(kCardBorderRadius),
          ),
          child: productWidget(context),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            kEditProductRoute,
            arguments: {'model': model},
          );
        },
      ),
    );
  }

  Widget productWidget(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            child: CardImage(model: model),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              kUploadProductImage,
              arguments: {'model': model},
            );
          },
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 3, top: 12, right: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width-225,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        model!.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kPrimary01,
                          fontWeight: FontWeight.normal,
                          fontSize: kFont17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Selling Price ₹ ${model!.sellingPrice}",
                        style: const TextStyle(
                            color: kTextSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: kFont14),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Created at $updatedDate",
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: kFont12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: kCardCountSize,
                      height: kCardCountSize,
                      decoration: BoxDecoration(
                        color: kPrimary03,
                        borderRadius: BorderRadius.circular(kCardCountRadius),
                      ),
                      child: Center(
                        child: Text(
                          getProductCount(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kCardCountColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    // GestureDetector(
                    //   child: Container(
                    //     height: 50,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //       // color: Color(0xFFF5F5F5),
                    //       color: Color(0xaaF5F5F5),
                    //       borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: Icon(
                    //         Icons.edit,
                    //         color: kPrimary01,
                    //       size: 22,
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Navigator.of(context).pushNamed('/edit-product', arguments: { 'model':model});
                    //   },
                    // ),
                    const SizedBox(width: 10),
                    DeleteButton(onDelete: onDelete, model: model)
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
