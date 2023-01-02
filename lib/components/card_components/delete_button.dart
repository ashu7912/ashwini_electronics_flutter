import 'package:flutter/material.dart';
import 'package:ashwini_electronics/models/product_model.dart';
import 'package:ashwini_electronics/constants.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.onDelete,
    required this.model,
  }) : super(key: key);

  final Function? onDelete;
  final ProductModel? model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 40,
        decoration: BoxDecoration(
          // color: Color(0xFFF5F5F5),
          color: kSecondary01,
          borderRadius: BorderRadius.circular(kCardDeleteRadius),
        ),
        child: const Icon(Icons.delete, color: kDangerColor),
      ),
      onTap: () {
        onDelete!(model);
      },
    );
  }
}
